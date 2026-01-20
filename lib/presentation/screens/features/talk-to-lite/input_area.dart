import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';
import 'package:rayoflite/presentation/screens/features/VoiceInputScreen%20.dart';

class InputArea extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isLoading;

  const InputArea({
    super.key,
    required this.controller,
    required this.onSend,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    // Mic button click par ye function chalega
    void _openVoiceInput() async {
      // Screen open karo aur result ka wait karo
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VoiceInputScreen(isDarkMode: isDarkMode),
        ),
      );

      // Agar result string hai aur empty nahi hai, toh controller mein set karo
      if (result != null && result is String && result.isNotEmpty) {
        controller.text = result;
        // User ko send button dabane se bachane ke liye onSend call kar sakte hain
        // onSend(); 
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.getAppBackgroundColor(isDarkMode),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(
                color: AppColors.getTextPrimaryColor(isDarkMode),
                fontSize: 16,
                fontFamily: "Specimen",
              ),
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5, // Limit max height
              decoration: InputDecoration(
                hintText: 'Talk to Light...',
                prefixIcon: IconButton(
                  icon: const Icon(Icons.mic, color: Colors.blueAccent),
                  onPressed: _openVoiceInput,
                ),
                hintStyle: TextStyle(
                  color: AppColors.getTextPrimaryColor(isDarkMode).withOpacity(0.5),
                  fontSize: 16,
                  fontFamily: "Specimen",
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(
                    color: AppColors.getTalkToLiteButtonBackgroundColor(isDarkMode),
                    width: 1.8,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircleAvatar(
                    backgroundColor: AppColors.getTalkToLiteButtonBackgroundColor(isDarkMode),
                    child: IconButton(
                      icon: isLoading 
                        ? const SizedBox(
                            width: 20, 
                            height: 20, 
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                          )
                        : const Icon(Icons.send, color: Colors.white, size: 20),
                      onPressed: isLoading ? null : onSend,
                    ),
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