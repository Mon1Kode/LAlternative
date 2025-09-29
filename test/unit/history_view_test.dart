import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l_alternative/src/core/components/bar_chart.dart';
import 'package:l_alternative/src/core/components/rounded_container.dart';
import 'package:l_alternative/src/features/history/view/history_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('HistoryView Unit Tests', () {
    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
    });

    group('Data Rendering Tests', () {
      testWidgets('renders empty state correctly when no mood history exists', (
        WidgetTester tester,
      ) async {
        // Setup: Empty mood history
        SharedPreferences.setMockInitialValues({'mood_history': <String>[]});

        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: HistoryView())),
        );
        await tester.pumpAndSettle();

        // Verify basic UI elements are present
        expect(find.text('Historique'), findsOneWidget);
        expect(find.text('Statistiques'), findsOneWidget);
        expect(find.text('Détails de l\'historique'), findsOneWidget);
        expect(find.text('Total: 0'), findsOneWidget);

        // Verify chart is present but empty
        expect(find.byType(BarChartSample4), findsOneWidget);

        // Verify all mood counts show 0 (0%)
        expect(find.textContaining('0 (0%)'), findsNWidgets(5));
      });

      testWidgets('renders mood statistics chart with correct data', (
        WidgetTester tester,
      ) async {
        // Setup: Mock mood history with various moods
        SharedPreferences.setMockInitialValues({
          'mood_history': [
            '2025-09-25:love.png',
            '2025-09-26:happy.png',
            '2025-09-27:love.png',
            '2025-09-28:neutral.png',
            '2025-09-29:sad.png',
          ],
        });

        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: HistoryView())),
        );
        await tester.pumpAndSettle();

        // Verify total count is correct
        expect(find.text('Total: 5'), findsOneWidget);

        // Verify chart component is rendered
        final chartWidget = find.byType(BarChartSample4);
        expect(chartWidget, findsOneWidget);

        // Verify chart has correct properties
        final barChart = tester.widget<BarChartSample4>(chartWidget);
        expect(barChart.values.length, equals(5)); // 5 mood types
        expect(barChart.maxY, equals(10.0)); // totalMoods + 5 = 5 + 5
        expect(barChart.xLabels.length, equals(5)); // 5 mood images
      });

      testWidgets('displays correct mood count percentages', (
        WidgetTester tester,
      ) async {
        // Setup: 10 mood entries with known distribution
        SharedPreferences.setMockInitialValues({
          'mood_history': [
            '2025-09-20:love.png',
            '2025-09-21:love.png',
            '2025-09-22:love.png',
            '2025-09-23:happy.png',
            '2025-09-24:happy.png',
            '2025-09-25:neutral.png',
            '2025-09-26:neutral.png',
            '2025-09-27:frowning.png',
            '2025-09-28:sad.png',
            '2025-09-29:sad.png',
          ],
        });

        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: HistoryView())),
        );
        await tester.pumpAndSettle();

        // Verify total count
        expect(find.text('Total: 10'), findsOneWidget);

        // Verify mood counts and percentages
        expect(
          find.textContaining('3 (30%)'),
          findsOneWidget,
        ); // love: 3/10 = 30%
        expect(
          find.textContaining('2 (20%)'),
          findsNWidgets(3),
        ); // happy, neutral, sad: 2/10 = 20% each
        expect(
          find.textContaining('1 (10%)'),
          findsOneWidget,
        ); // frowning: 1/10 = 10%
      });

      testWidgets(
        'renders mood history list in chronological order (newest first)',
        (WidgetTester tester) async {
          // Setup: Mood history with specific dates
          SharedPreferences.setMockInitialValues({
            'mood_history': [
              '2025-09-25:love.png',
              '2025-09-27:happy.png',
              '2025-09-26:neutral.png',
              '2025-09-28:frowning.png',
              '2025-09-29:sad.png',
            ],
          });

          await tester.pumpWidget(
            ProviderScope(child: MaterialApp(home: HistoryView())),
          );
          await tester.pumpAndSettle();

          // Verify history section is present
          expect(find.text('Détails de l\'historique'), findsOneWidget);

          // Verify dates are formatted correctly and in descending order
          expect(
            find.textContaining('Monday, 29 September, 2025'),
            findsOneWidget,
          );
          expect(
            find.textContaining('Sunday, 28 September, 2025'),
            findsOneWidget,
          );
          expect(
            find.textContaining('Saturday, 27 September, 2025'),
            findsOneWidget,
          );
          expect(
            find.textContaining('Friday, 26 September, 2025'),
            findsOneWidget,
          );
          expect(
            find.textContaining('Thursday, 25 September, 2025'),
            findsOneWidget,
          );

          // Find all date text widgets to verify order - now should be 5
          final dateTexts = find.byWidgetPredicate(
            (widget) =>
                widget is Text &&
                widget.data != null &&
                widget.data!.contains('September, 2025'),
          );
          expect(dateTexts, findsNWidgets(5));
        },
      );

      testWidgets('displays correct mood images in history list', (
        WidgetTester tester,
      ) async {
        // Setup: Mood history with different moods
        SharedPreferences.setMockInitialValues({
          'mood_history': [
            '2025-09-25:love.png',
            '2025-09-26:happy.png',
            '2025-09-27:neutral.png',
            '2025-09-28:frowning.png',
            '2025-09-29:sad.png',
          ],
        });

        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: HistoryView())),
        );
        await tester.pumpAndSettle();

        // Verify mood images are displayed in both sections
        // In statistics section (as chart labels and in the count list)
        final moodImages = find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName.contains(
                'assets/images/moods/',
              ),
        );

        // Should find mood images in:
        // 1. Chart x-labels (5 images)
        // 2. Statistics counts (5 images)
        // 3. History list (5 images)
        expect(moodImages, findsWidgets);
      });

      testWidgets('handles malformed mood history entries gracefully', (
        WidgetTester tester,
      ) async {
        // Setup: Mix of valid and invalid mood history entries
        SharedPreferences.setMockInitialValues({
          'mood_history': [
            '2025-09-25:love.png', // Valid
            'invalid-entry', // Invalid - missing colon
            '2025-09-26', // Invalid - missing mood
            ':happy.png', // Invalid - missing date
            '2025-09-27:neutral.png', // Valid
            '', // Invalid - empty string
          ],
        });

        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: HistoryView())),
        );
        await tester.pumpAndSettle();

        // Total includes all entries but only valid ones are parsed into history
        expect(
          find.text('Total: 6'),
          findsOneWidget,
        ); // Total includes all entries

        // But history list should only show valid parsed entries
        expect(
          find.textContaining('Thursday, 25 September, 2025'),
          findsOneWidget,
        );
        expect(
          find.textContaining('Saturday, 27 September, 2025'),
          findsOneWidget,
        );

        // Should not crash and should render the UI
        expect(find.text('Statistiques'), findsOneWidget);
        expect(find.text('Détails de l\'historique'), findsOneWidget);
      });

      testWidgets('renders dividers between history entries correctly', (
        WidgetTester tester,
      ) async {
        // Setup: Multiple mood entries
        SharedPreferences.setMockInitialValues({
          'mood_history': [
            '2025-09-27:love.png',
            '2025-09-28:happy.png',
            '2025-09-29:neutral.png',
          ],
        });

        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: HistoryView())),
        );
        await tester.pumpAndSettle();

        // Should have dividers between entries (but not after the last entry)
        // With 3 entries, we should have 2 dividers
        expect(find.byType(Divider), findsNWidgets(2));
      });

      testWidgets('calculates mood statistics correctly for edge cases', (
        WidgetTester tester,
      ) async {
        // Setup: Only one type of mood
        SharedPreferences.setMockInitialValues({
          'mood_history': [
            '2025-09-27:love.png',
            '2025-09-28:love.png',
            '2025-09-29:love.png',
          ],
        });

        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: HistoryView())),
        );
        await tester.pumpAndSettle();

        // Verify love is 100% and others are 0%
        expect(find.textContaining('3 (100%)'), findsOneWidget); // love
        expect(find.textContaining('0 (0%)'), findsNWidgets(4)); // other moods
        expect(find.text('Total: 3'), findsOneWidget);
      });

      testWidgets('displays all required UI components', (
        WidgetTester tester,
      ) async {
        SharedPreferences.setMockInitialValues({
          'mood_history': ['2025-09-29:happy.png'],
        });

        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: HistoryView())),
        );
        await tester.pumpAndSettle();

        // Verify main structural components
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(
          find.byType(RoundedContainer),
          findsWidgets, // Multiple containers including divider
        );
        expect(find.byType(BarChartSample4), findsOneWidget);
        expect(find.byType(Column), findsWidgets);

        // Verify text styles and formatting
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Text &&
                widget.style?.fontSize == 28 &&
                widget.style?.fontWeight == FontWeight.bold,
          ),
          findsOneWidget,
        ); // App bar title

        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is Text &&
                widget.style?.fontSize == 20 &&
                widget.style?.fontWeight == FontWeight.bold,
          ),
          findsNWidgets(2),
        ); // Section headers
      });
    });

    group('Chart Data Integration Tests', () {
      testWidgets('chart receives correct values array from mood counts', (
        WidgetTester tester,
      ) async {
        SharedPreferences.setMockInitialValues({
          'mood_history': [
            '2025-09-25:love.png', // love: 1
            '2025-09-26:happy.png', // happy: 1
            '2025-09-27:happy.png', // happy: 2
            '2025-09-28:neutral.png', // neutral: 1
            // frowning: 0, sad: 0
          ],
        });

        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: HistoryView())),
        );
        await tester.pumpAndSettle();

        final chartWidget = tester.widget<BarChartSample4>(
          find.byType(BarChartSample4),
        );

        // Verify chart values match mood counts [love, happy, neutral, frowning, sad]
        expect(chartWidget.values, equals([1.0, 2.0, 1.0, 0.0, 0.0]));
        expect(chartWidget.maxY, equals(9.0)); // totalMoods(4) + 5
        expect(chartWidget.xLabels.length, equals(5));
      });

      testWidgets('chart maxY scales appropriately with data', (
        WidgetTester tester,
      ) async {
        // Test with larger dataset
        final largeMoodHistory = List.generate(
          50,
          (index) => '2025-09-${(index % 28) + 1}:love.png',
        );

        SharedPreferences.setMockInitialValues({
          'mood_history': largeMoodHistory,
        });

        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: HistoryView())),
        );
        await tester.pumpAndSettle();

        final chartWidget = tester.widget<BarChartSample4>(
          find.byType(BarChartSample4),
        );

        // maxY should be totalMoods + 5 = 50 + 5 = 55
        expect(chartWidget.maxY, equals(55.0));
      });
    });

    group('Error Handling Tests', () {
      testWidgets('handles null SharedPreferences gracefully', (
        WidgetTester tester,
      ) async {
        // Setup: No mood_history key in SharedPreferences
        SharedPreferences.setMockInitialValues({});

        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: HistoryView())),
        );
        await tester.pumpAndSettle();

        // Should default to empty state without crashing
        expect(find.text('Total: 0'), findsOneWidget);
        expect(find.text('Statistiques'), findsOneWidget);
        expect(find.text('Détails de l\'historique'), findsOneWidget);
      });

      testWidgets('handles date parsing errors gracefully', (
        WidgetTester tester,
      ) async {
        SharedPreferences.setMockInitialValues({
          'mood_history': [
            'invalid-date:love.png',
            '2025-13-45:happy.png', // Invalid date - will cause parse exception
            '2025-09-29:neutral.png', // Valid
          ],
        });

        await tester.pumpWidget(
          ProviderScope(child: MaterialApp(home: HistoryView())),
        );
        await tester.pumpAndSettle();

        // Should not crash, total should include all entries
        expect(find.text('Total: 3'), findsOneWidget);
        expect(find.byType(HistoryView), findsOneWidget);
      });
    });
  });
}
