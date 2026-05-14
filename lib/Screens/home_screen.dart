import 'package:flutter/material.dart';
import '../Data/shows_data.dart';
import '../Widgets/show_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080b14),
      appBar: AppBar(
        title: const Text(
          'CineVault',
          style: TextStyle(
            color: Color(0xFFf0f4ff),
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: const Color(0xFF080b14),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive grid based on screen width
          int crossAxisCount = constraints.maxWidth > 600
              ? 4
              : constraints.maxWidth > 400
              ? 3
              : 2;
          double childAspectRatio = constraints.maxWidth > 600
              ? 0.7
              : constraints.maxWidth > 400
              ? 0.8
              : 0.85;
          double spacing = constraints.maxWidth > 600 ? 16 : 12;

          return Padding(
            padding: EdgeInsets.all(spacing),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing * 1.3,
              ),
              itemCount: allShows.length,
              itemBuilder: (context, index) {
                return ShowCard(show: allShows[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
