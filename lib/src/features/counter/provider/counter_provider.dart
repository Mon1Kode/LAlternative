import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/counter_model.dart';
import '../service/counter_service.dart';

final counterProvider = StateNotifierProvider<CounterNotifier, CounterModel>(
  (ref) => CounterNotifier(ref),
);

class CounterNotifier extends StateNotifier<CounterModel> {
  final Ref ref;
  CounterNotifier(this.ref) : super(const CounterModel(0)) {
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    final service = CounterService();
    final value = await service.loadCounter();
    state = CounterModel(value);
  }

  Future<void> increment() async {
    final newValue = state.value + 1;
    state = state.copyWith(value: newValue);
    await CounterService().saveCounter(newValue);
  }
}
