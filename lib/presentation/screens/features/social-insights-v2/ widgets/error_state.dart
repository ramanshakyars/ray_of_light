import 'package:flutter/material.dart';

class ErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const ErrorState({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onRetry,
        child: const Text("Retry"),
      ),
    );
  }
}