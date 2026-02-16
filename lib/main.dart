import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:school_poc/screens/admin_dashboard_screen.dart';
import 'package:school_poc/screens/admin_login_screen.dart';
import 'package:school_poc/services/tts_native_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:just_audio/just_audio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const TeacherApp());
}

class TeacherApp extends StatelessWidget {
  const TeacherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Teacher Portal',
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 94, 222, 245)),
        useMaterial3: true,
        cardTheme:  CardThemeData(
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

// ────────────────────────────────────────────────
//                  LOGIN SCREEN
// ────────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;

  final _teachers = {
    'teacher1': {'pass': '1234', 'name': 'Mr. Rajesh Kumar'},
    'teacher2': {'pass': '5678', 'name': 'Ms. Priya Sharma'},
  };

  void _login() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 900));

    final user = _usernameCtrl.text.trim();
    final pass = _passwordCtrl.text.trim();

    if (_teachers.containsKey(user) && _teachers[user]!['pass'] == pass) {
      final name = _teachers[user]!['name']!;
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(teacherName: name)),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid username or password')),
        );
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[900]!, Colors.blue[400]!],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // i want to add logo and name anbove the card
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/logo.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'MG Public School',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Card(
                    elevation: 12,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.school_rounded, size: 68, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(height: 24),
                          const Text('Teacher Login', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 32),
                          TextField(
                            controller: _usernameCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _passwordCtrl,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton.icon(
                              icon: _loading
                                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                                  : const Icon(Icons.login),
                              label: Text(_loading ? 'Signing in...' : 'Login'),
                              onPressed: _loading ? null : _login,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Divider(height: 40),
                        //  RichText(text: TextSpan(    //dont have account create one
                        //     text: "Don't have an account? ",
                        //     style: TextStyle(color: Colors.black54),
                        //     children: [
                        //       TextSpan(
                        //         text: 'Contact Admin',
                        //         style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        //       ),
                        //     ],
                        //   )),
ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
    );
  },
  child: const Text("Login as Admin"),
)
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

// ────────────────────────────────────────────────
//                  HOME SCREEN
// ────────────────────────────────────────────────
class HomeScreen extends StatelessWidget {
  final String teacherName;

  const HomeScreen({super.key, required this.teacherName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          child: Column(
            children: [
              DashboardHeader(teacherName: teacherName),
              // logout button
            //         Row
            // (
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.only(right: 16, top: 8),
            //       child: ElevatedButton.icon(
            //         icon: const Icon(Icons.logout),
            //         label: const Text('Logout'),
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: Colors.red,
            //         ),
            //         onPressed: () {
            //           Navigator.pushReplacement(
            //             context,
            //             MaterialPageRoute(builder: (_) => const LoginScreen()),
            //           );
            //         },
            //       ),
            //     ),
            //   ],
            // ),
              const SizedBox(height: 16),
              const TodaySchedule(),
              const SizedBox(height: 24),
              const QuickActions(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardHeader extends StatelessWidget {
  final String teacherName;

  const DashboardHeader({super.key, required this.teacherName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6A5AE0), Color(0xFF8E7BFF)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 30),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teacherName,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const Text(
                    'Mathematics Teacher',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.notifications, color: Colors.white),
            ],
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InfoTile(title: 'Today', value: 'Monday'),
              InfoTile(title: 'Classes', value: '5'),
              InfoTile(title: 'Periods', value: '6'),
            ],
          ),
        ],
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final String title;
  final String value;

  const InfoTile({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class TodaySchedule extends StatelessWidget {
  const TodaySchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text("Today's Schedule", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Spacer(),
              Text('View All', style: TextStyle(color: Colors.blue)),
            ],
          ),
          const SizedBox(height: 12),
          _scheduleCard(Colors.blue, 'Mathematics', '08:00 - 09:00', '10-A'),
          _scheduleCard(Colors.green, 'Algebra', '09:15 - 10:15', '9-B'),
          _scheduleCard(Colors.purple, 'Statistics', '11:00 - 12:00', '11-C'),
          _scheduleCard(Colors.orange, 'Lunch Break', '12:00 - 01:00', ''),
          _scheduleCard(Colors.pink, 'Calculus', '01:00 - 02:00', '12-A'),
        ],
      ),
    );
  }

  Widget _scheduleCard(Color color, String subject, String time, String cls) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(blurRadius: 10, color: color.withOpacity(0.15))],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.book, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(subject, style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
              Text(
                cls.isEmpty ? time : 'Class $cls ',
                style: const TextStyle(color: Colors.grey),
              ),
              Text(cls.isEmpty ? '' : 'Time: $time', style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Quick Actions", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.05,
            children: [
              _ActionTile(
                title: "Attendance",
                icon: Icons.person,
                color: const Color(0xFF3F51B5),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendanceScreen())),
              ),
              _ActionTile(
                title: "Announcements",
                icon: Icons.message,
                color: const Color(0xFFFF9700),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnnouncementScreen())),
              ),
              _ActionTile(title: "HomeWork", icon: Icons.book, color: const Color(0xFF9C28B1),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TeacherHomeworkScreen())),),
              _ActionTile(title: "Grades", icon: Icons.star_border, color: const Color(0xFF4CB050),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TeacherGradesScreen())),),
              
              _ActionTile(title: "Assignments", icon: Icons.assignment_rounded, color: const Color(0xFFE91E63)),
              _ActionTile(title: "Admin", icon: Icons.admin_panel_settings, color: const Color(0xFF607D8B),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDashboardScreen())),),
                // Fees remaining
              _ActionTile(title: "Fees Remaining", icon: Icons.money_off_csred, color: const Color(0xFF009688), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FeesRemainingScreen())),),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _ActionTile({
    required this.title,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────
//               ATTENDANCE SCREEN
// ────────────────────────────────────────────────
class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String? selectedClass;
  String? selectedSubject;
  List<Map<String, dynamic>> students = [];
  Map<String, int> report = {};

  final Map<String, List<Map<String, dynamic>>> classStudents = {
    '10-A': [
      {'roll': 1, 'name': 'Aarav', 'gender': 'Boy', 'present': true},
      {'roll': 2, 'name': 'Ananya', 'gender': 'Girl', 'present': true},
      {'roll': 3, 'name': 'Rohan', 'gender': 'Boy', 'present': true},
      {'roll': 4, 'name': 'Priya', 'gender': 'Girl', 'present': true},
      {'roll': 5, 'name': 'Vikram', 'gender': 'Boy', 'present': true},
         {'roll': 6, 'name': 'Sneha', 'gender': 'Girl', 'present': true},
      {'roll': 7, 'name': 'Arjun', 'gender': 'Boy', 'present': true},
      {'roll': 8, 'name': 'Meera', 'gender': 'Girl', 'present': true},
      {'roll': 9, 'name': 'Riya', 'gender': 'Girl', 'present': true},
      {'roll': 10, 'name': 'Kabir', 'gender': 'Boy', 'present': true},
      
      {'roll': 11, 'name': 'Karan', 'gender': 'Boy', 'present': true},
      {'roll': 12, 'name': 'Kavya', 'gender': 'Girl', 'present': true},
      {'roll': 13, 'name': 'Abhishek', 'gender': 'Boy', 'present': true},
      {'roll': 14, 'name': 'Riya', 'gender': 'Girl', 'present': true},
      {'roll': 15, 'name': 'Rahul', 'gender': 'Boy', 'present': true},
         {'roll': 16, 'name': 'Neha', 'gender': 'Girl', 'present': true},
      {'roll': 17, 'name': 'Arjun', 'gender': 'Boy', 'present': true},
      {'roll': 18, 'name': 'Meera', 'gender': 'Girl', 'present': true},
      {'roll': 19, 'name': 'Riya', 'gender': 'Girl', 'present': true},
      {'roll': 20, 'name': 'Kabir', 'gender': 'Boy', 'present': true},
      
    ],
    '9-B': [
      {'roll': 1, 'name': 'Sneha', 'gender': 'Girl', 'present': true},
      {'roll': 2, 'name': 'Arjun', 'gender': 'Boy', 'present': true},
      {'roll': 3, 'name': 'Meera', 'gender': 'Girl', 'present': true},
    ],
  };

  final List<String> subjects = ['Mathematics', 'Science', 'English', 'Social Science'];

  Future<void> _generateReport() async {
    int present = students.where((s) => s['present']).length;
    int absent = students.length - present;
    int boysPresent = students.where((s) => s['gender'] == 'Boy' && s['present']).length;
    int boysAbsent = students.where((s) => s['gender'] == 'Boy' && !s['present']).length;
    int girlsPresent = students.where((s) => s['gender'] == 'Girl' && s['present']).length;
    int girlsAbsent = students.where((s) => s['gender'] == 'Girl' && !s['present']).length;

    setState(() {
      report = {
        'present': present,
        'absent': absent,
        'boysPresent': boysPresent,
        'boysAbsent': boysAbsent,
        'girlsPresent': girlsPresent,
        'girlsAbsent': girlsAbsent,
      };
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Attendance Report', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Class: $selectedClass  •  Subject: $selectedSubject'),
              const SizedBox(height: 16),
              Text('Total: ${students.length}   Present: ${report['present']}   Absent: ${report['absent']}'),
              Text('Boys: ${report['boysPresent']} present • ${report['boysAbsent']} absent'),
              Text('Girls: ${report['girlsPresent']} present • ${report['girlsAbsent']} absent'),
              const SizedBox(height: 24),
              SizedBox(
                height: 220,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: report['present']!.toDouble(),
                        color: Colors.green,
                        title: 'Present\n${report['present']}',
                        radius: 80,
                        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      PieChartSectionData(
                        value: report['absent']!.toDouble(),
                        color: Colors.red,
                        title: 'Absent\n${report['absent']}',
                        radius: 80,
                        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                    centerSpaceRadius: 40,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
   try {
    await FirebaseFirestore.instance.collection('attendance_reports').add({
      'class': selectedClass,
      'subject': selectedSubject,
      'date': DateTime.now().toString().substring(0, 10),
      'timestamp': FieldValue.serverTimestamp(),
      'total': students.length,
      'present': report['present'],
      'absent': report['absent'],
      'boysPresent': report['boysPresent'],
      'boysAbsent': report['boysAbsent'],
      'girlsPresent': report['girlsPresent'],
      'girlsAbsent': report['girlsAbsent'],
      // optional: 'teacher': current teacher name
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Report saved to admin panel")),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to save report: $e")),
    );
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance'),
      backgroundColor: Colors.blue[900],
      foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Select Class', prefixIcon: Icon(Icons.class_),border: OutlineInputBorder(),),
              value: selectedClass,
              items: classStudents.keys.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) {
                setState(() {
                  selectedClass = val;
                  students = List.from(classStudents[val] ?? []);
                });
              },
            ),
            const SizedBox(height: 16),
             DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Select Subject', prefixIcon: Icon(Icons.book),border: OutlineInputBorder(),),
              value: selectedSubject,
              items: subjects.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) => setState(() => selectedSubject = val),
            ),
            const SizedBox(height: 20),
            Text("Student List", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
      

           
            if (students.isNotEmpty)
             
              Expanded(
                
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: students.length,
                  itemBuilder: (context, i) {
                    final s = students[i];
                    return Card(
                      child: ListTile(
                        
                        leading: CircleAvatar(
                          child: Text(s['name'][0]),
                          backgroundColor: s['gender'] == 'Boy' ? Colors.blue[200] : Colors.pink[200],
                        ),
                        title: Text('${s['roll']}. ${s['name']} '),
                        trailing: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    GestureDetector(
      onTap: () {
        setState(() {
          s['present'] = true;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: s['present'] ? Colors.green : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          "P",
          style: TextStyle(
            color: s['present'] ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
    const SizedBox(width: 8),
    GestureDetector(
      onTap: () {
        setState(() {
          s['present'] = false;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: !s['present'] ? Colors.red : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          "A",
          style: TextStyle(
            color: !s['present'] ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  ],
),

                        
                      ),
                    );
                  },
                ),
              ),
              
            if (selectedClass != null && selectedSubject != null && students.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  label: const Text('Generate Report'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: 
Colors.white, 
                  ),
                  onPressed: _generateReport,
                ),
              ),

          ],
          
        ),
      ),
    );
  }
}
//Homework screen

class TeacherHomeworkScreen extends StatefulWidget {
  const TeacherHomeworkScreen({super.key});

  @override
  State<TeacherHomeworkScreen> createState() =>
      _TeacherHomeworkScreenState();
}

class _TeacherHomeworkScreenState
    extends State<TeacherHomeworkScreen> {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final List<String> classes = ["8", "9", "10"];
  final List<String> subjects = ["Math", "Science", "English"];

  String? selectedClass;
  String? selectedSubject;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  String? editingId; // for edit mode

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Homework"),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditSheet(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection("homework")
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
                child: Text("No Homework Added"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data =
                  docs[index].data() as Map<String, dynamic>;
              final id = docs[index].id;

              return _buildHomeworkCard(data, id);
            },
          );
        },
      ),
    );
  }

  Widget _buildHomeworkCard(
      Map<String, dynamic> hw, String id) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "${hw['subject']} • Class ${hw['class']}",
              style: const TextStyle(
                  fontWeight: FontWeight.bold)),

          const SizedBox(height: 8),

          Text(hw['title'],
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),

          const SizedBox(height: 6),
          Text(hw['description']),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.edit,
                    color: Colors.blue),
                onPressed: () {
                  editingId = id;
                  selectedClass = hw['class'];
                  selectedSubject = hw['subject'];
                  titleController.text =
                      hw['title'];
                  descriptionController.text =
                      hw['description'];

                  _showAddEditSheet();
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete,
                    color: Colors.red),
                onPressed: () {
                  _firestore
                      .collection("homework")
                      .doc(id)
                      .delete();
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showAddEditSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom:
                  MediaQuery.of(context)
                      .viewInsets
                      .bottom,
              left: 16,
              right: 16,
              top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Text(
                  editingId == null
                      ? "Add Homework"
                      : "Edit Homework",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),

              const SizedBox(height: 16),

              DropdownButtonFormField(
                value: selectedClass,
                hint: const Text("Select Class"),
                items: classes
                    .map((c) =>
                        DropdownMenuItem(
                            value: c,
                            child:
                                Text("Class $c")))
                    .toList(),
                onChanged: (val) =>
                    selectedClass =
                        val.toString(),
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField(
                value: selectedSubject,
                hint: const Text("Select Subject"),
                items: subjects
                    .map((s) =>
                        DropdownMenuItem(
                            value: s,
                            child: Text(s)))
                    .toList(),
                onChanged: (val) =>
                    selectedSubject =
                        val.toString(),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: titleController,
                decoration:
                    const InputDecoration(
                        labelText: "Title"),
              ),

              const SizedBox(height: 12),

              TextField(
                controller:
                    descriptionController,
                decoration:
                    const InputDecoration(
                        labelText:
                            "Description"),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _saveHomework,
                child: const Text("Save"),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveHomework() async {
    if (editingId == null) {
      await _firestore.collection("homework").add({
        "class": selectedClass,
        "subject": selectedSubject,
        "title": titleController.text,
        "description":
            descriptionController.text,
        "createdAt":
            FieldValue.serverTimestamp(),
      });
    } else {
      await _firestore
          .collection("homework")
          .doc(editingId)
          .update({
        "class": selectedClass,
        "subject": selectedSubject,
        "title": titleController.text,
        "description":
            descriptionController.text,
      });

      editingId = null;
    }

    // 🔥 CLEAR FIELDS
    titleController.clear();
    descriptionController.clear();
    selectedClass = null;
    selectedSubject = null;

    Navigator.pop(context);
  }
}



//Grades screen

class TeacherGradesScreen extends StatefulWidget {
  const TeacherGradesScreen({super.key});

  @override
  State<TeacherGradesScreen> createState() =>
      _TeacherGradesScreenState();
}

class _TeacherGradesScreenState
    extends State<TeacherGradesScreen> {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final List<String> classes = ["8", "9", "10"];
  final List<String> students = [
    "Aarav",
    "Ananya",
    "Rohan"
  ];
  final List<String> subjects = [
    "Math",
    "Science",
    "English"
  ];
  final List<String> exams = [
    "Unit Test",
    "Midterm",
    "Final"
  ];

  String? selectedClass;
  String? selectedStudent;
  String? selectedSubject;
  String? selectedExam;

  final marksController = TextEditingController();
  final totalController =
      TextEditingController(text: "100");

  String? editingId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Manage Grades"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () => _showAddEditSheet(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection("grades")
            .orderBy("createdAt",
                descending: true)
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
                child:
                    CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
                child:
                    Text("No Grades Added"));
          }

          return ListView.builder(
            padding:
                const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data =
                  docs[index].data()
                      as Map<String, dynamic>;
              final id = docs[index].id;

              return _buildGradeCard(
                  data, id);
            },
          );
        },
      ),
    );
  }

  Widget _buildGradeCard(
      Map<String, dynamic> g,
      String id) {

    double percentage =
        (g['marks'] / g['total']) * 100;

    Color color;
    String performance;

    if (percentage >= 80) {
      color = Colors.green;
      performance = "Excellent";
    } else if (percentage >= 60) {
      color = Colors.orange;
      performance = "Good";
    } else {
      color = Colors.red;
      performance =
          "Needs Improvement";
    }

    return Container(
      margin:
          const EdgeInsets.only(bottom: 16),
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black
                  .withOpacity(0.05),
              blurRadius: 6)
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          Text(
              "${g['student']} • Class ${g['class']}",
              style:
                  const TextStyle(
                      fontWeight:
                          FontWeight.bold)),

          const SizedBox(height: 8),

          Text(
              "${g['subject']} - ${g['examType']}"),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
            children: [
              Text(
                  "Marks: ${g['marks']} / ${g['total']}"),
              Text(
                  "${percentage.toStringAsFixed(1)}%"),
            ],
          ),

          const SizedBox(height: 10),

          Container(
            padding:
                const EdgeInsets
                    .symmetric(
                        horizontal: 12,
                        vertical: 6),
            decoration:
                BoxDecoration(
              color: color,
              borderRadius:
                  BorderRadius.circular(
                      20),
            ),
            child: Text(
              performance,
              style:
                  const TextStyle(
                      color:
                          Colors.white),
            ),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(
                    Icons.edit,
                    color:
                        Colors.blue),
                onPressed: () {
                  editingId = id;
                  selectedClass =
                      g['class'];
                  selectedStudent =
                      g['student'];
                  selectedSubject =
                      g['subject'];
                  selectedExam =
                      g['examType'];
                  marksController.text =
                      g['marks']
                          .toString();
                  totalController.text =
                      g['total']
                          .toString();

                  _showAddEditSheet();
                },
              ),
              IconButton(
                icon: const Icon(
                    Icons.delete,
                    color: Colors.red),
                onPressed: () {
                  _firestore
                      .collection(
                          "grades")
                      .doc(id)
                      .delete();
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showAddEditSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
              bottom:
                  MediaQuery.of(context)
                      .viewInsets
                      .bottom,
              left: 16,
              right: 16,
              top: 16),
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [

              Text(
                  editingId == null
                      ? "Add Grade"
                      : "Edit Grade",
                  style:
                      const TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight
                                  .bold)),

              const SizedBox(height: 16),

              DropdownButtonFormField(
                value: selectedClass,
                hint:
                    const Text("Class"),
                items: classes
                    .map((c) =>
                        DropdownMenuItem(
                            value: c,
                            child: Text(
                                "Class $c")))
                    .toList(),
                onChanged: (val) =>
                    selectedClass =
                        val.toString(),
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField(
                value:
                    selectedStudent,
                hint: const Text(
                    "Student"),
                items: students
                    .map((s) =>
                        DropdownMenuItem(
                            value: s,
                            child:
                                Text(s)))
                    .toList(),
                onChanged: (val) =>
                    selectedStudent =
                        val.toString(),
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField(
                value:
                    selectedSubject,
                hint:
                    const Text("Subject"),
                items: subjects
                    .map((s) =>
                        DropdownMenuItem(
                            value: s,
                            child:
                                Text(s)))
                    .toList(),
                onChanged: (val) =>
                    selectedSubject =
                        val.toString(),
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField(
                value: selectedExam,
                hint:
                    const Text("Exam"),
                items: exams
                    .map((e) =>
                        DropdownMenuItem(
                            value: e,
                            child:
                                Text(e)))
                    .toList(),
                onChanged: (val) =>
                    selectedExam =
                        val.toString(),
              ),

              const SizedBox(height: 12),

              TextField(
                controller:
                    marksController,
                keyboardType:
                    TextInputType
                        .number,
                decoration:
                    const InputDecoration(
                        labelText:
                            "Marks"),
              ),

              const SizedBox(height: 12),

              TextField(
                controller:
                    totalController,
                keyboardType:
                    TextInputType
                        .number,
                decoration:
                    const InputDecoration(
                        labelText:
                            "Total Marks"),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed:
                    _saveGrade,
                child:
                    const Text("Save"),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
Future<void> _saveGrade() async {

  final marks = int.tryParse(marksController.text) ?? 0;
  final total = int.tryParse(totalController.text) ?? 100;


  final existing = await _firestore
      .collection("grades")
      .where("class", isEqualTo: selectedClass)
      .where("student", isEqualTo: selectedStudent)
      .where("subject", isEqualTo: selectedSubject)
      .where("examType", isEqualTo: selectedExam)
      .get();

  if (editingId == null && existing.docs.isNotEmpty) {
   
    ScaffoldMessenger.of(context).showMaterialBanner(
  MaterialBanner(
    content: const Text("Grade already exists"),
    backgroundColor: Colors.red,
    actions: [
      TextButton(
        onPressed: () {
          ScaffoldMessenger.of(context)
              .hideCurrentMaterialBanner();
        },
        child: const Text("DISMISS", style: TextStyle(color: Colors.white)),
      )
    ],
  ),
);

 
    return;
  }

  if (editingId == null) {

    await _firestore.collection("grades").add({
      "class": selectedClass,
      "student": selectedStudent,
      "subject": selectedSubject,
      "examType": selectedExam,
      "marks": marks,
      "total": total,
      "createdAt": FieldValue.serverTimestamp(),
    });
  } else {
  
    await _firestore
        .collection("grades")
        .doc(editingId)
        .update({
      "class": selectedClass,
      "student": selectedStudent,
      "subject": selectedSubject,
      "examType": selectedExam,
      "marks": marks,
      "total": total,
    });

    editingId = null;
  }

 
  marksController.clear();
  totalController.text = "100";
  selectedClass = null;
  selectedStudent = null;
  selectedSubject = null;
  selectedExam = null;

  Navigator.pop(context);

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Grade Saved Successfully"),
      backgroundColor: Colors.green,
    ),
  );
}
}
//Annoucement Screen

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({super.key});

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  final _textController = TextEditingController();
  final _audioPlayer = AudioPlayer(); // just_audio

  String? _audioPath;
  bool _generating = false;
  bool _ready = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  void _initPlayer() {
    _audioPlayer.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;
      });
      if (state.processingState == ProcessingState.completed) {
        setState(() => _isPlaying = false);
      }
    });
  }

  Future<void> _generateAudio() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter text first")));
      return;
    }

    setState(() {
      _generating = true;
      _ready = false;
    });

    try {
      final savedPath = await TtsNativeService.synthesizeAndSave(text: text);

      if (savedPath != null && File(savedPath).existsSync()) {
        setState(() {
          _audioPath = savedPath;
          _ready = true;
          _generating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Audio saved: ${savedPath.split('/').last}")),
        );
      } else {
        throw Exception("Audio file not created");
      }
    } catch (e) {
      print("Generation failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to generate audio: $e")),
      );
      setState(() => _generating = false);
    }
  }

  Future<void> _playAudio() async {
    if (_audioPath == null || !_ready) return;

    try {
      await _audioPlayer.setFilePath(_audioPath!);
      await _audioPlayer.play();
      setState(() => _isPlaying = true);
    } catch (e) {
      print("Play error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Playback failed: $e")));
    }
  }

  Future<void> _stopAudio() async {
    await _audioPlayer.stop();
    setState(() => _isPlaying = false);
  }

  Future<void> _shareAudio() async {
    if (_audioPath == null || !_ready) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No audio to share")));
      return;
    }

    final file = File(_audioPath!);
    if (!await file.exists()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Audio file missing")));
      return;
    }

    try {
      await Share.shareXFiles(
        [XFile(_audioPath!, mimeType: 'audio/wav')],
        text: "📢 School Announcement\n\n${_textController.text}",
        subject: "School Announcement Audio",
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Share failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Announcements"),
      backgroundColor: Colors.blue[900],
      foregroundColor: Colors.white,),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height:20),
              const Text(
                "Enter the announcement.",
                style: TextStyle(fontSize: 24, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _textController,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: "Announcement text",
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),
              Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      // backgroundColor: _generating ? Colors.grey : Theme.of(context).colorScheme.primary,
                    ),
                    icon: _generating
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2.4))
                        : const Icon(Icons.record_voice_over),
                    label: Text(_generating ? "Generating..." : "Generate Audio"),
                    onPressed: _generating ? null : _generateAudio,
                  ),
                    const SizedBox(height: 12),
                  ElevatedButton.icon(
        
                    icon: const Icon(Icons.share),
                    label: const Text("Share"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      backgroundColor: Colors.green[700], foregroundColor: Colors.white),
                    onPressed: _shareAudio,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              if (_ready)
                Card(
                  color: Colors.green[50],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Icon(
                      _isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                      color: Colors.green,
                      size: 40,
                    ),
                    title: Text(_isPlaying ? "Playing..." : "Play generated audio"),
                    subtitle: Text(_audioPath!.split('/').last, maxLines: 1, overflow: TextOverflow.ellipsis),
                    onTap: _isPlaying ? _stopAudio : _playAudio,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }
}

class FeesRemainingScreen extends StatefulWidget {
  const FeesRemainingScreen({super.key});

  @override
  State<FeesRemainingScreen> createState() => _FeesRemainingScreenState();
}

class _FeesRemainingScreenState extends State<FeesRemainingScreen> {
  String? selectedClass;
  String? selectedDivision;
  String searchQuery = "";

  static final List<Map<String, dynamic>> allStudents = [
    {'class': '10', 'division': 'A', 'roll': '01', 'name': 'Aarav Sharma', 'total': 48000, 'paid': 32000, 'pending': 16000},
    {'class': '10', 'division': 'A', 'roll': '02', 'name': 'Ananya Patil', 'total': 48000, 'paid': 48000, 'pending': 0},
    {'class': '10', 'division': 'B', 'roll': '01', 'name': 'Rohan Gupta', 'total': 48000, 'paid': 20000, 'pending': 28000},
    {'class': '9', 'division': 'A', 'roll': '01', 'name': 'Sneha Deshmukh', 'total': 45000, 'paid': 45000, 'pending': 0},
    {'class': '8', 'division': 'A', 'roll': '01', 'name': 'Vihaan Rao', 'total': 42000, 'paid': 10000, 'pending': 32000},
  ];

 
  int get totalPaid =>
      allStudents.fold(0, (sum, s) => sum + (s['paid'] as int));

  int get totalPending =>
      allStudents.fold(0, (sum, s) => sum + (s['pending'] as int));

  List<String> get availableClasses {
    final set = <String>{};
    for (var s in allStudents) {
      set.add(s['class']);
    }
    return set.toList()..sort();
  }

  List<String> get availableDivisions {
    if (selectedClass == null) return [];
    final set = <String>{};
    for (var s in allStudents) {
      if (s['class'] == selectedClass) {
        set.add(s['division']);
      }
    }
    return set.toList()..sort();
  }

  List<Map<String, dynamic>> get filteredStudents {
    return allStudents.where((s) {
      bool match = true;
      if (selectedClass != null) {
        match = match && s['class'] == selectedClass;
      }
      if (selectedDivision != null) {
        match = match && s['division'] == selectedDivision;
      }
      if (searchQuery.isNotEmpty) {
        match = match &&
            s['name']
                .toLowerCase()
                .contains(searchQuery.toLowerCase());
      }
      return match;
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Fees Details"),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

           
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "Search Student Name",
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_alt_outlined),
                    onPressed: _showFilterBottomSheet,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

         
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    "Total Paid",
                    totalPaid,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    "Total Pending",
                    totalPending,
                    Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (filteredStudents.isEmpty)
              const Padding(
                padding: EdgeInsets.all(40),
                child: Text(
                  "No Students Found",
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: filteredStudents.length,
                itemBuilder: (context, index) {
                  final student = filteredStudents[index];
                  return _buildStudentCard(student);
                },
              ),
          ],
        ),
      ),
    );
  }

 

  Widget _buildSummaryCard(String title, int amount, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color)),
          const SizedBox(height: 8),
          Text(
            "₹$amount",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student) {
    final pending = student['pending'] as int;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text("Name: ${student['name']}",
              style: const TextStyle(fontWeight: FontWeight.bold)),

          const SizedBox(height: 6),

          Text(
              "Class: ${student['class']} - ${student['division']}    Roll: ${student['roll']}"),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _feeColumn("Total Fees", student['total'], Colors.black),
              _feeColumn("Pending Fees", student['pending'],
                  pending == 0 ? Colors.green : Colors.red),
              _feeColumn("Paid Fees", student['paid'], Colors.green),
            ],
          ),

          const SizedBox(height: 16),

          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => _shareFeesReport(student),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Share in Whats App",
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600)),
                  SizedBox(width: 6),
                  Icon(Icons.share, size: 18, color: Colors.blue),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _feeColumn(String title, int amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text("₹$amount",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }


  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text("Filter",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),

              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: selectedClass,
                hint: const Text("Select Class"),
                items: availableClasses
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text("Class $c"),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedClass = value;
                    selectedDivision = null;
                  });
                },
              ),

              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: selectedDivision,
                hint: const Text("Select Division"),
                items: availableDivisions
                    .map((d) => DropdownMenuItem(
                          value: d,
                          child: Text("Div $d"),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDivision = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedClass = null;
                        selectedDivision = null;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("Clear all"),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Show Results"),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

 

  void _shareFeesReport(Map<String, dynamic> student) {
    Share.share("""
Dear Parent,

Fees Status Update:

Student: ${student['name']}
Class: ${student['class']} - ${student['division']}
Roll No: ${student['roll']}

Total Fees: ₹${student['total']}
Paid: ₹${student['paid']}
Pending: ₹${student['pending']}

Please clear the pending fees at the earliest to avoid any inconvenience.
Contact the school office for payment options or queries.

Thank you,
MG Public School Administration
""");
  }
}
