import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/app.dart';

void main() {
  // await Stac.initialize();
  runApp(const ProviderScope(child: MyApp()));
}
