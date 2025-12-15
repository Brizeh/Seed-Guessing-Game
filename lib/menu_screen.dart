import 'package:flutter/material.dart';
import 'game_picture_choice.dart';
import 'game_name_choice.dart';
import 'game_6pictures_choice.dart';
import 'game_6names_choice.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fasai Seed Guessing Game')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 4 Pictures → 1 Name
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(250, 60),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PictureChoiceGame(),
                    ),
                  );
                },
                child: const Text('4 Pictures → 1 Name'),
              ),
              const SizedBox(height: 20),

              // 6 Pictures → 1 Name
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(250, 60),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SixPictureGame(),
                    ),
                  );
                },
                child: const Text('6 Pictures → 1 Name'),
              ),
              const SizedBox(height: 20),

              // 4 Names → 1 Picture
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(250, 60),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NameChoiceGame(),
                    ),
                  );
                },
                child: const Text('4 Names → 1 Picture'),
              ),
              const SizedBox(height: 20),

              // 6 Names → 1 Picture
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(250, 60),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SixNamesGame(),
                    ),
                  );
                },
                child: const Text('6 Names → 1 Picture'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
