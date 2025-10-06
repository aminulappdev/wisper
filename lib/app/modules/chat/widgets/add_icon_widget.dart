import 'package:flutter/material.dart';

class AddIconWidget extends StatelessWidget {
  final VoidCallback? onTap;
  const AddIconWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 31,
        width: 31,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(Icons.add, color: Colors.white, size: 20),
      ),
    );
  }
}
