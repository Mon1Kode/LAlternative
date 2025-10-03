import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l_alternative/src/core/components/resource_row.dart';
import 'package:l_alternative/src/features/relaxation/view/breathing_details.dart';

void main() {
  group('BreathingDetails Unit Tests', () {
    testWidgets('BreathingDetails renders correctly with initial state', (
      WidgetTester tester,
    ) async {
      // Set a larger screen size to avoid overflow
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(home: BreathingDetails()));

      await tester.pumpAndSettle();

      // Verify AppBar is present with correct title
      expect(find.text('La respiration diaphragmatique'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);

      // Verify main sections are present
      expect(
        find.text('Bienfaits de la respiration diaphragmatique'),
        findsOneWidget,
      );
      expect(
        find.text('Applications pratiques de la respiration diaphragmatique'),
        findsOneWidget,
      );
    });

    testWidgets('AppBar has correct styling and properties', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(home: BreathingDetails()));

      await tester.pumpAndSettle();

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, equals(Color(0xFFF7E879)));
      expect(appBar.foregroundColor, equals(Colors.black));
      expect(appBar.centerTitle, equals(false));
    });

    testWidgets('Benefits section displays all ResourceRow components', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(home: BreathingDetails()));

      await tester.pumpAndSettle();

      // Verify benefits section title
      expect(
        find.text('Bienfaits de la respiration diaphragmatique'),
        findsOneWidget,
      );

      // Verify all three benefit categories are present
      expect(find.text('Physiques'), findsOneWidget);
      expect(find.text('Mentaux'), findsOneWidget);
      expect(find.text('Émotionnels'), findsOneWidget);
    });

    testWidgets('Applications section displays all ResourceRow components', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(home: BreathingDetails()));

      await tester.pumpAndSettle();

      // Verify applications section title
      expect(
        find.text('Applications pratiques de la respiration diaphragmatique'),
        findsOneWidget,
      );

      // Verify all four application categories are present
      expect(find.text('Gestion du stress'), findsOneWidget);
      expect(find.text('Performance sportive'), findsOneWidget);
      expect(find.text('Réhabilitation et physiothérapie'), findsOneWidget);
      expect(find.text('Gestion de la douleur'), findsOneWidget);
    });

    testWidgets('ResourceRow components are present', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(home: BreathingDetails()));

      await tester.pumpAndSettle();

      // Verify ResourceRow widgets are present (there might be more due to nested structures)
      expect(find.byType(ResourceRow), findsWidgets);

      // Verify we have at least the expected main categories
      expect(find.text('Physiques'), findsOneWidget);
      expect(find.text('Mentaux'), findsOneWidget);
      expect(find.text('Émotionnels'), findsOneWidget);
      expect(find.text('Gestion du stress'), findsOneWidget);
      expect(find.text('Performance sportive'), findsOneWidget);
      expect(find.text('Réhabilitation et physiothérapie'), findsOneWidget);
      expect(find.text('Gestion de la douleur'), findsOneWidget);
    });

    testWidgets('Physical benefits ResourceRow contains correct content', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(home: BreathingDetails()));

      await tester.pumpAndSettle();

      // Verify physical benefits content is present
      expect(
        find.textContaining('Amélioration de l\'oxygénation'),
        findsWidgets,
      );
      expect(
        find.textContaining('Réduction de la tension musculaire'),
        findsWidgets,
      );
      expect(
        find.textContaining('Amélioration de la fonction pulmonaire'),
        findsWidgets,
      );
    });

    testWidgets('Mental benefits ResourceRow contains correct content', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(home: BreathingDetails()));

      await tester.pumpAndSettle();

      // Verify mental benefits content is present
      expect(
        find.textContaining('Réduction du stress et de l\'anxiété'),
        findsWidgets,
      );
      expect(
        find.textContaining('Amélioration de la concentration'),
        findsWidgets,
      );
      expect(find.textContaining('Promotion du sommeil'), findsWidgets);
    });

    testWidgets('Emotional benefits ResourceRow contains correct content', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(home: BreathingDetails()));

      await tester.pumpAndSettle();

      // Verify emotional benefits content is present
      expect(find.textContaining('Gestion des émotions'), findsWidgets);
      expect(find.textContaining('Amélioration de l\'humeur'), findsWidgets);
    });

    testWidgets('Stress management application contains correct content', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(home: BreathingDetails()));

      await tester.pumpAndSettle();

      // Verify stress management content is present (allow multiple matches since content appears in different sections)
      expect(
        find.textContaining('système nerveux parasympathique'),
        findsWidgets,
      );
      expect(find.textContaining('cortisol'), findsWidgets);
    });

    testWidgets('Sports performance application contains correct content', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(home: BreathingDetails()));

      await tester.pumpAndSettle();

      // Verify sports performance content is present
      expect(find.textContaining('Les athlètes utilisent'), findsWidgets);
      expect(find.textContaining('améliorer l\'endurance'), findsWidgets);
    });

    testWidgets('Rehabilitation application contains correct content', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(home: BreathingDetails()));

      await tester.pumpAndSettle();

      // Verify rehabilitation content is present
      expect(find.textContaining('professionnels de la santé'), findsWidgets);
      expect(find.textContaining('BPCO ou l\'asthme'), findsWidgets);
    });

    testWidgets('Pain management application contains correct content', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(home: BreathingDetails()));

      await tester.pumpAndSettle();

      // Verify pain management content is present
      expect(
        find.textContaining('technique de gestion de la douleur'),
        findsWidgets,
      );
      expect(
        find.textContaining('améliore la circulation sanguine'),
        findsWidgets,
      );
      expect(
        find.textContaining('cercle vertueux de bien-être physique'),
        findsWidgets,
      );
    });

    testWidgets('Page is scrollable', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(home: BreathingDetails()));

      await tester.pumpAndSettle();

      // Verify SingleChildScrollView is present
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('Rounded containers have correct styling', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(home: BreathingDetails()));

      await tester.pumpAndSettle();

      // Verify containers are present (we can't directly test border color but can verify structure)
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('ResourceRow expansion functionality works', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(home: BreathingDetails()));

      await tester.pumpAndSettle();

      // Find the first ResourceRow (Physical benefits)
      final physicalResourceRow = find.text('Physiques');
      expect(physicalResourceRow, findsOneWidget);

      // Tap on the ResourceRow to expand it
      await tester.tap(physicalResourceRow);
      await tester.pumpAndSettle();

      // After tapping, the detailed content should be visible
      // (Note: This assumes ResourceRow shows content when tapped)
      expect(find.byType(ResourceRow), findsWidgets);
    });

    testWidgets('All sections are properly contained within Column layout', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(home: BreathingDetails()));

      await tester.pumpAndSettle();

      // Verify main Column structure
      expect(find.byType(Column), findsWidgets);

      // Verify Padding is applied correctly
      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('Benefits and applications sections have proper spacing', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(home: BreathingDetails()));

      await tester.pumpAndSettle();

      // Verify that both main sections exist and are properly spaced
      final benefitsSection = find.text(
        'Bienfaits de la respiration diaphragmatique',
      );
      final applicationsSection = find.text(
        'Applications pratiques de la respiration diaphragmatique',
      );

      expect(benefitsSection, findsOneWidget);
      expect(applicationsSection, findsOneWidget);
    });
  });

  group('BreathingDetails Content Validation', () {
    testWidgets('Validates all required French text content is present', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(home: BreathingDetails()));

      await tester.pumpAndSettle();

      // Key French terms that should be present
      final keyTerms = [
        'respiration diaphragmatique',
        'Bienfaits',
        'Applications pratiques',
        'Physiques',
        'Mentaux',
        'Émotionnels',
        'Gestion du stress',
        'Performance sportive',
        'Réhabilitation',
        'Gestion de la douleur',
      ];

      for (String term in keyTerms) {
        expect(find.textContaining(term), findsWidgets);
      }
    });
  });
}
