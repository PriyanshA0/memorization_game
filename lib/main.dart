import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MemorizationGameApp());

class MemorizationGameApp extends StatelessWidget {
  const MemorizationGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memorization Game',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const WelcomeScreen(),
    );
  }
}

// Welcome Screen
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Memorization Game',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 30),
            DifficultyButton(
              title: 'Easy',
              image: 'assets/images/easy.gif',
              onTap: () => startGame(context, 10, 5000),
            ),
            DifficultyButton(
              title: 'Medium',
              image: 'assets/images/medium.gif',
              onTap: () => startGame(context, 15, 4000),
            ),
            DifficultyButton(
              title: 'Hard',
              image: 'assets/images/hard.gif',
              onTap: () => startGame(context, 20, 3000),
            ),
          ],
        ),
      ),
    );
  }

  void startGame(BuildContext context, int levels, int baseTime) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameScreen(levels: levels, baseTime: baseTime),
      ),
    );
  }
}

// Difficulty Button with Images
class DifficultyButton extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;

  const DifficultyButton({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Image.asset(
              image,
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// Game Screen
class GameScreen extends StatefulWidget {
  final int levels;
  final int baseTime;

  const GameScreen({super.key, required this.levels, required this.baseTime});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<int> sequence;
  int currentLevel = 1;
  bool isDisplayingSequence = true;
  String userInput = '';
  String feedbackMessage = '';

  @override
  void initState() {
    super.initState();
    generateSequence();
    startSequenceDisplay();
  }

  void generateSequence() {
    sequence = List.generate(currentLevel, (_) => Random().nextInt(10));
  }

  void startSequenceDisplay() {
    setState(() {
      isDisplayingSequence = true;
      userInput = '';
      feedbackMessage = '';
    });
    Future.delayed(
      Duration(milliseconds: widget.baseTime - (currentLevel * 200)),
      () {
        setState(() {
          isDisplayingSequence = false;
        });
      },
    );
  }

  void checkUserInput() {
    List<int> userSequence = userInput.split(' ').map(int.parse).toList();
    if (userSequence.length != sequence.length) {
      setFeedback('Incorrect! The correct sequence was: $sequence');
      return;
    }
    for (int i = 0; i < sequence.length; i++) {
      if (userSequence[i] != sequence[i]) {
        setFeedback('Incorrect! The correct sequence was: $sequence');
        return;
      }
    }
    if (currentLevel == widget.levels) {
      setFeedback('Congratulations! You completed all levels!');
    } else {
      setState(() {
        currentLevel++;
        generateSequence();
        startSequenceDisplay();
      });
    }
  }

  void setFeedback(String message) {
    setState(() {
      feedbackMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Level $currentLevel'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isDisplayingSequence)
              Text(
                sequence.join(' '),
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              )
            else
              Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      userInput = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Enter the sequence',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: checkUserInput,
                    child: const Text('Submit'),
                  ),
                ],
              ),
            if (feedbackMessage.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                feedbackMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: feedbackMessage.contains('Incorrect')
                      ? Colors.red
                      : Colors.green,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
