declare const Deno: {
  env: {
    get(key: string): string | undefined;
  };
  serve(handler: (req: Request) => Response | Promise<Response>): void;
};

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type, x-client-jwt',
};

type GenerateRequest = {
  topic: string;
  difficulty: 'easy' | 'medium' | 'hard';
  questionCount: number;
  language: 'anglais' | 'francais';
  additionalInstructions?: string;
};

type AIAnswer = {
  answerText: string;
  isCorrect: boolean;
};

type AIQuestion = {
  questionText: string;
  questionType: 'single_choice' | 'multiple_choice';
  points: number;
  timeLimitSeconds: number;
  answers: AIAnswer[];
};

type AIQuiz = {
  title: string;
  description: string;
  category: string;
  questions: AIQuestion[];
};

type ProviderFailure = {
  status: number;
  model: string;
  details: string;
};

type ProviderConfig = {
  apiKey: string | null;
  modelCandidates: string[];
};

type ProviderResult =
  | { ok: true; quiz: AIQuiz }
  | { ok: false; error: string; status: number; model?: string; details?: string };

const allowedCategories = new Set([
  'science',
  'technology',
  'culture',
  'history',
  'sports',
  'geography',
  'entertainment',
  'general',
]);

Deno.serve(async (req: Request) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const body = (await req.json()) as Partial<GenerateRequest>;
    const parsed = parseRequest(body);
    if (!parsed.ok) {
      return jsonResponse({ error: parsed.error }, 400);
    }

    const providerConfig = getProviderConfig();
    const providerResult = providerConfig.apiKey
      ? await generateWithGroq(parsed.value, providerConfig)
      : {
          ok: false as const,
          error: 'No Groq provider configured',
          status: 500,
        };

    if (providerResult.ok) {
      return jsonResponse(providerResult.quiz, 200);
    }

    return jsonResponse(
      {
        error: providerResult.error,
        providerStatus: providerResult.status,
        providerDetails: providerResult.details,
      },
      providerResult.status || 500,
    );
  } catch (error) {
    const message = error instanceof Error ? error.message : 'Unknown error';
    return jsonResponse({ error: message }, 500);
  }
});

function getProviderConfig(): ProviderConfig {
  const apiKey =
    Deno.env.get('GROQ_API_KEY_FREE')?.trim() ??
    Deno.env.get('GROQ_API_KEY')?.trim() ??
    null;

  const configuredModel =
    Deno.env.get('GROQ_MODEL_FREE')?.trim() ??
    Deno.env.get('GROQ_MODEL')?.trim();

  const modelCandidates = [
    configuredModel,
    'llama-3.1-8b-instant',
    'llama-3.3-70b-versatile',
    'gemma2-9b-it',
  ].filter((m, index, arr): m is string => Boolean(m) && arr.indexOf(m) === index);

  return {
    apiKey,
    modelCandidates,
  };
}

async function generateWithGroq(
  input: GenerateRequest,
  providerConfig: ProviderConfig,
): Promise<ProviderResult> {
  const providerFailures: ProviderFailure[] = [];

  for (const model of providerConfig.modelCandidates) {
    const response = await fetch('https://api.groq.com/openai/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${providerConfig.apiKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model,
        messages: [
          {
            role: 'system',
            content:
              'You are a quiz generator. Return strict JSON only. No markdown and no comments.',
          },
          {
            role: 'user',
            content: buildPrompt(input),
          },
        ],
        temperature: 0.7,
        max_tokens: 2500,
      }),
    });

    if (!response.ok) {
      const errorText = await response.text();
      providerFailures.push({
        status: response.status,
        model,
        details: errorText,
      });

      const canRetryModel =
        response.status === 404 ||
        response.status === 429 ||
        response.status === 400 ||
        errorText.toLowerCase().includes('model') ||
        errorText.toLowerCase().includes('rate limit');
      if (canRetryModel) {
        continue;
      }

      return {
        ok: false,
        error: 'AI provider returned an error.',
        status: response.status,
        model,
        details: errorText,
      };
    }

    const completionJson = await response.json();
    const content = completionJson?.choices?.[0]?.message?.content;

    if (!content || typeof content !== 'string') {
      return {
        ok: false,
        error: 'AI provider response is empty.',
        status: 502,
        model,
        details: JSON.stringify(completionJson).slice(0, 1200),
      };
    }

    let draft: unknown;
    try {
      draft = JSON.parse(content);
    } catch {
      return {
        ok: false,
        error: 'AI provider returned invalid JSON format.',
        status: 502,
        model,
        details: content.slice(0, 1200),
      };
    }

    return {
      ok: true,
      quiz: sanitizeAIOutput(draft, input),
    };
  }

  return {
    ok: false,
    error: 'AI provider model fallback exhausted.',
    status: providerFailures.some((failure) => failure.status === 429) ? 429 : 502,
    details: JSON.stringify(providerFailures.slice(0, 3)).slice(0, 1200),
  };
}

function parseRequest(body: Partial<GenerateRequest>):
  | { ok: true; value: GenerateRequest }
  | { ok: false; error: string } {
  const topic = body.topic?.trim();
  if (!topic) {
    return { ok: false, error: 'topic is required' };
  }

  const difficulty = (body.difficulty ?? 'medium').toLowerCase();
  if (!['easy', 'medium', 'hard'].includes(difficulty)) {
    return { ok: false, error: 'difficulty must be easy, medium, or hard' };
  }

  const language = normalizeLanguage(body.language);
  if (language == null) {
    return { ok: false, error: 'language must be anglais or francais' };
  }

  const questionCount = Number(body.questionCount ?? 5);
  if (!Number.isFinite(questionCount) || questionCount < 1 || questionCount > 15) {
    return { ok: false, error: 'questionCount must be between 1 and 15' };
  }

  return {
    ok: true,
    value: {
      topic,
      difficulty: difficulty as GenerateRequest['difficulty'],
      questionCount: Math.trunc(questionCount),
      language,
      additionalInstructions: body.additionalInstructions?.trim(),
    },
  };
}

function normalizeLanguage(value: unknown): GenerateRequest['language'] | null {
  if (typeof value !== 'string') return 'anglais';
  const normalized = value.trim().toLowerCase();
  if (normalized === 'anglais' || normalized === 'english') return 'anglais';
  if (normalized === 'francais' || normalized === 'français' || normalized === 'french') {
    return 'francais';
  }
  return null;
}

function buildPrompt(input: GenerateRequest): string {
  const extra = input.additionalInstructions
    ? `\nAdditional constraints: ${input.additionalInstructions}`
    : '';

  return [
    `Generate a ${input.difficulty} quiz about: ${input.topic}.`,
    `Language: ${input.language}.`,
    `Question count: ${input.questionCount}.`,
    'Question type: single_choice only.',
    'Use one of these categories exactly:',
    'science, technology, culture, history, sports, geography, entertainment, general.',
    'Return JSON with this exact shape:',
    '{',
    '  "title": "string",',
    '  "description": "string",',
    '  "category": "one-of-the-listed-categories",',
    '  "questions": [',
    '    {',
    '      "questionText": "string",',
    '      "questionType": "single_choice",',
    '      "points": 500|1000|1500|2000,',
    '      "timeLimitSeconds": 10|20|30|45|60,',
    '      "answers": [',
    '        {"answerText": "string", "isCorrect": true|false}',
    '      ]',
    '    }',
    '  ]',
    '}',
    'Rules:',
    '- Every question must have between 2 and 6 answers.',
    '- At least one answer is correct.',
    '- Exactly one answer must be correct for each question.',
    '- No markdown. Return JSON only.',
    extra,
  ].join('\n');
}

function capitalize(value: string): string {
  const trimmed = value.trim();
  if (!trimmed) return 'Quiz';
  return trimmed.charAt(0).toUpperCase() + trimmed.slice(1);
}

function shuffleArray<T>(items: T[]): T[] {
  const copy = [...items];
  for (let index = copy.length - 1; index > 0; index--) {
    const swapIndex = Math.floor(Math.random() * (index + 1));
    [copy[index], copy[swapIndex]] = [copy[swapIndex], copy[index]];
  }
  return copy;
}

function sanitizeAIOutput(raw: unknown, req: GenerateRequest): AIQuiz {
  const source = requireObject(raw, 'AI output is not an object');
  const fallbackTitle = `Quiz: ${req.topic}`;
  const fallbackDescription = `AI generated quiz about ${req.topic}`;

  const title = toNonEmptyString(source.title) ?? fallbackTitle;
  const description = toNonEmptyString(source.description) ?? fallbackDescription;
  const category = normalizeCategory(source.category);
  const questions = sanitizeQuestions(source.questions, req.questionCount);

  if (questions.length === 0) {
    throw new Error('AI produced no valid questions');
  }

  return {
    title,
    description,
    category,
    questions,
  };
}

function sanitizeQuestions(rawQuestions: unknown, questionLimit: number): AIQuestion[] {
  if (!Array.isArray(rawQuestions)) return [];

  const questions: AIQuestion[] = [];
  for (const questionItem of rawQuestions) {
    const question = sanitizeQuestion(questionItem);
    if (question) {
      questions.push(question);
    }

    if (questions.length >= questionLimit) {
      break;
    }
  }

  return questions;
}

function sanitizeQuestion(questionItem: unknown): AIQuestion | null {
  const q = asObject(questionItem);
  if (!q) return null;

  const questionText = toNonEmptyString(q.questionText);
  if (!questionText) return null;

  const answers = sanitizeAnswers(q.answers);
  if (answers.length < 2 || answers.length > 6) return null;

  const correctedAnswers = enforceSingleCorrectAnswer(answers);
  if (!correctedAnswers.some((answer) => answer.isCorrect)) return null;

  return {
    questionText,
    questionType: normalizeQuestionType(toNonEmptyString(q.questionType) ?? 'single_choice'),
    points: normalizeFromSet(toNumber(q.points), [500, 1000, 1500, 2000], 1000),
    timeLimitSeconds: normalizeFromSet(toNumber(q.timeLimitSeconds), [10, 20, 30, 45, 60], 20),
    answers: correctedAnswers,
  };
}

function sanitizeAnswers(rawAnswers: unknown): AIAnswer[] {
  if (!Array.isArray(rawAnswers)) return [];

  const answers: AIAnswer[] = [];
  for (const answerItem of rawAnswers) {
    const a = asObject(answerItem);
    if (!a) continue;

    const answerText = toNonEmptyString(a.answerText);
    if (!answerText) continue;

    answers.push({
      answerText,
      isCorrect: Boolean(a.isCorrect),
    });
  }

  return answers;
}

function enforceSingleCorrectAnswer(answers: AIAnswer[]): AIAnswer[] {
  const corrected = answers.map((answer) => ({ ...answer }));
  const firstCorrectIndex = corrected.findIndex((answer) => answer.isCorrect);

  if (firstCorrectIndex === -1) {
    corrected[0].isCorrect = true;
    return corrected;
  }

  for (let index = 0; index < corrected.length; index++) {
    corrected[index].isCorrect = index === firstCorrectIndex;
  }

  return corrected;
}

function normalizeCategory(raw: unknown): string {
  const category = toNonEmptyString(raw)?.toLowerCase() ?? 'general';
  return allowedCategories.has(category) ? category : 'general';
}

function requireObject(raw: unknown, message: string): Record<string, unknown> {
  const objectValue = asObject(raw);
  if (!objectValue) {
    throw new Error(message);
  }

  return objectValue;
}

function asObject(value: unknown): Record<string, unknown> | null {
  if (!value || typeof value !== 'object') return null;
  return value as Record<string, unknown>;
}

function normalizeQuestionType(_value: string): 'single_choice' {
  return 'single_choice';
}

function normalizeFromSet(
  value: number | null,
  allowed: number[],
  fallback: number,
): number {
  if (value == null) return fallback;
  if (allowed.includes(value)) return value;

  let nearest = allowed[0];
  let nearestDistance = Math.abs(allowed[0] - value);
  for (const candidate of allowed) {
    const distance = Math.abs(candidate - value);
    if (distance < nearestDistance) {
      nearest = candidate;
      nearestDistance = distance;
    }
  }
  return nearest;
}

function toNonEmptyString(value: unknown): string | null {
  if (typeof value !== 'string') return null;
  const trimmed = value.trim();
  return trimmed.length > 0 ? trimmed : null;
}

function toNumber(value: unknown): number | null {
  if (typeof value === 'number' && Number.isFinite(value)) {
    return Math.round(value);
  }
  if (typeof value === 'string') {
    const parsed = Number(value);
    if (Number.isFinite(parsed)) {
      return Math.round(parsed);
    }
  }
  return null;
}

function jsonResponse(body: unknown, status: number): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: {
      ...corsHeaders,
      'Content-Type': 'application/json',
    },
  });
}
