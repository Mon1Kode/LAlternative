// Example model for counter feature
class CounterModel {
  final int value;
  const CounterModel(this.value);

  CounterModel copyWith({int? value}) => CounterModel(value ?? this.value);
}
