import 'dart:math';
import 'package:flutter/material.dart';
import 'seeds.dart';

class NameChoiceGame extends StatefulWidget {
  const NameChoiceGame({super.key});

  @override
  State<NameChoiceGame> createState() => _NameChoiceGameState();
}

class _NameChoiceGameState extends State<NameChoiceGame> {
  late Seed correctSeed;
  late String correctImage;
  late List<String> choices;

  int totalGuesses = 0;
  int goodGuesses = 0;

  int? selectedIndex; // last clicked index
  Map<int, bool> wrongSelections = {}; // track wrong buttons

  @override
  void initState() {
    super.initState();
    nextRound();
  }

  void nextRound() {
    final random = Random();

    // Reset selections
    selectedIndex = null;
    wrongSelections.clear();

    // Pick correct seed
    correctSeed = seeds[random.nextInt(seeds.length)];
    correctImage =
        correctSeed.images[random.nextInt(correctSeed.images.length)].trim();

    // Pick 3 wrong seed names
    final wrongSeeds = List.from(seeds)..remove(correctSeed)..shuffle();
    final wrongNames =
        wrongSeeds.take(3).map((s) => s.name.trim()).toList();

    // Combine correct name + wrong names and shuffle
    choices = [correctSeed.name.trim(), ...wrongNames]..shuffle();
  }

  bool isCorrect(String selected) {
    return selected.trim() == correctSeed.name.trim();
  }

  void checkAnswer(int index) {
    if (wrongSelections[index] == true) return; // already wrong, do nothing

    bool correct = isCorrect(choices[index]);

    setState(() {
      selectedIndex = index;

      if (correct) {
        goodGuesses++;
        totalGuesses++;
        // Move to next round
        nextRound();
      } else {
        // Mark button as wrong
        wrongSelections[index] = true;
        totalGuesses++;
      }
    });
  }

  String scoreText() {
    if (totalGuesses == 0) return '0 / 0 (0%)';
    final percent = (goodGuesses / totalGuesses * 100).round();
    return '$goodGuesses / $totalGuesses ($percent%)';
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: const Text('4 Names → 1 Picture')),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),

              // Picture
              Expanded(
                child: Center(
                  child: Image.asset(
                    correctImage,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // 4 name buttons
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: List.generate(choices.length, (index) {
                    Color borderColor = Colors.transparent;

                    if (wrongSelections[index] == true) {
                      borderColor = Colors.red; // wrong attempt
                    } else if (selectedIndex == index) {
                      borderColor = Colors.green; // correct
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          side: BorderSide(color: borderColor, width: 3),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        onPressed: () => checkAnswer(index),
                        child: Text(choices[index]),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),

          // Score at 20% screen height
          Positioned(
            top: screenHeight * 0.0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  scoreText(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
