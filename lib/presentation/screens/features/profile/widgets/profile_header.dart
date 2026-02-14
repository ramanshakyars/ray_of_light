import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/theme/AppFont.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class ProfileHeader extends StatelessWidget{
 const ProfileHeader({super.key});

 @override
 Widget build(BuildContext context){
  final isDark = context.watch<ThemeProvider>().isDarkMode;
  return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.getMuted(isDark),
          child: Text(
            "K",
            style: AppTextStyles.bold22(isDark),
          ),
        ),
        const SizedBox(height: 12),
        Text("Khushi", style: AppTextStyles.bold28(isDark)),
        const SizedBox(height: 4),
        Text(
          "Spreading light since Jan 2026",
          style: AppTextStyles.regular14(isDark),
        ),
      ],
    );
 }


}