import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/constants/pathConfig.dart';
import 'package:rayoflite/core/services/httpService.dart';
import 'package:rayoflite/core/services/localStorageService.dart';
import 'package:rayoflite/core/theme/appcolors.dart';
import 'package:rayoflite/core/theme/themeProvider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await LocalStorageService.getUser();
    setState(() {
      userData = user;
      isLoading = false;
    });
  }

  Future<void> _logout() async {
    await LocalStorageService.clearAll();
    if (mounted) {
      GoRouter.of(context).go(RouteNames.login);
    }
  }

  Future<void> _deleteAccount() async {
    try {
      final response = await HttpService.put(PathConfig.deleteAccount, {});
      debugPrint("Deactivation response: $response");
      await LocalStorageService.clearAll();
      if (mounted) {
        GoRouter.of(context).go(RouteNames.accountDeactivate);
      }
    } catch (e) {
      debugPrint("Error deactivating account: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to delete account. Please try again."),
          ),
        );
      }
    }
  }

  String _formatDob(List<dynamic>? dobList) {
    if (dobList == null || dobList.length < 3) return 'Not specified';
    final year = dobList[0];
    final month = dobList[1];
    final day = dobList[2];
    return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
  }

  Widget _buildProfileHeader(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDarkMode
                  ? [Colors.blueGrey.shade900, Colors.blueGrey.shade800]
                  : [Colors.blue.shade50, Colors.lightBlue.shade50],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          // Profile Avatar with gradient border
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:isDarkMode? [Colors.blueAccent, Colors.purpleAccent]: [Colors.blue.shade400, Colors.lightBlue.shade300],
              ),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.getFormsCardColor(isDarkMode),
              child: Icon(
                Icons.person,
                size: 50,
                color: AppColors.getTextSecondaryColor(isDarkMode),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (userData?['name'] != null)
            Text(
              userData?['name'],
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.getTextPrimaryColor(isDarkMode),
                fontFamily: 'Specimen',
              ),
            ),
          const SizedBox(height: 8),
          if (userData?['email'] != null)
            Text(
              userData?['email'],
              style: TextStyle(
                fontSize: 16,
                color: AppColors.getTextPrimaryColor(
                  isDarkMode,
                ).withOpacity(0.8),
                fontFamily: 'Specimen',
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(bool isDarkMode) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: AppColors.getFormsCardColor(isDarkMode),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildInfoItem(
              Icons.phone,
              'Phone Number',
              userData?['phoneNumber'] ?? 'Not provided',
              isDarkMode,
            ),
            const SizedBox(height: 20),
            _buildInfoItem(
              Icons.cake,
              'Date of Birth',
              _formatDob(userData?['dob']),
              isDarkMode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String title,
    String value,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.getFormsCardColor(isDarkMode).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.getInputFieldBackgroundColor(
            isDarkMode,
          ).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.getFormSubmitButtonColor(
                isDarkMode,
              ).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppColors.getFormSubmitButtonColor(isDarkMode),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.getTextPrimaryColor(
                      isDarkMode,
                    ).withOpacity(0.6),
                    fontFamily: 'Specimen',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.getTextPrimaryColor(isDarkMode),
                    fontFamily: 'Specimen',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSection(bool isDarkMode) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      color: AppColors.getFormsCardColor(isDarkMode),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.palette, color: Colors.orange, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dark Mode',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.getTextPrimaryColor(isDarkMode),
                      fontFamily: 'Specimen',
                    ),
                  ),
                  Text(
                    'Switch between light and dark theme',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.getTextPrimaryColor(
                        isDarkMode,
                      ).withOpacity(0.6),
                      fontFamily: 'Specimen',
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: isDarkMode,
              onChanged: (value) {
                Provider.of<ThemeProvider>(
                  context,
                  listen: false,
                ).toggleTheme();
              },
              activeColor: AppColors.getFormSubmitButtonColor(isDarkMode),
              inactiveTrackColor: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          // Logout Button
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade50, Colors.orange.shade50],
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.red.shade100),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.red,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () => _showLogoutConfirmationDialog(isDarkMode),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'LOGOUT',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      fontFamily: 'Specimen',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Delete Account Button
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade100, Colors.red.shade50],
              ),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.red.shade300),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.red.shade900,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () => _showDeleteAccountConfirmationDialog(isDarkMode),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete_outline, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'DELETE ACCOUNT',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      fontFamily: 'Specimen',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(bool isDarkMode) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: AppColors.getFormsCardColor(isDarkMode),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.logout, size: 48, color: Colors.orange),
                  const SizedBox(height: 16),
                  Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.getTextPrimaryColor(isDarkMode),
                      fontFamily: 'Specimen',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Are you sure you want to logout?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.getTextPrimaryColor(isDarkMode),
                      fontFamily: 'Specimen',
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(
                              color: AppColors.getTextPrimaryColor(
                                isDarkMode,
                              ).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: AppColors.getTextPrimaryColor(isDarkMode),
                              fontFamily: 'Specimen',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _logout();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Logout',
                            style: TextStyle(fontFamily: 'Specimen'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _showDeleteAccountConfirmationDialog(bool isDarkMode) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: AppColors.getFormsCardColor(isDarkMode),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.warning_amber,
                      size: 48,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Delete Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontFamily: 'Specimen',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'This action cannot be undone! All your data will be permanently deleted.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.getTextPrimaryColor(isDarkMode),
                      fontFamily: 'Specimen',
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(
                              color: AppColors.getTextPrimaryColor(
                                isDarkMode,
                              ).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: AppColors.getTextPrimaryColor(isDarkMode),
                              fontFamily: 'Specimen',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _showFinalConfirmationDialog(isDarkMode);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Continue',
                            style: TextStyle(fontFamily: 'Specimen'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _showFinalConfirmationDialog(bool isDarkMode) {
    final TextEditingController confirmController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: AppColors.getFormsCardColor(isDarkMode),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Final Confirmation',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontFamily: 'Specimen',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Type "DELETE" to confirm account deletion:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.getTextPrimaryColor(isDarkMode),
                      fontFamily: 'Specimen',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: confirmController,
                    decoration: InputDecoration(
                      hintText: 'Type DELETE here',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintStyle: TextStyle(fontFamily: 'Specimen'),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: 'Specimen',
                      color: AppColors.getTextPrimaryColor(isDarkMode),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(
                              color: AppColors.getTextPrimaryColor(
                                isDarkMode,
                              ).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: AppColors.getTextPrimaryColor(isDarkMode),
                              fontFamily: 'Specimen',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            if (confirmController.text.trim() == 'DELETE') {
                              Navigator.pop(context);
                              _deleteAccount();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Please type "DELETE" to confirm',
                                    style: TextStyle(fontFamily: 'Specimen'),
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text(
                            'Delete Account',
                            style: TextStyle(fontFamily: 'Specimen'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.getAppBackgroundColor(isDarkMode),
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: TextStyle(
            color: AppColors.getTextPrimaryColor(isDarkMode),
            fontFamily: 'Specimen',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.getTextPrimaryColor(isDarkMode),
      ),
      body:
          isLoading
              ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.getFormSubmitButtonColor(isDarkMode),
                ),
              )
              : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildProfileHeader(isDarkMode),
                    _buildInfoCard(isDarkMode),
                    _buildThemeSection(isDarkMode),
                    _buildActionButtons(isDarkMode),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
    );
  }
}
