-- =====================================================
-- DROP EVERYTHING - Interactive Teaching Platform
-- =====================================================

-- Drop triggers first
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP TRIGGER IF EXISTS update_profiles_updated_at ON public.profiles;
DROP TRIGGER IF EXISTS update_rooms_updated_at ON public.rooms;
DROP TRIGGER IF EXISTS update_topics_updated_at ON public.topics;
DROP TRIGGER IF EXISTS update_submissions_updated_at ON public.submissions;

-- Drop functions
DROP FUNCTION IF EXISTS public.handle_new_user();
DROP FUNCTION IF EXISTS update_updated_at_column();
DROP FUNCTION IF EXISTS generate_room_code();
DROP FUNCTION IF EXISTS create_anonymous_token(UUID, TEXT);
DROP FUNCTION IF EXISTS get_session_leaderboard(UUID);
DROP FUNCTION IF EXISTS cleanup_expired_tokens();

-- Drop tables (order matters - children before parents)
DROP TABLE IF EXISTS public.notifications CASCADE;
DROP TABLE IF EXISTS public.shared_files CASCADE;
DROP TABLE IF EXISTS public.feedback_responses CASCADE;
DROP TABLE IF EXISTS public.feedback_forms CASCADE;
DROP TABLE IF EXISTS public.submissions CASCADE;
DROP TABLE IF EXISTS public.submission_windows CASCADE;
DROP TABLE IF EXISTS public.quiz_answers CASCADE;
DROP TABLE IF EXISTS public.quiz_attempts CASCADE;
DROP TABLE IF EXISTS public.quiz_questions CASCADE;
DROP TABLE IF EXISTS public.quizzes CASCADE;
DROP TABLE IF EXISTS public.anonymous_tokens CASCADE;
DROP TABLE IF EXISTS public.answers CASCADE;
DROP TABLE IF EXISTS public.session_participants CASCADE;
DROP TABLE IF EXISTS public.questions CASCADE;
DROP TABLE IF EXISTS public.sessions CASCADE;
DROP TABLE IF EXISTS public.topics CASCADE;
DROP TABLE IF EXISTS public.room_members CASCADE;
DROP TABLE IF EXISTS public.rooms CASCADE;
DROP TABLE IF EXISTS public.profiles CASCADE;

-- Drop extensions (optional - remove these lines if other projects use them)
DROP EXTENSION IF EXISTS "pgcrypto";
DROP EXTENSION IF EXISTS "uuid-ossp";