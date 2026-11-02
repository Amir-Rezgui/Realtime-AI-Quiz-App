-- =============================================
-- Quiz App Database Schema
-- =============================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================
-- TABLES
-- =============================================

-- Profiles table (linked to Supabase Auth)
CREATE TABLE public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL,
    display_name TEXT,
    avatar_url TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Quizzes table
CREATE TABLE public.quizzes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    creator_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    is_published BOOLEAN DEFAULT FALSE,
    settings JSONB DEFAULT '{"shuffle_questions": false, "shuffle_answers": false}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Questions table
CREATE TABLE public.questions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    quiz_id UUID NOT NULL REFERENCES public.quizzes(id) ON DELETE CASCADE,
    order_index INTEGER NOT NULL,
    question_text TEXT NOT NULL,
    question_type TEXT NOT NULL DEFAULT 'single_choice',
    points INTEGER NOT NULL DEFAULT 1000,
    time_limit_seconds INTEGER NOT NULL DEFAULT 20,
    created_at TIMESTAMPTZ DEFAULT NOW(),

    CONSTRAINT valid_question_type CHECK (question_type IN ('single_choice', 'multiple_choice')),
    CONSTRAINT valid_points CHECK (points > 0 AND points <= 2000),
    CONSTRAINT valid_time_limit CHECK (time_limit_seconds >= 5 AND time_limit_seconds <= 120)
);

CREATE INDEX idx_questions_quiz_order ON public.questions(quiz_id, order_index);

-- Answers table (choices for questions)
CREATE TABLE public.answers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    question_id UUID NOT NULL REFERENCES public.questions(id) ON DELETE CASCADE,
    order_index INTEGER NOT NULL,
    answer_text TEXT NOT NULL,
    is_correct BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_answers_question ON public.answers(question_id, order_index);

-- Game Sessions table (live quiz sessions)
CREATE TABLE public.game_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    quiz_id UUID NOT NULL REFERENCES public.quizzes(id) ON DELETE CASCADE,
    host_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE CASCADE,
    join_code TEXT NOT NULL UNIQUE,
    status TEXT NOT NULL DEFAULT 'lobby',
    current_question_index INTEGER DEFAULT 0,
    question_started_at TIMESTAMPTZ,
    player_count INTEGER DEFAULT 0,
    settings JSONB DEFAULT '{"show_leaderboard_after_each": true}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    finished_at TIMESTAMPTZ,

    CONSTRAINT valid_status CHECK (status IN ('lobby', 'in_progress', 'question_active', 'showing_results', 'finished')),
    CONSTRAINT valid_join_code CHECK (LENGTH(join_code) = 6)
);

CREATE INDEX idx_game_sessions_join_code ON public.game_sessions(join_code) WHERE status != 'finished';
CREATE INDEX idx_game_sessions_host ON public.game_sessions(host_id, created_at DESC);

-- Players table (guest participants)
CREATE TABLE public.players (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL REFERENCES public.game_sessions(id) ON DELETE CASCADE,
    nickname TEXT NOT NULL,
    avatar_seed TEXT,
    total_score INTEGER DEFAULT 0,
    current_streak INTEGER DEFAULT 0,
    is_connected BOOLEAN DEFAULT TRUE,
    joined_at TIMESTAMPTZ DEFAULT NOW(),
    last_seen_at TIMESTAMPTZ DEFAULT NOW(),

    CONSTRAINT unique_nickname_per_session UNIQUE (session_id, nickname),
    CONSTRAINT valid_nickname CHECK (LENGTH(TRIM(nickname)) >= 2 AND LENGTH(nickname) <= 20)
);

CREATE INDEX idx_players_session ON public.players(session_id) WHERE is_connected = TRUE;

-- Player Answers table (responses to questions)
CREATE TABLE public.player_answers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    player_id UUID NOT NULL REFERENCES public.players(id) ON DELETE CASCADE,
    question_id UUID NOT NULL REFERENCES public.questions(id) ON DELETE CASCADE,
    session_id UUID NOT NULL REFERENCES public.game_sessions(id) ON DELETE CASCADE,
    selected_answer_ids UUID[] NOT NULL,
    is_correct BOOLEAN NOT NULL,
    response_time_ms INTEGER NOT NULL,
    points_earned INTEGER NOT NULL DEFAULT 0,
    answered_at TIMESTAMPTZ DEFAULT NOW(),

    CONSTRAINT unique_player_question UNIQUE (player_id, question_id),
    CONSTRAINT valid_response_time CHECK (response_time_ms >= 0)
);

CREATE INDEX idx_player_answers_session_question ON public.player_answers(session_id, question_id);
CREATE INDEX idx_player_answers_player ON public.player_answers(player_id);

-- =============================================
-- FUNCTIONS
-- =============================================

-- Generate unique 6-character join code
CREATE OR REPLACE FUNCTION generate_join_code()
RETURNS TEXT AS $$
DECLARE
    chars TEXT := 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';
    new_code TEXT := '';
    i INTEGER;
BEGIN
    LOOP
        new_code := '';
        FOR i IN 1..6 LOOP
            new_code := new_code || substr(chars, floor(random() * 30 + 1)::int, 1);
        END LOOP;

        EXIT WHEN NOT EXISTS (
            SELECT 1 FROM public.game_sessions
            WHERE join_code = new_code
            AND status != 'finished'
        );
    END LOOP;

    RETURN new_code;
END;
$$ LANGUAGE plpgsql;

-- Calculate points for an answer
CREATE OR REPLACE FUNCTION calculate_points(
    base_points INTEGER,
    time_limit_ms INTEGER,
    response_time_ms INTEGER,
    is_correct BOOLEAN
)
RETURNS INTEGER AS $$
BEGIN
    IF NOT is_correct THEN
        RETURN 0;
    END IF;

    RETURN GREATEST(
        (base_points * 0.5)::INTEGER,
        (base_points * (1.0 - (response_time_ms::FLOAT / time_limit_ms::FLOAT) * 0.5))::INTEGER
    );
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- Get session leaderboard
CREATE OR REPLACE FUNCTION get_session_leaderboard(p_session_id UUID)
RETURNS TABLE (
    player_id UUID,
    nickname TEXT,
    avatar_seed TEXT,
    total_score INTEGER,
    correct_answers INTEGER,
    current_streak INTEGER,
    rank INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.id,
        p.nickname,
        p.avatar_seed,
        p.total_score,
        COALESCE(
            (SELECT COUNT(*)::INTEGER FROM public.player_answers pa WHERE pa.player_id = p.id AND pa.is_correct = TRUE),
            0
        ) as correct_answers,
        p.current_streak,
        DENSE_RANK() OVER (ORDER BY p.total_score DESC)::INTEGER as rank
    FROM public.players p
    WHERE p.session_id = p_session_id
    ORDER BY p.total_score DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Handle new user registration
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.profiles (id, email, display_name)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'display_name', split_part(NEW.email, '@', 1))
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Update player count in session
CREATE OR REPLACE FUNCTION update_player_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        UPDATE public.game_sessions
        SET player_count = player_count + 1
        WHERE id = NEW.session_id;
    ELSIF TG_OP = 'DELETE' THEN
        UPDATE public.game_sessions
        SET player_count = player_count - 1
        WHERE id = OLD.session_id;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Update player score and streak
CREATE OR REPLACE FUNCTION update_player_score()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE public.players
    SET
        total_score = total_score + NEW.points_earned,
        current_streak = CASE
            WHEN NEW.is_correct THEN current_streak + 1
            ELSE 0
        END
    WHERE id = NEW.player_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =============================================
-- TRIGGERS
-- =============================================

-- Auto-create profile on user signup
CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- Update timestamps
CREATE TRIGGER update_profiles_updated_at
    BEFORE UPDATE ON public.profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_quizzes_updated_at
    BEFORE UPDATE ON public.quizzes
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Update player count
CREATE TRIGGER on_player_joined
    AFTER INSERT ON public.players
    FOR EACH ROW EXECUTE FUNCTION update_player_count();

CREATE TRIGGER on_player_left
    AFTER DELETE ON public.players
    FOR EACH ROW EXECUTE FUNCTION update_player_count();

-- Update player score
CREATE TRIGGER on_answer_submitted
    AFTER INSERT ON public.player_answers
    FOR EACH ROW EXECUTE FUNCTION update_player_score();

-- =============================================
-- ROW LEVEL SECURITY
-- =============================================

-- Enable RLS on all tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.quizzes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.answers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.game_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.players ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.player_answers ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "profiles_select" ON public.profiles
    FOR SELECT USING (TRUE);

CREATE POLICY "profiles_update" ON public.profiles
    FOR UPDATE USING (auth.uid() = id);

-- Quizzes policies
CREATE POLICY "quizzes_select" ON public.quizzes
    FOR SELECT USING (creator_id = auth.uid() OR is_published = TRUE);

CREATE POLICY "quizzes_insert" ON public.quizzes
    FOR INSERT WITH CHECK (creator_id = auth.uid());

CREATE POLICY "quizzes_update" ON public.quizzes
    FOR UPDATE USING (creator_id = auth.uid());

CREATE POLICY "quizzes_delete" ON public.quizzes
    FOR DELETE USING (creator_id = auth.uid());

-- Questions policies
CREATE POLICY "questions_select" ON public.questions
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.quizzes q
            WHERE q.id = quiz_id
            AND (q.creator_id = auth.uid() OR q.is_published = TRUE)
        )
    );

CREATE POLICY "questions_insert" ON public.questions
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.quizzes q
            WHERE q.id = quiz_id AND q.creator_id = auth.uid()
        )
    );

CREATE POLICY "questions_update" ON public.questions
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM public.quizzes q
            WHERE q.id = quiz_id AND q.creator_id = auth.uid()
        )
    );

CREATE POLICY "questions_delete" ON public.questions
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM public.quizzes q
            WHERE q.id = quiz_id AND q.creator_id = auth.uid()
        )
    );

-- Answers policies
CREATE POLICY "answers_select" ON public.answers
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.questions qt
            JOIN public.quizzes q ON q.id = qt.quiz_id
            WHERE qt.id = question_id
            AND (q.creator_id = auth.uid() OR q.is_published = TRUE)
        )
    );

CREATE POLICY "answers_insert" ON public.answers
    FOR INSERT WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.questions qt
            JOIN public.quizzes q ON q.id = qt.quiz_id
            WHERE qt.id = question_id AND q.creator_id = auth.uid()
        )
    );

CREATE POLICY "answers_update" ON public.answers
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM public.questions qt
            JOIN public.quizzes q ON q.id = qt.quiz_id
            WHERE qt.id = question_id AND q.creator_id = auth.uid()
        )
    );

CREATE POLICY "answers_delete" ON public.answers
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM public.questions qt
            JOIN public.quizzes q ON q.id = qt.quiz_id
            WHERE qt.id = question_id AND q.creator_id = auth.uid()
        )
    );

-- Game Sessions policies
CREATE POLICY "sessions_select" ON public.game_sessions
    FOR SELECT USING (TRUE);

CREATE POLICY "sessions_insert" ON public.game_sessions
    FOR INSERT WITH CHECK (host_id = auth.uid());

CREATE POLICY "sessions_update" ON public.game_sessions
    FOR UPDATE USING (host_id = auth.uid());

CREATE POLICY "sessions_delete" ON public.game_sessions
    FOR DELETE USING (host_id = auth.uid());

-- Players policies (anonymous access for guests)
CREATE POLICY "players_select" ON public.players
    FOR SELECT USING (TRUE);

CREATE POLICY "players_insert" ON public.players
    FOR INSERT WITH CHECK (TRUE);

CREATE POLICY "players_update" ON public.players
    FOR UPDATE USING (TRUE);

CREATE POLICY "players_delete" ON public.players
    FOR DELETE USING (
        EXISTS (
            SELECT 1 FROM public.game_sessions gs
            WHERE gs.id = session_id AND gs.host_id = auth.uid()
        )
    );

-- Player Answers policies
CREATE POLICY "player_answers_select" ON public.player_answers
    FOR SELECT USING (TRUE);

CREATE POLICY "player_answers_insert" ON public.player_answers
    FOR INSERT WITH CHECK (TRUE);

-- =============================================
-- REALTIME SUBSCRIPTIONS
-- =============================================

-- Enable realtime for game-related tables
ALTER PUBLICATION supabase_realtime ADD TABLE public.game_sessions;
ALTER PUBLICATION supabase_realtime ADD TABLE public.players;
ALTER PUBLICATION supabase_realtime ADD TABLE public.player_answers;
