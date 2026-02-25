import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rayoflite/core/theme/appcolors.dart';

class CreatePostSheet extends StatefulWidget {
  const CreatePostSheet({super.key});

  @override
  State<CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends State<CreatePostSheet> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController controller = TextEditingController();
  final List<File> images = [];

  Future<void> pickImages() async {
    final img = await _picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      images.add(File(img.path));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * .9,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.getMonoCard(isDark),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text("Create post"),
              const Spacer(),
              ElevatedButton(onPressed: () {}, child: const Text("Post")),
            ],
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            children: [
              ...images.map(
                (e) => ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(e, width: 70, height: 70, fit: BoxFit.cover),
                ),
              ),
              GestureDetector(
                onTap: pickImages,
                child: Container(
                  width: 70,
                  height: 70,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          TextField(
            controller: controller,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: "What's on your mind?",
            ),
          ),
        ],
      ),
    );
  }
}