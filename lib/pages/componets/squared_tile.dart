import 'package:flutter/material.dart';

class SquaredTile extends StatelessWidget {
  final String imagePath;
  const SquaredTile({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Image.asset(imagePath),
    );
  }
}
