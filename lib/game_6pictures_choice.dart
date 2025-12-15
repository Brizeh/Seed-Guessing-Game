import 'dart:math';
import 'package:flutter/material.dart';
import 'seeds.dart';

class SixPictureGame extends StatefulWidget {
  const SixPictureGame({super.key});

  @override
  State<SixPictureGame> createState() => _SixPictureGameState();
}

class _SixPictureGameState extends State<SixPictureGame> {
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

    selectedIndex = null;
    wrongSelections.clear();

    final correctSeed = seeds[random.nextInt(seeds.length)];
    currentSeedName = correctSeed.name;

    correctImage =
        correctSeed.images[random.nextInt(correctSeed.images.length)].trim();

    final wrongSeeds = List.from(seeds)..remove(correctSeed)..shuffle();
    final wrongImages = wrongSeeds
        .take(5) // 5 wrong images to make 6 total
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
      appBar: AppBar(title: const Text('6 Pictures → 1 Name')),
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

              // Grid of 6 images in 2 columns × 3 rows
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2, // 2 columns
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
            top: screenHeight * 0.80,
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
