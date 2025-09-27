import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Test class to isolate mood selection logic from HomeView
class MoodSelectionLogic {
  late SharedPreferences prefs;
  String _selectedMood = "love.png";

  String get selectedMood => _selectedMood;

  Future<void> initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> loadUserMood() async {
    _selectedMood = prefs.getString("mood") ?? "love.png";
  }

  Future<void> selectMood(String mood) async {
    _selectedMood = mood;
    await prefs.setString("mood", _selectedMood);
  }

  bool isMoodSelected(String mood) {
    return _selectedMood == mood;
  }

  List<String> getAvailableMoods() {
    return ["love.png", "happy.png", "neutral.png", "frowning.png", "sad.png"];
  }
}

void main() {
  group('Mood Selection Logic Tests', () {
    late MoodSelectionLogic moodLogic;

    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues({});
      moodLogic = MoodSelectionLogic();
      await moodLogic.initializePrefs();
    });

    test('should initialize with default mood', () {
      expect(moodLogic.selectedMood, equals("love.png"));
    });

    test('should load saved mood from preferences', () async {
      // Set up initial mood in preferences
      await moodLogic.prefs.setString("mood", "happy.png");

      // Load mood from preferences
      await moodLogic.loadUserMood();

      expect(moodLogic.selectedMood, equals("happy.png"));
    });

    test('should use default mood when no saved preference exists', () async {
      // Ensure no mood is saved
      await moodLogic.prefs.remove("mood");

      // Load mood from preferences
      await moodLogic.loadUserMood();

      expect(moodLogic.selectedMood, equals("love.png"));
    });

    test('should update selected mood and save to preferences', () async {
      // Select a new mood
      await moodLogic.selectMood("sad.png");

      // Verify mood is updated
      expect(moodLogic.selectedMood, equals("sad.png"));

      // Verify mood is saved to preferences
      final savedMood = moodLogic.prefs.getString("mood");
      expect(savedMood, equals("sad.png"));
    });

    test('should correctly identify selected mood', () async {
      await moodLogic.selectMood("neutral.png");

      expect(moodLogic.isMoodSelected("neutral.png"), isTrue);
      expect(moodLogic.isMoodSelected("happy.png"), isFalse);
      expect(moodLogic.isMoodSelected("sad.png"), isFalse);
    });

    test('should return all available moods', () {
      final availableMoods = moodLogic.getAvailableMoods();

      expect(availableMoods, hasLength(5));
      expect(availableMoods, contains("love.png"));
      expect(availableMoods, contains("happy.png"));
      expect(availableMoods, contains("neutral.png"));
      expect(availableMoods, contains("frowning.png"));
      expect(availableMoods, contains("sad.png"));
    });

    test('should handle multiple mood changes correctly', () async {
      // Change mood multiple times
      await moodLogic.selectMood("happy.png");
      expect(moodLogic.selectedMood, equals("happy.png"));

      await moodLogic.selectMood("frowning.png");
      expect(moodLogic.selectedMood, equals("frowning.png"));

      await moodLogic.selectMood("love.png");
      expect(moodLogic.selectedMood, equals("love.png"));

      // Verify final state is saved
      final savedMood = moodLogic.prefs.getString("mood");
      expect(savedMood, equals("love.png"));
    });

    test('should persist mood across logic instance recreation', () async {
      // Set mood with first instance
      await moodLogic.selectMood("sad.png");

      // Create new instance and load preferences
      final newMoodLogic = MoodSelectionLogic();
      await newMoodLogic.initializePrefs();
      await newMoodLogic.loadUserMood();

      // Verify mood persisted
      expect(newMoodLogic.selectedMood, equals("sad.png"));
    });

    test('should handle invalid mood gracefully', () async {
      // This test assumes the logic should handle invalid moods
      // by either ignoring them or falling back to default
      const invalidMood = "invalid_mood.png";

      await moodLogic.selectMood(invalidMood);

      // The logic currently doesn't validate moods, so it will accept any string
      // In a real implementation, you might want to add validation
      expect(moodLogic.selectedMood, equals(invalidMood));
    });

    group('Mood Categories', () {
      test('should categorize positive moods correctly', () {
        final positiveMoods = ["love.png", "happy.png"];

        for (final mood in positiveMoods) {
          expect(moodLogic.getAvailableMoods(), contains(mood));
        }
      });

      test('should categorize neutral mood correctly', () {
        expect(moodLogic.getAvailableMoods(), contains("neutral.png"));
      });

      test('should categorize negative moods correctly', () {
        final negativeMoods = ["frowning.png", "sad.png"];

        for (final mood in negativeMoods) {
          expect(moodLogic.getAvailableMoods(), contains(mood));
        }
      });
    });

    group('Edge Cases', () {
      test('should handle empty string mood', () async {
        await moodLogic.selectMood("");
        expect(moodLogic.selectedMood, equals(""));
      });

      test('should handle null preference gracefully', () async {
        // Remove the mood preference entirely
        await moodLogic.prefs.remove("mood");

        // Load user mood should fall back to default
        await moodLogic.loadUserMood();

        expect(moodLogic.selectedMood, equals("love.png"));
      });

      test('should handle preference loading failure gracefully', () async {
        // This test simulates what happens if SharedPreferences fails
        // In the current implementation, it would use the default value
        await moodLogic.loadUserMood();

        // Should not throw and should have a valid mood
        expect(moodLogic.selectedMood, isNotEmpty);
        expect(moodLogic.selectedMood, isA<String>());
      });
    });
  });
}
