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
            content: Text("Failed to deleting account. Please try again."),
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

  Widget _buildProfileCard(bool isDarkMode) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(24),
      color: AppColors.getFormsCardColor(isDarkMode),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: AppColors.getFormSubmitButtonColor(isDarkMode),
              child: Icon(
                Icons.person,
                size: 60,
                color: AppColors.getTextSecondaryColor(isDarkMode),
              ),
            ),
            const SizedBox(height: 24),
            if (userData?['name'] != null)
              Text(
                userData?['name'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getTextPrimaryColor(isDarkMode),
                  fontFamily: 'Specimen',
                ),
              ),
            const SizedBox(height: 16),
            if (userData?['email'] != null)
              _buildDetailItem(Icons.email, userData?['email'], isDarkMode),
            const SizedBox(height: 12),
            if (userData?['phoneNumber'] != null)
              _buildDetailItem(
                Icons.phone,
                userData?['phoneNumber'],
                isDarkMode,
              ),
            const SizedBox(height: 12),
            if (userData?['dob'] != null)
              _buildDetailItem(
                Icons.cake,
                _formatDob(userData?['dob']),
                isDarkMode,
              ),
            const SizedBox(height: 32),

            // Theme Toggle Section
            Card(
              color: AppColors.getFormsCardColor(isDarkMode),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dark Mode',
                      style: TextStyle(
                        color: AppColors.getTextPrimaryColor(isDarkMode),
                        fontSize: 18,
                        fontFamily: 'Specimen',
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
                      activeColor: AppColors.getFormSubmitButtonColor(
                        isDarkMode,
                      ),
                      inactiveTrackColor: Colors.grey.shade400,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Theme Preview Section
            // Card(
            //   color: AppColors.getFormsCardColor(isDarkMode).withOpacity(0.8),
            //   child: Padding(
            //     padding: const EdgeInsets.all(16.0),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           'Theme Preview',
            //           style: TextStyle(
            //             color: AppColors.getTextPrimaryColor(isDarkMode),
            //             fontSize: 16,
            //             fontFamily: 'Specimen',
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //         const SizedBox(height: 12),
            //         Container(
            //           padding: const EdgeInsets.all(12),
            //           decoration: BoxDecoration(
            //             color: AppColors.getTalkToLiteButtonBackgroundColor(
            //               isDarkMode,
            //             ),
            //             borderRadius: BorderRadius.circular(8),
            //           ),
            //           child: Text(
            //             'Button',
            //             style: TextStyle(
            //               color: AppColors.getTextSecondaryColor(isDarkMode),
            //               fontFamily: 'Specimen',
            //             ),
            //           ),
            //         ),
            //         const SizedBox(height: 8),
            //         Container(
            //           padding: const EdgeInsets.all(12),
            //           decoration: BoxDecoration(
            //             color: AppColors.getFormsCardColor(isDarkMode),
            //             border: Border.all(
            //               color: AppColors.getInputFieldBackgroundColor(
            //                 isDarkMode,
            //               ),
            //             ),
            //             borderRadius: BorderRadius.circular(8),
            //           ),
            //           child: Text(
            //             'Card Content',
            //             style: TextStyle(
            //               color: AppColors.getTextPrimaryColor(isDarkMode),
            //               fontFamily: 'Specimen',
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            const SizedBox(height: 32),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.logout, size: 20, color: Colors.red),
                label: Text(
                  'LOGOUT',
                  style: TextStyle(
                    letterSpacing: 1,
                    color: Colors.red,
                    fontFamily: 'Specimen',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[50],
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  _showLogoutConfirmationDialog(isDarkMode);
                },
              ),
            ),

            const SizedBox(height: 16),

            // Delete Account Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: Colors.red[900],
                ),
                label: Text(
                  'DELETE ACCOUNT',
                  style: TextStyle(
                    letterSpacing: 1,
                    color: Colors.red[900],
                    fontFamily: 'Specimen',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[100],
                  foregroundColor: Colors.red[900],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.red[300]!),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  _showDeleteAccountConfirmationDialog(isDarkMode);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 24,
          color: AppColors.getTextPrimaryColor(isDarkMode).withOpacity(0.7),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.getTextPrimaryColor(isDarkMode),
              fontFamily: 'Specimen',
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  void _showLogoutConfirmationDialog(bool isDarkMode) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.getFormsCardColor(isDarkMode),
            title: Text(
              'Logout',
              style: TextStyle(
                color: AppColors.getTextPrimaryColor(isDarkMode),
                fontFamily: 'Specimen',
              ),
            ),
            content: Text(
              'Are you sure you want to logout?',
              style: TextStyle(
                color: AppColors.getTextPrimaryColor(isDarkMode),
                fontFamily: 'Specimen',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.getTextPrimaryColor(isDarkMode),
                    fontFamily: 'Specimen',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _logout();
                },
                child: Text(
                  'Logout',
                  style: TextStyle(color: Colors.red, fontFamily: 'Specimen'),
                ),
              ),
            ],
          ),
    );
  }

  void _showDeleteAccountConfirmationDialog(bool isDarkMode) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.getFormsCardColor(isDarkMode),
            title: Text(
              'Delete Account',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontFamily: 'Specimen',
              ),
            ),
            icon: Icon(Icons.warning, color: Colors.red, size: 40),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This action cannot be undone!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.getTextPrimaryColor(isDarkMode),
                    fontFamily: 'Specimen',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'All your data will be permanently deleted including:',
                  style: TextStyle(
                    color: AppColors.getTextPrimaryColor(isDarkMode),
                    fontFamily: 'Specimen',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '• Personal information',
                  style: TextStyle(
                    color: AppColors.getTextPrimaryColor(isDarkMode),
                    fontFamily: 'Specimen',
                  ),
                ),
                Text(
                  '• Account settings',
                  style: TextStyle(
                    color: AppColors.getTextPrimaryColor(isDarkMode),
                    fontFamily: 'Specimen',
                  ),
                ),
                Text(
                  '• Any saved preferences',
                  style: TextStyle(
                    color: AppColors.getTextPrimaryColor(isDarkMode),
                    fontFamily: 'Specimen',
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Are you sure you want to proceed?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.getTextPrimaryColor(isDarkMode),
                    fontFamily: 'Specimen',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.getTextPrimaryColor(isDarkMode),
                    fontFamily: 'Specimen',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showFinalConfirmationDialog(isDarkMode);
                },
                child: Text(
                  'Delete Account',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Specimen',
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _showFinalConfirmationDialog(bool isDarkMode) {
    final TextEditingController confirmController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.getFormsCardColor(isDarkMode),
            title: Text(
              'Final Confirmation',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontFamily: 'Specimen',
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'This is your last chance to cancel. Your account will be permanently deleted.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.getTextPrimaryColor(isDarkMode),
                    fontFamily: 'Specimen',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Type "DELETE" to confirm:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.getTextPrimaryColor(isDarkMode),
                    fontFamily: 'Specimen',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: confirmController,
                  decoration: InputDecoration(
                    hintText: 'Type DELETE here',
                    border: OutlineInputBorder(),
                    hintStyle: TextStyle(fontFamily: 'Specimen'),
                  ),
                  style: TextStyle(
                    fontFamily: 'Specimen',
                    color: AppColors.getTextPrimaryColor(isDarkMode),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.getTextPrimaryColor(isDarkMode),
                    fontFamily: 'Specimen',
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
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
                  'Confirm Deletion',
                  style: TextStyle(fontFamily: 'Specimen'),
                ),
              ),
            ],
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
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.getAppBackgroundColor(isDarkMode),
        foregroundColor: AppColors.getTextPrimaryColor(isDarkMode),
      ),
      body:
          isLoading
              ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.getFormSubmitButtonColor(isDarkMode),
                ),
              )
              : Center(
                child: SingleChildScrollView(
                  child: _buildProfileCard(isDarkMode),
                ),
              ),
    );
  }
}
