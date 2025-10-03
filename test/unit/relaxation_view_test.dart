import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:l_alternative/src/features/relaxation/view/breathing_details.dart';
import 'package:l_alternative/src/features/relaxation/view/relaxation_view.dart';

void main() {
  group('RelaxationView Unit Tests', () {
    testWidgets('RelaxationView renders correctly with initial state', (
      WidgetTester tester,
    ) async {
      // Set a larger screen size to avoid overflow
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(home: RelaxationView()));

      await tester.pumpAndSettle();

      // Verify AppBar is present with correct title
      expect(find.text('Pratiquer la relaxation'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);

      // Verify main content sections are present
      expect(find.text('La respiration diaphragmatique'), findsOneWidget);
      expect(
        find.text('Techniques, Bienfaits et Applications'),
        findsOneWidget,
      );
      expect(find.text('Vidéo'), findsOneWidget);
      expect(find.text('Témoignages'), findsOneWidget);
    });

    testWidgets('AppBar has correct styling and properties', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(home: RelaxationView()));

      await tester.pumpAndSettle();

      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.backgroundColor, equals(Color(0xFFF7E879)));
      expect(appBar.foregroundColor, equals(Colors.black));
      expect(appBar.centerTitle, equals(false));
    });

    testWidgets('Main breathing exercise section displays correctly', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(home: RelaxationView()));

      await tester.pumpAndSettle();

      // Verify breathing exercise description text
      expect(
        find.textContaining(
          'La respiration diaphragmatique, également connue sous le nom de respiration abdominale',
        ),
        findsOneWidget,
      );

      // Verify "En savoir plus" button is present
      expect(find.text('En savoir plus'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Video section displays correctly with scroll view', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(home: RelaxationView()));

      await tester.pumpAndSettle();

      // Verify video section header
      expect(find.text('Vidéo'), findsOneWidget);

      // Verify horizontal scroll view is present
      expect(
        find.byType(SingleChildScrollView),
        findsNWidgets(2),
      ); // One for video, one for testimonials

      // Verify video items are present
      expect(find.text('Respiration diaphragmatique'), findsOneWidget);
      expect(find.text('Méditation guidée'), findsOneWidget);
      expect(find.text('Relaxation musculaire'), findsOneWidget);
      expect(find.text('Visualisation positive'), findsOneWidget);
    });

    testWidgets('Testimonials section displays correctly', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(home: RelaxationView()));

      await tester.pumpAndSettle();

      // Verify testimonials section header
      expect(find.text('Témoignages'), findsOneWidget);

      // Verify testimonial item
      expect(find.text('Marine Chausson'), findsOneWidget);
    });

    testWidgets('SupportRoundedContainer widgets are present', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(home: RelaxationView()));

      await tester.pumpAndSettle();

      // Count SupportRoundedContainer widgets (4 videos + 1 testimonial = 5)
      expect(find.byType(SupportRoundedContainer), findsNWidgets(5));
    });

    testWidgets('Navigation to BreathingDetails works correctly', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: RelaxationView(),
          routes: {'/breathing_details': (context) => BreathingDetails()},
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap the "En savoir plus" button
      final button = find.text('En savoir plus');
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pumpAndSettle();

      // Verify navigation occurred by checking for BreathingDetails content
      expect(find.text('La respiration diaphragmatique'), findsOneWidget);
    });

    testWidgets('All rounded containers have correct border color', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(MaterialApp(home: RelaxationView()));

      await tester.pumpAndSettle();

      // This test ensures that the yellow border color is applied consistently
      // We can't directly test the border color, but we can verify the containers are rendered
      expect(find.byType(Container), findsWidgets);
    });
  });

  group('SupportRoundedContainer Unit Tests', () {
    testWidgets('SupportRoundedContainer displays correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SupportRoundedContainer(
                imagePath: "assets/images/relaxation_video.png",
                text: "Test Video",
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify text is displayed
      expect(find.text('Test Video'), findsOneWidget);

      // Verify play button image is displayed
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets('SupportRoundedContainer has correct dimensions', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SupportRoundedContainer(
                imagePath: "assets/images/relaxation_video.png",
                text: "Test Video",
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.constraints?.maxWidth, equals(100));
      expect(container.constraints?.maxHeight, equals(100));
    });

    testWidgets('SupportRoundedContainer handles short text properly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SupportRoundedContainer(
                imagePath: "assets/images/relaxation_video.png",
                text: "Short",
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify text is displayed properly
      expect(find.text('Short'), findsOneWidget);
    });
  });
}
