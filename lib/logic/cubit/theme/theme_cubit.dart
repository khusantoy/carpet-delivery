import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferences preferences;
  static const themeKey = 'theme_key';

  ThemeCubit(this.preferences)
      : super(ThemeState(isDark: preferences.getBool(themeKey) ?? false));

  void toggleTheme() {
    final isDark = !state.isDark;
    preferences.setBool(themeKey, isDark);
    emit(ThemeState(isDark: isDark));
  }

  bool get isDark => state.isDark;
}
