// import 'package:flutter/material.dart';
// import 'admin_dashboard_screen.dart';

// class AdminLoginScreen extends StatefulWidget {
//   const AdminLoginScreen({super.key});
//   @override
//   State<AdminLoginScreen> createState() => _AdminLoginScreenState();
// }

// class _AdminLoginScreenState extends State<AdminLoginScreen> {
//   final _usernameCtrl = TextEditingController();
//   final _passwordCtrl = TextEditingController();
//   bool _loading = false;
//   // Simple hardcoded admin credentials (change later to Firebase Auth)
//   final String adminUsername = "admin";
//   final String adminPassword = "admin123";
//   void _login() async {
//     setState(() => _loading = true);
//     await Future.delayed(const Duration(milliseconds: 800));
//     if (_usernameCtrl.text.trim() == adminUsername &&
//         _passwordCtrl.text.trim() == adminPassword) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Invalid admin credentials")),
//       );
//     }
//     setState(() => _loading = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.indigo[900]!, Colors.indigo[600]!],
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(32),
//             child: Column(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(16),
//                   child: Image.asset(
//                     'assets/logo.png',
//                     width: 120,
//                     height: 120,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 const Text(
//                   'MG Public School',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 32),
//                 Card(
//                   elevation: 12,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(32),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           Icons.admin_panel_settings,
//                           size: 80,
//                           color: Colors.indigo[700],
//                         ),
//                         const SizedBox(height: 24),
//                         const Text(
//                           "Admin Login",
//                           style: TextStyle(
//                             fontSize: 28,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 32),
//                         TextField(
//                           controller: _usernameCtrl,
//                           decoration: const InputDecoration(
//                             labelText: "Username",
//                             prefixIcon: Icon(Icons.person),
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         TextField(
//                           controller: _passwordCtrl,
//                           obscureText: true,
//                           decoration: const InputDecoration(
//                             labelText: "Password",
//                             prefixIcon: Icon(Icons.lock),
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                         const SizedBox(height: 32),
//                         SizedBox(
//                           width: double.infinity,
//                           height: 52,
//                           child: ElevatedButton.icon(
//                             icon: _loading
//                                 ? const CircularProgressIndicator(
//                                     color: Colors.white,
//                                   )
//                                 : const Icon(Icons.login),
//                             label: Text(
//                               _loading ? "Logging in..." : "Login as Admin",
//                             ),
//                             onPressed: _loading ? null : _login,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
