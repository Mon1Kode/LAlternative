import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/provider/app_providers.dart';
import '../provider/counter_provider.dart';
import '../service/counter_service.dart';

class CounterView extends ConsumerWidget {
  const CounterView({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counterModel = ref.watch(counterProvider);
    final counterService = CounterService();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () async {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              final newTheme = isDark ? ThemeMode.light : ThemeMode.dark;
              await ref.read(themeModeProvider.notifier).setTheme(newTheme);
            },
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.sunny
                  : Icons.nightlight,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              counterService.displayValue(counterModel.value),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await ref.read(counterProvider.notifier).increment();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
