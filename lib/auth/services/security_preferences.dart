import 'package:shared_preferences/shared_preferences.dart';

class SecurityPreferences {
  static const String _setPasswordPromptShownKey =
      'set_password_prompt_shown';

  Future<bool> hasSeenSetPasswordPrompt() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_setPasswordPromptShownKey) ?? false;
  }

  Future<void> markSetPasswordPromptShown() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      _setPasswordPromptShownKey,
      true,
    );
  }

  Future<void> resetSetPasswordPrompt() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_setPasswordPromptShownKey);
  }
}