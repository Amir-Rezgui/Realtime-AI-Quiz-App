-- Allow host to write chat messages
ALTER TABLE public.chat_messages
    DROP CONSTRAINT IF EXISTS chat_messages_player_id_fkey;

ALTER TABLE public.chat_messages
    ALTER COLUMN player_id DROP NOT NULL;

ALTER TABLE public.chat_messages
    ADD COLUMN IF NOT EXISTS host_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE;

ALTER TABLE public.chat_messages
    ADD CONSTRAINT chat_messages_sender_check
    CHECK (
        (player_id IS NOT NULL AND host_id IS NULL) OR
        (player_id IS NULL AND host_id IS NOT NULL)
    );
