import 'package:flutter/material.dart';

class MoodPickerSheet extends StatelessWidget {
  const MoodPickerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final moods = ["😊", "😌", "🌟", "☁️", "🌅", "✨", "🌸", "🌊"];

    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * .6,
      child: GridView.builder(
        itemCount: moods.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemBuilder: (_, i) {
          return Center(
            child: Text(
              moods[i],
              style: const TextStyle(fontSize: 28),
            ),
          );
        },
      ),
    );
  }
}