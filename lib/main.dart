import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  // const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  const supabaseUrl = 'https://pirmcxohwqahudtaepir.supabase.co';
  const anonKey = 'sb_publishable_qzD49ui01boTtpAvcCk4GA_xp99-23y';

  if (supabaseUrl.isEmpty || anonKey.isEmpty) {
    throw Exception(
      'Missing environment variables. '
      'Please provide SUPABASE_URL and SUPABASE_ANON_KEY via --dart-define.',
    );
  }

  await Supabase.initialize(url: supabaseUrl, anonKey: anonKey);

  runApp(const ProviderScope(child: QuizApp()));
}
