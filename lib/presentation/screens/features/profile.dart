import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rayoflite/core/config/routenames.dart';
import 'package:rayoflite/core/services/localStorageService.dart';

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

  String _formatDob(List<dynamic>? dobList) {
    if (dobList == null || dobList.length < 3) return 'Not specified';
    final year = dobList[0];
    final month = dobList[1];
    final day = dobList[2];
    return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
  }

  Widget _buildProfileCard() {
    return Center(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 24),
              if (userData?['email'] != null)
                Text(
                  userData?['name'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              const SizedBox(height: 16),
              if (userData?['email'] != null)
                _buildDetailItem(Icons.email, userData?['email']),
              const SizedBox(height: 12),
              if (userData?['phoneNumber'] != null)
                _buildDetailItem(Icons.phone, userData?['phoneNumber']),
              const SizedBox(height: 12),
              if (userData?['dob'] != null)
                _buildDetailItem(Icons.cake, userData?['dob']),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout, size: 20),
                  label: const Text(
                    'LOGOUT',
                    style: TextStyle(letterSpacing: 1),
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
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Logout'),
                            content: const Text(
                              'Are you sure you want to logout?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _logout();
                                },
                                child: const Text(
                                  'Logout',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 24, color: Colors.blueGrey[300]),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            text,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.blueGrey,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  children: [const SizedBox(height: 20), _buildProfileCard()],
                ),
              ),
      backgroundColor: Colors.grey[50],
    );
  }
}
