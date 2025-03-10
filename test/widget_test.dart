import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memorization_game/main.dart'; // Update the import based on your file structure.

void main() {
  group('Memorization Game Tests', () {
    testWidgets('Welcome Screen has difficulty buttons',
        (WidgetTester tester) async {
      // Build the app and trigger a frame
      await tester.pumpWidget(const MemorizationGameApp());

      // Verify the presence of difficulty buttons
      expect(find.text('Easy'), findsOneWidget);
      expect(find.text('Medium'), findsOneWidget);
      expect(find.text('Hard'), findsOneWidget);

      // Verify the presence of images
      expect(find.byType(Image),
          findsNWidgets(3)); // One image for each difficulty
    });

    testWidgets('Navigates to Game Screen on Easy button press',
        (WidgetTester tester) async {
      // Build the app and trigger a frame
      await tester.pumpWidget(const MemorizationGameApp());

      // Tap the Easy button
      await tester.tap(find.text('Easy'));
      await tester.pumpAndSettle(); // Wait for navigation to complete

      // Verify we are on the Game Screen
      expect(find.textContaining('Level 1'), findsOneWidget);
    });

    testWidgets('Game Screen displays sequence during display phase',
        (WidgetTester tester) async {
      // Build the Game Screen
      await tester.pumpWidget(
        const MaterialApp(
          home: GameScreen(levels: 3, baseTime: 3000),
        ),
      );

      // Verify the sequence is displayed
      await tester.pump(); // Trigger the frame with sequence display
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('User input field is displayed after sequence',
        (WidgetTester tester) async {
      // Build the Game Screen
      await tester.pumpWidget(
        const MaterialApp(
          home: GameScreen(levels: 3, baseTime: 3000),
        ),
      );

      // Wait for the display phase to finish
      await tester.pump(const Duration(milliseconds: 3000));

      // Verify the input field and submit button
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('Submit button gives feedback on incorrect input',
        (WidgetTester tester) async {
      // Build the Game Screen
      await tester.pumpWidget(
        const MaterialApp(
          home: GameScreen(levels: 1, baseTime: 3000),
        ),
      );

      // Wait for the display phase to finish
      await tester.pump(const Duration(milliseconds: 3000));

      // Enter incorrect input and submit
      await tester.enterText(find.byType(TextField), '1 2 3');
      await tester.tap(find.text('Submit'));
      await tester.pump();

      // Verify feedback message
      expect(find.textContaining('Incorrect!'), findsOneWidget);
    });

    testWidgets('Submit button proceeds on correct input',
        (WidgetTester tester) async {
      // Build the Game Screen with a specific sequence
      await tester.pumpWidget(
        const MaterialApp(
          home: GameScreen(levels: 1, baseTime: 3000),
        ),
      );

      // Wait for the display phase to finish
      await tester.pump(const Duration(milliseconds: 3000));

      // Enter correct input and submit (match the random sequence)
      final sequenceText = (tester.widget(find.textContaining('')).toString());
      final correctInput = sequenceText.replaceAll('Text', '').trim();
      await tester.enterText(find.byType(TextField), correctInput);
      await tester.tap(find.text('Submit'));
      await tester.pump();

      // Verify feedback for correct input
      expect(find.textContaining('Correct!'), findsOneWidget);
    });
  });
}
