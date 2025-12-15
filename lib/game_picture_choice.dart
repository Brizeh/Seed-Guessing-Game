import 'dart:math';
import 'package:flutter/material.dart';
import 'seeds.dart';

class PictureChoiceGame extends StatefulWidget {
  const PictureChoiceGame({super.key});

  @override
  State<PictureChoiceGame> createState() => _PictureChoiceGameState();
}

class _PictureChoiceGameState extends State<PictureChoiceGame> {
  late String currentSeedName;
  late String correctImage;
  late List<String> choices;

  int totalGuesses = 0;
  int goodGuesses = 0;

  int? selectedIndex; // last tapped image index
  Map<int, bool> wrongSelections = {}; // track wrong images

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

    final correctSeed = seeds[random.nextInt(seeds.length)];
    currentSeedName = correctSeed.name;

    correctImage =
        correctSeed.images[random.nextInt(correctSeed.images.length)].trim();

    final wrongSeeds = List.from(seeds)..remove(correctSeed)..shuffle();
    final wrongImages = wrongSeeds
        .take(3)
        .map((s) => s.images[random.nextInt(s.images.length)].trim())
        .toList();

    choices = [correctImage, ...wrongImages]..shuffle();
  }

  bool isCorrect(String selected) {
    return selected.split('/').last.trim() ==
        correctImage.split('/').last.trim();
  }

  void checkAnswer(int index) {
    if (wrongSelections[index] == true || selectedIndex == index) return;

    bool correct = isCorrect(choices[index]);

    setState(() {
      selectedIndex = index;

      if (correct) {
        goodGuesses++;
        totalGuesses++;
        nextRound(); // move to next round
      } else {
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
      appBar: AppBar(title: const Text('4 Pictures → 1 Name')),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 20),

              Text(
                currentSeedName,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // Grid of images
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(16),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: List.generate(choices.length, (index) {
                    Color borderColor = Colors.transparent;

                    if (wrongSelections[index] == true) {
                      borderColor = Colors.red; // wrong
                    } else if (selectedIndex == index &&
                        isCorrect(choices[index])) {
                      borderColor = Colors.green; // correct
                    }

                    return GestureDetector(
                      onTap: () => checkAnswer(index),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: borderColor, width: 3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Image.asset(
                          choices[index],
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),

          // Score at 20% screen height
          Positioned(
            top: screenHeight * 0.60,
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
