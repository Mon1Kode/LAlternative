import 'package:shared_preferences/shared_preferences.dart';

class CounterService {
  static const _counterKey = 'counter_value';

  String displayValue(int value) {
    return value.toString();
  }

  Future<void> saveCounter(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_counterKey, value);
  }

  Future<int> loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_counterKey) ?? 0;
  }
}
