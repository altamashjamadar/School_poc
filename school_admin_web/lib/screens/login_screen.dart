// // // import 'package:cloud_firestore/cloud_firestore.dart';
// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:school_admin_web/routes.dart';

// // // class LoginScreen extends StatefulWidget {
// // //   const LoginScreen({super.key});

// // //   @override
// // //   State<LoginScreen> createState() => _LoginScreenState();
// // // }

// // // class _LoginScreenState extends State<LoginScreen> {
// // //   final _emailCtrl = TextEditingController();
// // //   final _passwordCtrl = TextEditingController();
// // //   bool _loading = false;

// // //   Future<void> _login() async {
// // //     final email = _emailCtrl.text.trim();
// // //     final password = _passwordCtrl.text.trim();

// // //     if (email.isEmpty || password.isEmpty) {
// // //       ScaffoldMessenger.of(context).showSnackBar(
// // //         const SnackBar(content: Text("Enter email and password")),
// // //       );
// // //       return;
// // //     }

// // //     setState(() => _loading = true);

// // //     try {
// // //       final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
// // //         email: email,
// // //         password: password,
// // //       );

// // //       final userDoc = await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).get();

// // //       if (!userDoc.exists || userDoc.data()!['role'] != 'admin') {
// // //         await FirebaseAuth.instance.signOut();
// // //         ScaffoldMessenger.of(context).showSnackBar(
// // //           const SnackBar(content: Text("Admin access only")),
// // //         );
// // //         return;
// // //       }

// // //       Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
// // //     } on FirebaseAuthException catch (e) {
// // //       String msg = e.message ?? "Login failed";
// // //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
// // //     } catch (e) {
// // //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
// // //     } finally {
// // //       setState(() => _loading = false);
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       body: Center(
// // //         child: ConstrainedBox(
// // //           constraints: const BoxConstraints(maxWidth: 400),
// // //           child: Padding(
// // //             padding: const EdgeInsets.all(32),
// // //             child: Card(
// // //               elevation: 8,
// // //               child: Padding(
// // //                 padding: const EdgeInsets.all(32),
// // //                 child: Column(
// // //                   mainAxisSize: MainAxisSize.min,
// // //                   children: [
// // //                     const Icon(Icons.security, size: 80, color: Colors.indigo),
// // //                     const SizedBox(height: 24),
// // //                     const Text("Admin Login", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
// // //                     const SizedBox(height: 32),
// // //                     TextField(
// // //                       controller: _emailCtrl,
// // //                       decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
// // //                     ),
// // //                     const SizedBox(height: 16),
// // //                     TextField(
// // //                       controller: _passwordCtrl,
// // //                       obscureText: true,
// // //                       decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
// // //                     ),
// // //                     const SizedBox(height: 32),
// // //                     SizedBox(
// // //                       width: double.infinity,
// // //                       height: 52,
// // //                       child: ElevatedButton(
// // //                         onPressed: _loading ? null : _login,
// // //                         child: _loading
// // //                             ? const CircularProgressIndicator(color: Colors.white)
// // //                             : const Text("Login"),
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }


// //   import 'package:cloud_firestore/cloud_firestore.dart';
// //   import 'package:firebase_auth/firebase_auth.dart';
// //   import 'package:flutter/material.dart';
// //   import 'package:school_admin_web/routes.dart';

// //   class LoginScreen extends StatefulWidget {
// //     const LoginScreen({super.key});

// //     @override
// //     State<LoginScreen> createState() => _LoginScreenState();
// //   }

// //   class _LoginScreenState extends State<LoginScreen> {
// //     final _emailCtrl = TextEditingController();
// //     final _passwordCtrl = TextEditingController();
// //     bool _loading = false;

// //     Future<void> _login() async {
// //       final email = _emailCtrl.text.trim();
// //       final password = _passwordCtrl.text.trim();

// //       if (email.isEmpty || password.isEmpty) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text("Enter email and password")),
// //         );
// //         return;
// //       }

// //       setState(() => _loading = true);

// //       try {
// //         final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
// //           email: email,
// //           password: password,
// //         );

// //         final userDoc = await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).get();

// //         if (!userDoc.exists || userDoc.data()!['role'] != 'admin') {
// //           await FirebaseAuth.instance.signOut();
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             const SnackBar(content: Text("Admin access only")),
// //           );
// //           return;
// //         }

// //         Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
// //       } on FirebaseAuthException catch (e) {
// //         String msg = e.message ?? "Login failed";
// //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
// //       } catch (e) {
// //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
// //       } finally {
// //         setState(() => _loading = false);
// //       }
// //     }

// //     @override
// //     Widget build(BuildContext context) {
// //       return Scaffold(
// //         body: Center(
// //           child: ConstrainedBox(
// //             constraints: const BoxConstraints(maxWidth: 400),
// //             child: Padding(
// //               padding: const EdgeInsets.all(32),
// //               child: Card(
// //                 elevation: 8,
// //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(32),
// //                   child: Column(
// //                     mainAxisSize: MainAxisSize.min,
// //                     children: [
// //                       const Icon(Icons.admin_panel_settings, size: 80, color: Colors.indigo),
// //                       const SizedBox(height: 24),
// //                       const Text("Admin Login", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
// //                       const SizedBox(height: 32),
// //                       TextField(
// //                         controller: _emailCtrl,
// //                         keyboardType: TextInputType.emailAddress,
// //                         decoration: const InputDecoration(
// //                           labelText: "Email",
// //                           border: OutlineInputBorder(),
// //                         ),
// //                       ),
// //                       const SizedBox(height: 16),
// //                       TextField(
// //                         controller: _passwordCtrl,
// //                         obscureText: true,
// //                         decoration: const InputDecoration(
// //                           labelText: "Password",
// //                           border: OutlineInputBorder(),
// //                         ),
// //                       ),
// //                       const SizedBox(height: 32),
// //                       SizedBox(
// //                         width: double.infinity,
// //                         height: 52,
// //                         child: ElevatedButton(
// //                           onPressed: _loading ? null : _login,
// //                           style: ElevatedButton.styleFrom(
// //                             backgroundColor: Colors.indigo,
// //                             foregroundColor: Colors.white,
// //                           ),
// //                           child: _loading
// //                               ? const CircularProgressIndicator(color: Colors.white)
// //                               : const Text("Login", style: TextStyle(fontSize: 16)),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ),
// //       );
// //     }
// //   }


// import 'package:flutter/material.dart';
// import 'package:school_admin_web/routes.dart';
// import 'package:school_admin_web/services/auth_service.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isLoading = false;
//   String? _errorMessage;

//   final AuthService _authService = AuthService();

//   Future<void> _login() async {
//     final email = _emailController.text.trim();
//     final password = _passwordController.text.trim();

//     if (email.isEmpty || password.isEmpty) {
//       setState(() => _errorMessage = "Please enter email and password");
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       // Login via service
//       final user = await _authService.loginWithEmail(email, password);

//       if (user == null) {
//         setState(() => _errorMessage = "Login failed. Please try again.");
//         return;
//       }

//       // Get role
//       final role = await _authService.getUserRole();

//       if (role == 'admin') {
//         Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
//       } else {
//         await _authService.logout(); // kick out non-admins
//         setState(() => _errorMessage = "Access denied: Admin only");
//       }
//     } catch (e) {
//       setState(() => _errorMessage = e.toString().replaceAll('Exception: ', ''));
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ConstrainedBox(
//           constraints: const BoxConstraints(maxWidth: 420),
//           child: Padding(
//             padding: const EdgeInsets.all(32.0),
//             child: Card(
//               elevation: 10,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//               child: Padding(
//                 padding: const EdgeInsets.all(40.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Logo / Icon
//                     const Icon(
//                       Icons.admin_panel_settings_rounded,
//                       size: 80,
//                       color: Colors.indigo,
//                     ),
//                     const SizedBox(height: 24),

//                     // Title
//                     const Text(
//                       "Admin Login",
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.indigo,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       "Sign in to manage the school portal",
//                       style: TextStyle(color: Colors.grey[600]),
//                     ),

//                     const SizedBox(height: 40),

//                     // Error message
//                     if (_errorMessage != null)
//                       Padding(
//                         padding: const EdgeInsets.only(bottom: 16),
//                         child: Text(
//                           _errorMessage!,
//                           style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),

//                     // Email field
//                     TextField(
//                       controller: _emailController,
//                       keyboardType: TextInputType.emailAddress,
//                       decoration: InputDecoration(
//                         labelText: "Email",
//                         prefixIcon: const Icon(Icons.email_outlined),
//                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                         filled: true,
//                         fillColor: Colors.grey[100],
//                       ),
//                     ),
//                     const SizedBox(height: 20),

//                     // Password field
//                     TextField(
//                       controller: _passwordController,
//                       obscureText: true,
//                       decoration: InputDecoration(
//                         labelText: "Password",
//                         prefixIcon: const Icon(Icons.lock_outline),
//                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                         filled: true,
//                         fillColor: Colors.grey[100],
//                       ),
//                     ),
//                     const SizedBox(height: 12),

//                     // Forgot password link
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: TextButton(
//                         onPressed: () {
//                           // TODO: Add forgot password flow later
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text("Forgot password feature coming soon")),
//                           );
//                         },
//                         child: const Text("Forgot password?"),
//                       ),
//                     ),

//                     const SizedBox(height: 24),

//                     // Login button
//                     SizedBox(
//                       width: double.infinity,
//                       height: 52,
//                       child: ElevatedButton(
//                         onPressed: _isLoading ? null : _login,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.indigo,
//                           foregroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                           elevation: 2,
//                         ),
//                         child: _isLoading
//                             ? const SizedBox(
//                                 height: 24,
//                                 width: 24,
//                                 child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
//                               )
//                             : const Text("Login", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:school_admin_web/routes.dart';
import 'package:school_admin_web/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  final AuthService _authService = AuthService();

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = "Please enter email and password");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await _authService.loginWithEmail(email, password);

      if (user == null) {
        setState(() => _errorMessage = "Login failed. Please try again.");
        return;
      }

      final role = await _authService.getUserRole();

      if (role == 'admin') {
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      } else {
        await _authService.logout();
        setState(() => _errorMessage = "Access denied: Admin only");
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString().replaceAll('Exception: ', ''));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.indigo[900]!.withOpacity(0.95),
              Colors.indigo[700]!.withOpacity(0.85),
            ],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Illustration / Logo area (you can replace with real image)
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings_rounded,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Card with login form
                  Card(
                    elevation: 12,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Title
                          const Text(
                            "Admin Login",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Sign in to manage the school portal",
                            style: TextStyle(color: Colors.grey[600], fontSize: 14),
                          ),
                          const SizedBox(height: 32),

                          // Error message
                          if (_errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),

                          // Email field
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: "Email",
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Password field
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: const Icon(Icons.lock_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Forgot password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Forgot password feature coming soon")),
                                );
                              },
                              child: const Text(
                                "Forgot password?",
                                style: TextStyle(color: Colors.indigo),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Login button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 3,
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : const Text(
                                      "Login",
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}