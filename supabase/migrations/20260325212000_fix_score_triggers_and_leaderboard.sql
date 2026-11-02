-- Prevent double counting: score is evaluated in app at question end.
DROP TRIGGER IF EXISTS on_answer_submitted ON public.player_answers;

-- Keep leaderboard function deterministic and ordered by total score.
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
            (SELECT COUNT(*)::INTEGER FROM public.player_answers pa
             WHERE pa.player_id = p.id AND pa.is_correct = TRUE),
            0
        ) AS correct_answers,
        p.current_streak,
        DENSE_RANK() OVER (ORDER BY p.total_score DESC, p.joined_at ASC)::INTEGER AS rank
    FROM public.players p
    WHERE p.session_id = p_session_id
    ORDER BY p.total_score DESC, p.joined_at ASC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
