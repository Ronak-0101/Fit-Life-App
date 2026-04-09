// import 'package:fit_life_app_/screens/profile/setting_screen.dart';
// import 'package:fit_life_app_/utils/storage.dart';
// import 'package:flutter/material.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   late Map<String, String> _userData;

//   @override
//   void initState() {
//     super.initState();
//     _userData = StorageService.getUserData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final name = _userData['name'] ?? '';
//     final email = _userData['email'] ?? '';
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           // Card(
//           //   child: ListTile(
//           //     leading: const CircleAvatar(
//           //       child: Icon(Icons.person),
//           //     ),
//           //     title: Text(name.isEmpty ? 'Fit-Life User' : name),
//           //     subtitle: Text(email.isEmpty ? 'No Email Available' : email),
//           //   ),
//           // ),
//           const SizedBox(
//             height: 80,
//             width: 80,
//             child: CircleAvatar(
//               child: Icon(Icons.fitness_center),
//             ),
//           ),
//           const SizedBox(height: 10),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(name.isEmpty ? 'Fit-Life User' : name,
//                   style: const TextStyle(
//                       fontWeight: FontWeight.bold, fontSize: 20)),
//               const SizedBox(height: 3),
//               Text(email.isEmpty ? 'No email available' : email)
//             ],
//           ),
//           const SizedBox(height: 16),
//           Card(
//             child: ListTile(
//               leading: const Icon(Icons.settings),
//               title: const Text('Settings'),
//               subtitle: const Text('Manage your account options'),
//               trailing: const Icon(Icons.chevron_right),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => const SettingsScreen(),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:fit_life_app_/services/auth_service.dart';
import 'package:fit_life_app_/utils/storage.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Widget buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    bool showLoader = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: showLoader
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget buildSection(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  late Map<String, String> _userData;

  @override
  void initState() {
    super.initState();
    _userData = StorageService.getUserData();
  }

  bool _isLoggingOut = false;

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    setState(() {
      _isLoggingOut = true;
    });

    final result = await AuthService.logout();

    if (!mounted) return;

    setState(() {
      _isLoggingOut = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'] ?? 'Logged out')),
    );

    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final name = _userData['name'] ?? '';
    final email = _userData['email'] ?? '';
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Profile"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            /// Profile Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    child: Icon(Icons.person),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name.isEmpty ? "Fit-Life User" : name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(email.isEmpty ? "No email available" : email,
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.edit)
                ],
              ),
            ),

            const SizedBox(height: 15),

            /// Section 1
            buildSection([
              buildMenuItem(
                icon: Icons.language,
                title: "Language",
                subtitle: "English",
                onTap: () {
                  print("Open Language Settings");
                },
              ),
              buildMenuItem(
                icon: Icons.notifications_none,
                title: "Notifications",
                onTap: () {
                  print("Open Notifications");
                },
              ),
            ]),

            /// Section 2
            buildSection([
              buildMenuItem(
                icon: Icons.phone_outlined,
                title: "Contact Us",
                onTap: () {
                  print("Open Contact Page");
                },
              ),
              buildMenuItem(
                icon: Icons.help_outline,
                title: "Get Help",
                onTap: () {
                  print("Open Help Center");
                },
              ),
              buildMenuItem(
                icon: Icons.privacy_tip_outlined,
                title: "Privacy Policy",
                onTap: () {
                  print("Open Privacy Policy");
                },
              ),
              buildMenuItem(
                icon: Icons.description_outlined,
                title: "Terms & Conditions",
                onTap: () {
                  print("Open Terms Page");
                },
              ),
              buildMenuItem(
                icon: Icons.logout,
                title: "Log out",
                showLoader: _isLoggingOut,
                onTap: _isLoggingOut ? () {} : _logout,
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: const Center(child: Text("Login Screen")),
    );
  }
}
