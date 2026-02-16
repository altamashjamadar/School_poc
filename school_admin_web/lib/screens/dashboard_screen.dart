// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   int _selectedIndex = 0;

//   static const List<String> _titles = [
//     'Overview',
//     'Teachers',
//     'Students',
//     'Fees',
//     'Attendance',
//     'Announcements',
//   ];

//   final List<Widget> _screens = [
//     const OverviewTab(),
//     const TeachersTab(),
//     const StudentsTab(),
//     const FeesTab(),
//     const AttendanceTab(),
//     const AnnouncementsTab(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     final isWide = MediaQuery.of(context).size.width > 900;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_titles[_selectedIndex]),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () async {
//               await FirebaseAuth.instance.signOut();
//               Navigator.pushReplacementNamed(context, '/');
//             },
//           ),
//         ],
//       ),
//       body: Row(
//         children: [
//           NavigationRail(
//             extended: isWide,
//             selectedIndex: _selectedIndex,
//             onDestinationSelected: (index) => setState(() => _selectedIndex = index),
//             destinations: const [
//               NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text("Overview")),
//               NavigationRailDestination(icon: Icon(Icons.people), label: Text("Teachers")),
//               NavigationRailDestination(icon: Icon(Icons.school), label: Text("Students")),
//               NavigationRailDestination(icon: Icon(Icons.payments), label: Text("Fees")),
//               NavigationRailDestination(icon: Icon(Icons.assessment), label: Text("Attendance")),
//               NavigationRailDestination(icon: Icon(Icons.campaign), label: Text("Announcements")),
//             ],
//           ),
//           Expanded(child: _screens[_selectedIndex]),
//         ],
//       ),
//     );
//   }
// }

// // Placeholder tabs (implement each as needed)
// class OverviewTab extends StatelessWidget {
//   const OverviewTab({super.key});
//   @override
//   Widget build(BuildContext context) => const Center(child: Text("Summary Stats & Charts"));
// }

// class TeachersTab extends StatelessWidget {
//   const TeachersTab({super.key});
//   @override
//   Widget build(BuildContext context) => const Center(child: Text("List & Add Teachers"));
// }

// class StudentsTab extends StatelessWidget {
//   const StudentsTab({super.key});
//   @override
//   Widget build(BuildContext context) => const Center(child: Text("Manage Students + Excel Upload"));
// }

// class FeesTab extends StatelessWidget {
//   const FeesTab({super.key});
//   @override
//   Widget build(BuildContext context) => const Center(child: Text("Pending Fees & Payments"));
// }

// class AttendanceTab extends StatelessWidget {
//   const AttendanceTab({super.key});
//   @override
//   Widget build(BuildContext context) => const Center(child: Text("All Attendance Reports"));
// }

// class AnnouncementsTab extends StatelessWidget {
//   const AnnouncementsTab({super.key});
//   @override
//   Widget build(BuildContext context) => const Center(child: Text("Create & View Announcements"));
// }



import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:school_admin_web/screens/add_teacher_screen.dart';
import 'package:school_admin_web/screens/manage_students_screen.dart';
import 'package:school_admin_web/screens/manage_fees_screen.dart';
import 'package:school_admin_web/screens/announcements_screen.dart';
import 'package:school_admin_web/screens/attendance_reports_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  static const List<String> _titles = [
    'Overview',
    'Teachers',
    'Students',
    'Fees',
    'Attendance Reports',
    'Announcements',
  ];

  final List<Widget> _screens = [
    const OverviewTab(),
    const AddTeacherScreen(),
    const ManageStudentsScreen(),
    const ManageFeesScreen(),
    const AttendanceReportsScreen(),
    const AnnouncementsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            extended: isWide,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) => setState(() => _selectedIndex = index),
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text("Overview")),
              NavigationRailDestination(icon: Icon(Icons.person_add), label: Text("Teachers")),
              NavigationRailDestination(icon: Icon(Icons.school), label: Text("Students")),
              NavigationRailDestination(icon: Icon(Icons.payments), label: Text("Fees")),
              NavigationRailDestination(icon: Icon(Icons.assessment), label: Text("Attendance")),
              NavigationRailDestination(icon: Icon(Icons.campaign), label: Text("Announcements")),
            ],
          ),
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),
    );
  }
}

class OverviewTab extends StatelessWidget {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.security, size: 120, color: Colors.indigo),
          const SizedBox(height: 24),
          const Text(
            "Administrator Control Center",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Text("Full access to manage teachers, students, fees, attendance, and announcements"),
        ],
      ),
    );
  }
}