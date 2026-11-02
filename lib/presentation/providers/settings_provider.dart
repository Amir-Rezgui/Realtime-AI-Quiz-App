import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier()..load();
});

final aiGenerationSettingsProvider =
    StateNotifierProvider<AiGenerationSettingsNotifier, AiGenerationSettings>((
  ref,
) {
  return AiGenerationSettingsNotifier()..load();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light);

  static const _themeModeKey = 'theme_mode';

  Future<void> load() async {
    // Keep a single accessible theme across the app.
    state = ThemeMode.light;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, 'light');
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, 'light');
  }
}

class AiGenerationSettings {
  final String apiUrl;
  final String apiKey;
  final String modelName;

  const AiGenerationSettings({
    required this.apiUrl,
    required this.apiKey,
    required this.modelName,
  });

  AiGenerationSettings copyWith({
    String? apiUrl,
    String? apiKey,
    String? modelName,
  }) {
    return AiGenerationSettings(
      apiUrl: apiUrl ?? this.apiUrl,
      apiKey: apiKey ?? this.apiKey,
      modelName: modelName ?? this.modelName,
    );
  }
}

class AiGenerationSettingsNotifier extends StateNotifier<AiGenerationSettings> {
  AiGenerationSettingsNotifier()
      : super(
          const AiGenerationSettings(
            apiUrl: 'https://api.ollama.com/api/generate',
            apiKey: '',
            modelName: 'gemma3:4b-cloud',
          ),
        );

  static const _apiUrlKey = 'ai_api_url';
  static const _apiKeyKey = 'ai_api_key';
  static const _modelKey = 'ai_model_name';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    state = state.copyWith(
      apiUrl: prefs.getString(_apiUrlKey) ?? state.apiUrl,
      apiKey: prefs.getString(_apiKeyKey) ?? state.apiKey,
      modelName: prefs.getString(_modelKey) ?? state.modelName,
    );
  }

  Future<void> update({
    required String apiUrl,
    required String apiKey,
    required String modelName,
  }) async {
    state = state.copyWith(
      apiUrl: apiUrl.trim(),
      apiKey: apiKey.trim(),
      modelName: modelName.trim(),
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_apiUrlKey, state.apiUrl);
    await prefs.setString(_apiKeyKey, state.apiKey);
    await prefs.setString(_modelKey, state.modelName);
  }
}
