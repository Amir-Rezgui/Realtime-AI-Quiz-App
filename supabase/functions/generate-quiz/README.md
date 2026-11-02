# generate-quiz edge function

Creates quiz drafts for the Flutter quiz editor.

The function uses Groq when an API key is available and returns an error if the provider is unavailable.

## Optional Supabase secrets

Set these in your Supabase project if you want cloud AI generation:

- `GROQ_API_KEY_FREE`
- `GROQ_MODEL_FREE` (optional, default: `llama-3.1-8b-instant`)

If these secrets are not set, the function returns an error.

## Deploy

```bash
supabase functions deploy generate-quiz
```

## Local serve

```bash
supabase functions serve generate-quiz --no-verify-jwt
```

## Request body

```json
{
  "topic": "Solar system",
  "difficulty": "medium",
  "questionCount": 5,
  "language": "anglais",
  "additionalInstructions": "Include one trick question"
}
```

## Constraints enforced

- `questionCount`: 1..15
- `language`: `anglais` or `francais`
- `questionType`: forced to `single_choice`

## Generation mode

- `Groq AI`: used when `GROQ_API_KEY_FREE` is set.

## Response body

```json
{
  "title": "...",
  "description": "...",
  "category": "science",
  "questions": [
    {
      "questionText": "...",
      "questionType": "single_choice",
      "points": 1000,
      "timeLimitSeconds": 20,
      "answers": [
        { "answerText": "...", "isCorrect": true },
        { "answerText": "...", "isCorrect": false }
      ]
    }
  ]
}
```
