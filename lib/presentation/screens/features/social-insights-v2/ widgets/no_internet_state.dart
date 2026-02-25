import 'package:flutter/material.dart';

class NoInternetState extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternetState({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onRetry,
        child: const Text("No Internet — Retry"),
      ),
    );
  }
}