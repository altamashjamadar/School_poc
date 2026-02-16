import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddTeacherScreen extends StatefulWidget {
  const AddTeacherScreen({super.key});

  @override
  State<AddTeacherScreen> createState() => _AddTeacherScreenState();
}

class _AddTeacherScreenState extends State<AddTeacherScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  List<String> selectedClasses = [];
  List<String> selectedSubjects = [];

  final List<String> allClasses = ['8', '9', '10', '11', '12'];
  final List<String> allSubjects = ['Hindi', 'English', 'Maths', 'Science', 'Social Science', 'Computer', 'Physical Education'];

  bool _loading = false;

  Future<void> _addTeacher() async {
    setState(() => _loading = true);

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      );

      await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
        'name': _nameCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'role': 'teacher',
        'assignedClasses': selectedClasses,
        'assignedSubjects': selectedSubjects,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Teacher added successfully!")),
      );

      _nameCtrl.clear();
      _emailCtrl.clear();
      _passwordCtrl.clear();
      selectedClasses.clear();
      selectedSubjects.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Add New Teacher", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: "Full Name")),
          const SizedBox(height: 16),
          TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: "Email")),
          const SizedBox(height: 16),
          TextField(controller: _passwordCtrl, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
          const SizedBox(height: 24),
          const Text("Assign Classes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            children: allClasses.map((cls) {
              return FilterChip(
                label: Text("Class $cls"),
                selected: selectedClasses.contains(cls),
                onSelected: (val) {
                  setState(() {
                    if (val) selectedClasses.add(cls);
                    else selectedClasses.remove(cls);
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const Text("Assign Subjects", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            children: allSubjects.map((sub) {
              return FilterChip(
                label: Text(sub),
                selected: selectedSubjects.contains(sub),
                onSelected: (val) {
                  setState(() {
                    if (val) selectedSubjects.add(sub);
                    else selectedSubjects.remove(sub);
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _loading ? null : _addTeacher,
              child: _loading ? const CircularProgressIndicator() : const Text("Add Teacher"),
            ),
          ),
        ],
      ),
    );
  }
}