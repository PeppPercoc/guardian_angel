import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static final SharedPrefsService _instance = SharedPrefsService._internal();
  SharedPrefsService._internal();
  factory SharedPrefsService() => _instance;

  SharedPreferences? _prefs;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
  }

  Future<bool> getBool(String key, {bool defaultValue = false}) async {
    await init();
    return _prefs?.getBool(key) ?? defaultValue;
  }

  Future<void> setBool(String key, bool value) async {
    await init();
    await _prefs?.setBool(key, value);
  }

  Future<String?> getString(String key) async {
    await init();
    return _prefs?.getString(key);
  }

  Future<void> setString(String key, String value) async {
    await init();
    await _prefs?.setString(key, value);
  }

  Future<void> clear() async {
    await init();
    await _prefs?.clear();
  }
}