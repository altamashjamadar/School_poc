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
              _ActionTile(title: "HomeWork", icon: Icons.book, color: const Color(0xFF9C28B1)),
              _ActionTile(title: "Grades", icon: Icons.star_border, color: const Color(0xFF4CB050)),
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
            // Text("Select Your Class.", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
            // Text("Select Subject.", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            // const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Select Subject', prefixIcon: Icon(Icons.book),border: OutlineInputBorder(),),
              value: selectedSubject,
              items: subjects.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) => setState(() => selectedSubject = val),
            ),
            const SizedBox(height: 20),
            Text("Student List", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            // i want to show all students in a c big card 

           
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
                        trailing: Switch(
                          value: s['present'],
                          onChanged: (v) => setState(() => s['present'] = v),
                          activeColor: Colors.green,
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
              // a clear button to clear the text field
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: TextButton.icon(
              //     icon: const Icon(Icons.clear),
              //     label: const Text("Clear"),
              //     onPressed: () {
              //       _textController.clear();
              //       setState(() {
              //         // _audioPath = null;
              //         // _ready = false;
              //       });
              //     },
              //   ),
              // ),
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

  // Static data - will be replaced with Firebase later
  static final List<Map<String, dynamic>> allStudents = [
    // Class 10
    {'class': '10', 'division': 'A', 'roll': '01', 'name': 'Aarav Sharma', 'total': 48000, 'paid': 32000, 'pending': 16000},
    {'class': '10', 'division': 'A', 'roll': '02', 'name': 'Ananya Patil', 'total': 48000, 'paid': 48000, 'pending': 0},
    { 'class': '10', 'division': 'A', 'roll': '03', 'name': 'Vikram Singh', 'total': 48000, 'paid': 24000, 'pending': 24000},
    {'class': '10', 'division': 'A', 'roll': '04', 'name': 'Sneha Deshmukh', 'total': 48000, 'paid': 48000, 'pending': 0},
    {'class': '10', 'division': 'A', 'roll': '05', 'name': 'Arjun Jadhav', 'total': 48000, 'paid': 16000, 'pending': 32000},
    {'class': '10', 'division': 'A', 'roll': '06', 'name': 'Meera Kulkarni', 'total': 48000, 'paid': 40000, 'pending': 8000},
    {'class': '10', 'division': 'A', 'roll': '07', 'name': 'Riya Kapoor', 'total': 48000, 'paid': 48000, 'pending': 0},
    {'class': '10', 'division': 'A', 'roll': '08', 'name': 'Kabir Verma', 'total': 48000, 'paid': 20000, 'pending': 28000 },
    {'class': '10', 'division': 'A', 'roll': '09', 'name': 'Karan Mehta', 'total': 48000, 'paid': 48000, 'pending': 0},
    {'class': '10', 'division': 'A', 'roll': '10', 'name': 'Kavya Joshi', 'total': 48000, 'paid': 36000, 'pending': 12000},
    {'class': '10', 'division': 'B', 'roll': '01', 'name': 'Rohan Gupta', 'total': 48000, 'paid': 20000, 'pending': 28000},
    {'class': '10', 'division': 'B', 'roll': '02', 'name': 'Priya Singh', 'total': 48000, 'paid': 40000, 'pending': 8000},

    // Class 9
    {'class': '9', 'division': 'A', 'roll': '01', 'name': 'Sneha Deshmukh', 'total': 45000, 'paid': 45000, 'pending': 0},
    {'class': '9', 'division': 'B', 'roll': '01', 'name': 'Arjun Jadhav', 'total': 45000, 'paid': 15000, 'pending': 30000},
    {'class': '9', 'division': 'B', 'roll': '02', 'name': 'Meera Kulkarni', 'total': 45000, 'paid': 30000, 'pending': 15000},

    // Class 8
    {'class': '8', 'division': 'A', 'roll': '01', 'name': 'Vihaan Rao', 'total': 42000, 'paid': 42000, 'pending': 0},
    {'class': '8', 'division': 'A', 'roll': '02', 'name': 'Diya Nair', 'total': 42000, 'paid': 10000, 'pending': 32000},
  ];

  // Computed totals
  int get totalPaid => allStudents.fold(0, (sum, s) => sum + (s['paid'] as int));
  int get totalPending => allStudents.fold(0, (sum, s) => sum + (s['pending'] as int));

  // Available classes
  List<String> get availableClasses {
    final set = <String>{};
    for (var s in allStudents) set.add(s['class'] as String);
    return set.toList()..sort();
  }

  // Available divisions for selected class
  List<String> get availableDivisions {
    if (selectedClass == null) return [];
    final set = <String>{};
    for (var s in allStudents) {
      if (s['class'] == selectedClass) set.add(s['division'] as String);
    }
    return set.toList()..sort();
  }

  // Filtered students for selected class + division
  List<Map<String, dynamic>> get filteredStudents {
    return allStudents.where((s) {
      bool match = true;
      if (selectedClass != null) match = match && s['class'] == selectedClass;
      if (selectedDivision != null) match = match && s['division'] == selectedDivision;
      return match;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(
        title: const Text("Fees Overview"),
        centerTitle: true,
        backgroundColor: Colors.indigo[800],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo[50]!, Colors.blue[50]!],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Summary Cards (horizontal scrollable)
              // SingleChildScrollView(
                // scrollDirection: Axis.horizontal,
                Row(
                  children: [
                    _buildSummaryCard(
                      title: "Total Paid",
                      amount: totalPaid,
                      icon: Icons.payments,
                      color: Colors.green[700]!,
                    ),
                    const SizedBox(width: 16),
                    _buildSummaryCard(
                      title: "Total Pending",
                      amount: totalPending,
                      icon: Icons.money_off,
                      color: Colors.red[700]!,
                    ),
                  ],
                ),
              // ),

              const SizedBox(height: 24),

              // Filters
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Class",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      value: selectedClass,
                      hint: const Text("Select Class"),
                      items: availableClasses.map((cls) {
                        return DropdownMenuItem(value: cls, child: Text("Class $cls"));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedClass = value;
                          selectedDivision = null; // reset division when class changes
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Division",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      value: selectedDivision,
                      hint: const Text("Select Division"),
                      items: availableDivisions.map((div) {
                        return DropdownMenuItem(value: div, child: Text("Div $div"));
                      }).toList(),
                      onChanged: (value) => setState(() => selectedDivision = value),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Student List (only if class + division selected)
              if (selectedClass != null && selectedDivision != null) ...[
                Text(
                  "Students - Class $selectedClass • Div $selectedDivision",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 16,
                      headingRowColor: MaterialStateProperty.all(Colors.indigo[100]),
                      columns: const [
                        DataColumn(label: Text("Roll", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Name", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Total", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Paid", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Pending", style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text("Action")),
                      ],
                      rows: filteredStudents.map((student) {
                        final pending = student['pending'] as int;
                        return DataRow(cells: [
                          DataCell(Text(student['roll'].toString())),
                          DataCell(Text(student['name'])),
                          DataCell(Text("₹${student['total']}")),
                          DataCell(Text("₹${student['paid']}", style: const TextStyle(color: Colors.green))),
                          DataCell(Text(
                            "₹$pending",
                            style: TextStyle(color: pending == 0 ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
                          )),
                          DataCell(
                            IconButton(
                              icon: Icon(Icons.share, color: Colors.blue[700]),
                              onPressed: () => _shareFeesReport(student),
                              tooltip: "Share Fees Status",
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 40),
                const Center(
                  child: Text(
                    "Select Class and Division to view students",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required int amount,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 164,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.9), color.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              "₹$amount",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareFeesReport(Map<String, dynamic> student) {
    final name = student['name'];
    final roll = student['roll'];
    final cls = student['class'];
    final div = student['division'];
    final total = student['total'];
    final paid = student['paid'];
    final pending = student['pending'];

    final message = """
Dear Parent,

Fees Status Update:

Student: $name (Roll No: $roll, Class: $cls - Div $div)
Total Fees: ₹$total
Amount Paid: ₹$paid
Pending Amount: ₹$pending

Please clear the pending fees at the earliest to avoid any inconvenience.
Contact the school office for payment options or queries.

Thank you,
MG Public School Administration
""";

    Share.share(
      message.trim(),
      subject: "Fees Status - $name ($cls-$div)",
    );
  }
}