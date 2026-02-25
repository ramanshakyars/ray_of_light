import 'package:flutter/material.dart';

class ShareLightSheet extends StatelessWidget {
  const ShareLightSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 320,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: const Column(
        children: [
          Text("Share this light"),
          SizedBox(height: 20),
          ListTile(title: Text("Share to Talk")),
          ListTile(title: Text("Save to Nest")),
          ListTile(title: Text("Share externally")),
        ],
      ),
    );
  }
}