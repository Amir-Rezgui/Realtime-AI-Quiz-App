import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/signup_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/quiz_editor/quiz_editor_screen.dart';
import '../../presentation/screens/quiz_editor/question_editor_screen.dart';
import '../../presentation/screens/host/lobby_screen.dart';
import '../../presentation/screens/host/host_game_screen.dart';
import '../../presentation/screens/player/join_screen.dart';
import '../../presentation/screens/player/nickname_screen.dart';
import '../../presentation/screens/player/player_lobby_screen.dart';
import '../../presentation/screens/player/player_game_screen.dart';
import '../../presentation/screens/leaderboard/leaderboard_screen.dart';
import '../../presentation/providers/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isAuthRoute =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';
      final isPlayerRoute =
          state.matchedLocation.startsWith('/join') ||
          state.matchedLocation.startsWith('/play');
      final isSplash = state.matchedLocation == '/';

      // Allow splash screen
      if (isSplash) return null;

      // Allow player routes without auth
      if (isPlayerRoute) return null;

      // Redirect to login if not logged in and not on auth route
      if (!isLoggedIn && !isAuthRoute) {
        return '/login';
      }

      // Redirect to home if logged in and on auth route
      if (isLoggedIn && isAuthRoute) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/quiz/new',
        builder: (context, state) => const QuizEditorScreen(),
      ),
      GoRoute(
        path: '/quiz/:id',
        builder: (context, state) =>
            QuizEditorScreen(quizId: state.pathParameters['id']),
      ),
      GoRoute(
        path: '/quiz/:id/question',
        builder: (context, state) =>
            QuestionEditorScreen(quizId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/quiz/:id/question/:questionId',
        builder: (context, state) => QuestionEditorScreen(
          quizId: state.pathParameters['id']!,
          questionId: state.pathParameters['questionId'],
        ),
      ),
      GoRoute(
        path: '/host/:sessionId/lobby',
        builder: (context, state) =>
            LobbyScreen(sessionId: state.pathParameters['sessionId']!),
      ),
      GoRoute(
        path: '/host/:sessionId/game',
        builder: (context, state) =>
            HostGameScreen(sessionId: state.pathParameters['sessionId']!),
      ),
      // Player routes (no auth required)
      GoRoute(path: '/join', builder: (context, state) => const JoinScreen()),
      GoRoute(
        path: '/join/:code/nickname',
        builder: (context, state) =>
            NicknameScreen(joinCode: state.pathParameters['code']!),
      ),
      GoRoute(
        path: '/play/:sessionId/lobby',
        builder: (context, state) => PlayerLobbyScreen(
          sessionId: state.pathParameters['sessionId']!,
          playerId: state.uri.queryParameters['playerId']!,
        ),
      ),
      GoRoute(
        path: '/play/:sessionId/game',
        builder: (context, state) => PlayerGameScreen(
          sessionId: state.pathParameters['sessionId']!,
          playerId: state.uri.queryParameters['playerId']!,
        ),
      ),
      GoRoute(
        path: '/leaderboard/:sessionId',
        builder: (context, state) => LeaderboardScreen(
          sessionId: state.pathParameters['sessionId']!,
          isHostView: state.uri.queryParameters['view'] == 'host',
        ),
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
  );
});
