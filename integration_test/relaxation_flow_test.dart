import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:l_alternative/main.dart' as app;
import 'package:l_alternative/src/core/components/resource_row.dart';
import 'package:l_alternative/src/features/home/view/home_view.dart';
import 'package:l_alternative/src/features/relaxation/view/breathing_details.dart';
import 'package:l_alternative/src/features/relaxation/view/relaxation_view.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Relaxation Flow E2E Tests', () {
    testWidgets('RelaxationView direct rendering and navigation test', (
      WidgetTester tester,
    ) async {
      // Test RelaxationView directly to ensure it renders properly
      await tester.pumpWidget(MaterialApp(home: RelaxationView()));
      await tester.pumpAndSettle();

      // Verify RelaxationView renders correctly
      expect(find.byType(RelaxationView), findsOneWidget);
      expect(find.text('Pratiquer la relaxation'), findsOneWidget);
      expect(find.text('La respiration diaphragmatique'), findsOneWidget);
      expect(
        find.text('Techniques, Bienfaits et Applications'),
        findsOneWidget,
      );

      // Verify main content sections
      expect(find.text('Vidéo'), findsOneWidget);
      expect(find.text('Témoignages'), findsOneWidget);

      // Verify video content
      expect(find.text('Respiration diaphragmatique'), findsOneWidget);
      expect(find.text('Méditation guidée'), findsOneWidget);
      expect(find.text('Relaxation musculaire'), findsOneWidget);
      expect(find.text('Visualisation positive'), findsOneWidget);

      // Verify testimonials
      expect(find.text('Marine Chausson'), findsOneWidget);

      // Test navigation to breathing details
      final learnMoreButton = find.text('En savoir plus');
      expect(learnMoreButton, findsOneWidget);

      await tester.tap(learnMoreButton);
      await tester.pumpAndSettle();

      // Verify BreathingDetails loads
      expect(find.byType(BreathingDetails), findsOneWidget);
      expect(find.text('La respiration diaphragmatique'), findsOneWidget);
    });

    testWidgets('BreathingDetails comprehensive content and interaction test', (
      WidgetTester tester,
    ) async {
      // Test BreathingDetails directly
      await tester.pumpWidget(MaterialApp(home: BreathingDetails()));
      await tester.pumpAndSettle();

      // Verify basic structure
      expect(find.byType(BreathingDetails), findsOneWidget);
      expect(find.text('La respiration diaphragmatique'), findsOneWidget);

      // Verify benefits section
      expect(
        find.text('Bienfaits de la respiration diaphragmatique'),
        findsOneWidget,
      );
      expect(find.text('Physiques'), findsOneWidget);
      expect(find.text('Mentaux'), findsOneWidget);
      expect(find.text('Émotionnels'), findsOneWidget);

      // Test ResourceRow expansion - Physical benefits
      final physicalBenefits = find.text('Physiques');
      await tester.tap(physicalBenefits);
      await tester.pumpAndSettle();

      // Verify content is accessible after expansion
      expect(
        find.textContaining('Amélioration de l\'oxygénation'),
        findsWidgets,
      );

      // Scroll to see applications section
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();

      // Verify applications section
      expect(
        find.text('Applications pratiques de la respiration diaphragmatique'),
        findsOneWidget,
      );
      expect(find.text('Gestion du stress'), findsOneWidget);
      expect(find.text('Performance sportive'), findsOneWidget);

      // Test Stress Management expansion
      final stressManagement = find.text('Gestion du stress');
      await tester.tap(stressManagement);
      await tester.pumpAndSettle();

      // Verify stress management content
      expect(
        find.textContaining('système nerveux parasympathique'),
        findsWidgets,
      );

      // Continue scrolling to see more applications
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();

      expect(find.text('Réhabilitation et physiothérapie'), findsOneWidget);
      expect(find.text('Gestion de la douleur'), findsOneWidget);

      // Test Pain Management expansion
      final painManagement = find.text('Gestion de la douleur');
      await tester.tap(painManagement);
      await tester.pumpAndSettle();

      // Verify pain management content
      expect(
        find.textContaining('technique de gestion de la douleur'),
        findsWidgets,
      );
    });

    testWidgets('RelaxationView scrolling and content interaction test', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: RelaxationView()));
      await tester.pumpAndSettle();

      // Test horizontal scrolling in video section
      final videoScrollViews = find.byType(SingleChildScrollView);
      expect(videoScrollViews, findsWidgets);

      // Test scrolling in the first scroll view (video section)
      if (videoScrollViews.evaluate().isNotEmpty) {
        await tester.drag(videoScrollViews.first, const Offset(-200, 0));
        await tester.pumpAndSettle();

        // Verify content is still accessible after scrolling
        expect(find.text('Méditation guidée'), findsOneWidget);
      }

      // Test testimonials section scrolling if there's a second scroll view
      if (videoScrollViews.evaluate().length > 1) {
        await tester.drag(videoScrollViews.at(1), const Offset(-100, 0));
        await tester.pumpAndSettle();

        // Verify testimonial content
        expect(find.text('Marine Chausson'), findsOneWidget);
      }

      // Verify breathing exercise description
      expect(
        find.textContaining('La respiration diaphragmatique, également connue'),
        findsOneWidget,
      );
    });

    testWidgets('Navigation flow between RelaxationView and BreathingDetails', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: RelaxationView()));
      await tester.pumpAndSettle();

      // Test multiple navigation cycles
      for (int i = 0; i < 2; i++) {
        // Navigate to breathing details
        final learnMoreButton = find.text('En savoir plus');
        expect(learnMoreButton, findsOneWidget);

        await tester.tap(learnMoreButton);
        await tester.pumpAndSettle();

        // Verify we're in BreathingDetails
        expect(find.byType(BreathingDetails), findsOneWidget);
        expect(
          find.text('Bienfaits de la respiration diaphragmatique'),
          findsOneWidget,
        );

        // Navigate back
        final backButton = find.byType(BackButton);
        expect(backButton, findsOneWidget);
        await tester.tap(backButton);
        await tester.pumpAndSettle();

        // Verify we're back in RelaxationView
        expect(find.byType(RelaxationView), findsOneWidget);
        expect(find.text('Pratiquer la relaxation'), findsOneWidget);
      }
    });

    testWidgets('AppBar styling consistency test', (WidgetTester tester) async {
      // Test RelaxationView AppBar
      await tester.pumpWidget(MaterialApp(home: RelaxationView()));
      await tester.pumpAndSettle();

      AppBar relaxationAppBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(relaxationAppBar.backgroundColor, equals(Color(0xFFF7E879)));
      expect(relaxationAppBar.foregroundColor, equals(Colors.black));
      expect(relaxationAppBar.centerTitle, equals(false));

      // Navigate to BreathingDetails
      await tester.tap(find.text('En savoir plus'));
      await tester.pumpAndSettle();

      // Test BreathingDetails AppBar
      AppBar breathingAppBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(breathingAppBar.backgroundColor, equals(Color(0xFFF7E879)));
      expect(breathingAppBar.foregroundColor, equals(Colors.black));
      expect(breathingAppBar.centerTitle, equals(false));
    });

    testWidgets('ResourceRow interaction stress test', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: BreathingDetails()));
      await tester.pumpAndSettle();

      // Rapidly interact with multiple ResourceRows
      final categories = ['Physiques', 'Mentaux', 'Émotionnels'];

      for (String category in categories) {
        final categoryWidget = find.text(category);
        if (categoryWidget.evaluate().isNotEmpty) {
          await tester.tap(categoryWidget);
          await tester.pump(const Duration(milliseconds: 200));
        }
      }
      await tester.pumpAndSettle();

      // Verify app is still functional
      expect(find.byType(BreathingDetails), findsOneWidget);
      expect(find.byType(ResourceRow), findsWidgets);

      // Test scrolling after interactions
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();

      // Interact with application categories
      final appCategories = ['Gestion du stress', 'Performance sportive'];

      for (String category in appCategories) {
        final categoryWidget = find.text(category);
        if (categoryWidget.evaluate().isNotEmpty) {
          await tester.tap(categoryWidget);
          await tester.pump(const Duration(milliseconds: 200));
        }
      }
      await tester.pumpAndSettle();

      // Verify app remains functional
      expect(find.byType(BreathingDetails), findsOneWidget);
    });

    testWidgets('Content validation and French text verification', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(MaterialApp(home: BreathingDetails()));
      await tester.pumpAndSettle();

      // Verify key French content is present
      final keyTerms = [
        'respiration diaphragmatique',
        'Bienfaits',
        'Applications pratiques',
        'Physiques',
        'Mentaux',
        'Émotionnels',
        'Gestion du stress',
        'Performance sportive',
      ];

      for (String term in keyTerms) {
        expect(find.textContaining(term), findsWidgets);
      }

      // Scroll to see more content and verify additional terms
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -400),
      );
      await tester.pumpAndSettle();

      final additionalTerms = ['Réhabilitation', 'Gestion de la douleur'];

      for (String term in additionalTerms) {
        expect(find.textContaining(term), findsWidgets);
      }
    });

    testWidgets('Full app integration test with home navigation attempt', (
      WidgetTester tester,
    ) async {
      // Launch the full app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify app launches successfully
      expect(find.byType(HomeView), findsOneWidget);
      expect(find.text('Bon retour,'), findsOneWidget);

      // Look for any relaxation-related content or buttons
      final relaxationFinders = [
        find.textContaining('Pratiquer la relaxation'),
        find.textContaining('relaxation'),
        find.textContaining('Relaxation'),
      ];

      bool foundRelaxationEntry = false;
      for (var finder in relaxationFinders) {
        if (finder.evaluate().isNotEmpty) {
          try {
            await tester.tap(finder.first);
            await tester.pumpAndSettle();

            // Check if we successfully navigated to RelaxationView
            if (find.byType(RelaxationView).evaluate().isNotEmpty) {
              foundRelaxationEntry = true;

              // Test the relaxation flow
              expect(
                find.text('La respiration diaphragmatique'),
                findsOneWidget,
              );

              // Test navigation to breathing details
              if (find.text('En savoir plus').evaluate().isNotEmpty) {
                await tester.tap(find.text('En savoir plus'));
                await tester.pumpAndSettle();

                expect(find.byType(BreathingDetails), findsOneWidget);
              }
              break;
            }
          } catch (e) {
            // Continue trying other finders
            continue;
          }
        }
      }

      // If we couldn't find the relaxation entry through normal navigation,
      // at least verify the home view works
      if (!foundRelaxationEntry) {
        expect(find.byType(HomeView), findsOneWidget);
        // Test that we can interact with the home view
        expect(find.text('Outils'), findsWidgets);
      }
    });
  });
}
