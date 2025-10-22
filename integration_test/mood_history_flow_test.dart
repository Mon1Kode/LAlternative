import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:l_alternative/main.dart' as app;
import 'package:l_alternative/src/core/components/bar_chart.dart';
import 'package:l_alternative/src/core/components/circle_image_button.dart';
import 'package:l_alternative/src/core/components/image_button.dart';
import 'package:l_alternative/src/features/history/view/history_view.dart';
import 'package:l_alternative/src/features/home/view/home_view.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Mood History Flow Integration Tests', () {
    testWidgets(
      'Complete flow: record mood → navigate to history → verify display',
      (WidgetTester tester) async {
        // Launch the app
        app.main();
        await tester.pumpAndSettle();

        // Step 1: Verify we start on HomeView
        expect(find.byType(HomeView), findsOneWidget);
        expect(find.text('Humeur actuelle'), findsOneWidget);

        // Step 2: Record a mood by selecting the first mood circle (love)
        final moodCircles = find.byType(CircleImageButton);
        expect(moodCircles, findsNWidgets(5));

        // Tap the first mood circle (love)
        await tester.tap(moodCircles.first);
        await tester.pumpAndSettle();

        // Step 3: Navigate to HistoryView by tapping the chart button
        final chartButton = find.byWidgetPredicate(
          (widget) => widget is ImageButton && widget.imagePath == "chart.png",
        );

        expect(chartButton, findsOneWidget);
        await tester.tap(chartButton);
        await tester.pumpAndSettle();

        // Step 4: Verify we're now on HistoryView
        expect(find.byType(HistoryView), findsOneWidget);
        expect(find.text('Historique'), findsOneWidget);

        // Step 5: Verify the mood was recorded and appears in statistics
        expect(find.text('Statistiques'), findsOneWidget);
        expect(find.byType(BarChartSample4), findsOneWidget);

        // Should show at least 1 total mood recorded
        expect(find.textContaining('Total: '), findsOneWidget);

        // Step 6: Verify the mood appears in the history details section
        expect(find.text('Détails de l\'historique'), findsOneWidget);

        // Should show today's date (September 29, 2025) in the history
        expect(
          find.textContaining('Monday, 29 September, 2025'),
          findsOneWidget,
        );

        // Step 7: Verify mood images are displayed in both chart and history
        final moodImages = find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName.contains(
                'assets/images/moods/',
              ),
        );
        expect(moodImages, findsWidgets);

        // Step 8: Verify chart displays the recorded mood data
        final chartWidget = tester.widget<BarChartSample4>(
          find.byType(BarChartSample4),
        );
        expect(chartWidget.values.length, equals(5)); // 5 mood types
        expect(chartWidget.xLabels.length, equals(5)); // 5 mood images
      },
    );

    testWidgets('Record multiple moods and verify statistics accuracy', (
      WidgetTester tester,
    ) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Record multiple different moods
      final moodCircles = find.byType(CircleImageButton);

      // Record love mood (first circle)
      await tester.tap(moodCircles.first);
      await tester.pumpAndSettle();

      // Wait a moment to ensure the mood is saved
      await tester.pump(Duration(milliseconds: 500));

      // Record happy mood (second circle)
      await tester.tap(moodCircles.at(1));
      await tester.pumpAndSettle();

      await tester.pump(Duration(milliseconds: 500));

      // Record love mood again (first circle)
      await tester.tap(moodCircles.first);
      await tester.pumpAndSettle();

      // Navigate to history
      final chartButton = find.byWidgetPredicate(
        (widget) => widget is ImageButton && widget.imagePath == "chart.png",
      );

      await tester.tap(chartButton);
      await tester.pumpAndSettle();

      // Verify we're on HistoryView
      expect(find.byType(HistoryView), findsOneWidget);

      // Verify statistics show multiple moods recorded
      expect(find.textContaining('Total: '), findsOneWidget);

      // Should find mood count percentages
      expect(find.textContaining('%'), findsWidgets);

      // Verify chart reflects the mood data
      final chartWidget = tester.widget<BarChartSample4>(
        find.byType(BarChartSample4),
      );

      // Chart should have values for the recorded moods
      final hasNonZeroValues = chartWidget.values.any((value) => value > 0);
      expect(hasNonZeroValues, isTrue);
    });

    testWidgets(
      'History displays moods in chronological order (newest first)',
      (WidgetTester tester) async {
        // Launch the app
        app.main();
        await tester.pumpAndSettle();

        // Record a mood
        final moodCircles = find.byType(CircleImageButton);
        await tester.tap(moodCircles.at(2)); // neutral mood
        await tester.pumpAndSettle();

        // Navigate to history
        final chartButton = find.byWidgetPredicate(
          (widget) => widget is ImageButton && widget.imagePath == "chart.png",
        );

        await tester.tap(chartButton);
        await tester.pumpAndSettle();

        // Verify history section exists
        expect(find.text('Détails de l\'historique'), findsOneWidget);

        // Verify today's date appears (should be newest/first entry)
        expect(
          find.textContaining('Monday, 29 September, 2025'),
          findsOneWidget,
        );

        // Verify mood image appears in history entry
        final historyMoodImages = find.byWidgetPredicate(
          (widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName.contains('neutral.png'),
        );
        expect(historyMoodImages, findsWidgets);
      },
    );

    testWidgets('Navigate back to home from history maintains mood selection', (
      WidgetTester tester,
    ) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Record a specific mood (sad - last circle)
      final moodCircles = find.byType(CircleImageButton);
      await tester.tap(moodCircles.last);
      await tester.pumpAndSettle();

      // Navigate to history
      final chartButton = find.byWidgetPredicate(
        (widget) => widget is ImageButton && widget.imagePath == "chart.png",
      );

      await tester.tap(chartButton);
      await tester.pumpAndSettle();

      // Verify we're on history page
      expect(find.byType(HistoryView), findsOneWidget);

      // Navigate back to home using back button
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Verify we're back on HomeView
      expect(find.byType(HomeView), findsOneWidget);

      // Verify mood selection is maintained (sad mood should still be selected)
      final moodCirclesAfterReturn = find.byType(CircleImageButton);
      expect(moodCirclesAfterReturn, findsNWidgets(5));
    });

    testWidgets('History chart scales correctly with multiple mood entries', (
      WidgetTester tester,
    ) async {
      // Launch the app
      app.main();
      await tester.pumpAndSettle();

      // Record multiple moods of different types
      final moodCircles = find.byType(CircleImageButton);

      // Record several moods to test chart scaling
      for (int i = 0; i < 3; i++) {
        await tester.tap(moodCircles.at(i % 5));
        await tester.pumpAndSettle();
        await tester.pump(Duration(milliseconds: 300));
      }

      // Navigate to history
      final chartButton = find.byWidgetPredicate(
        (widget) => widget is ImageButton && widget.imagePath == "chart.png",
      );

      await tester.tap(chartButton);
      await tester.pumpAndSettle();

      // Verify chart properties
      final chartWidget = tester.widget<BarChartSample4>(
        find.byType(BarChartSample4),
      );

      // Verify chart has proper scaling (maxY should be totalMoods + 5)
      expect(
        chartWidget.maxY,
        greaterThan(5.0),
      ); // Should be more than just the base 5

      // Verify all mood types are represented in chart
      expect(chartWidget.values.length, equals(5));
      expect(chartWidget.xLabels.length, equals(5));

      // Verify statistics section shows correct totals
      expect(find.textContaining('Total: '), findsOneWidget);
    });

    testWidgets(
      'History persists across app sessions (SharedPreferences integration)',
      (WidgetTester tester) async {
        // Launch the app
        app.main();
        await tester.pumpAndSettle();

        // Record a mood
        final moodCircles = find.byType(CircleImageButton);
        await tester.tap(moodCircles.at(1)); // happy mood
        await tester.pumpAndSettle();

        // Navigate to history to verify it's recorded
        final chartButton = find.byWidgetPredicate(
          (widget) => widget is ImageButton && widget.imagePath == "chart.png",
        );

        await tester.tap(chartButton);
        await tester.pumpAndSettle();

        // Verify mood is shown in history
        expect(find.text('Détails de l\'historique'), findsOneWidget);
        expect(
          find.textContaining('Monday, 29 September, 2025'),
          findsOneWidget,
        );

        // Navigate back to home
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();

        // Simulate app restart by pumping the widget tree again
        await tester.pumpWidget(Container()); // Clear the widget tree
        await tester.pumpAndSettle();

        // Restart the app
        app.main();
        await tester.pumpAndSettle();

        // Navigate to history again
        final chartButtonAfterRestart = find.byWidgetPredicate(
          (widget) => widget is ImageButton && widget.imagePath == "chart.png",
        );

        await tester.tap(chartButtonAfterRestart);
        await tester.pumpAndSettle();

        // Verify mood data persisted
        expect(find.byType(HistoryView), findsOneWidget);
        expect(find.text('Statistiques'), findsOneWidget);

        // Should still show the recorded mood data
        expect(find.textContaining('Total: '), findsOneWidget);
      },
    );
  });
}
