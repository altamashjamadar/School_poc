import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ManageStudentsScreen extends StatefulWidget {
  const ManageStudentsScreen({super.key});

  @override
  State<ManageStudentsScreen> createState() => _ManageStudentsScreenState();
}

class _ManageStudentsScreenState extends State<ManageStudentsScreen> {
  bool _uploading = false;

  Future<void> _uploadExcel() async {
    setState(() => _uploading = true);

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xls', 'xlsx'],
      );

      if (result == null || result.files.isEmpty) return;

      final fileBytes = File(result.files.single.path!).readAsBytesSync();
      final excel = Excel.decodeBytes(fileBytes);

      final sheet = excel.sheets[excel.sheets.keys.first]!;
      final batch = FirebaseFirestore.instance.batch();

      for (var row in sheet.rows.skip(1)) { // skip header
        final data = row.map((e) => e?.value).toList();
        if (data.length < 6) continue;

        final docRef = FirebaseFirestore.instance.collection('students').doc();
        batch.set(docRef, {
          'roll': data[0]?.toString(),
          'name': data[1]?.toString(),
          'class': data[2]?.toString(),
          'division': data[3]?.toString(),
          'age': int.tryParse(data[4]?.toString() ?? '0') ?? 0,
          'phone': data[5]?.toString(),
          'gender': data[6]?.toString() ?? 'Unknown',
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Students uploaded successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Upload failed: $e")));
    } finally {
      setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Manage Students", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: _uploading ? const CircularProgressIndicator() : const Icon(Icons.upload_file),
            label: Text(_uploading ? "Uploading..." : "Upload Students Excel"),
            onPressed: _uploading ? null : _uploadExcel,
          ),
          const SizedBox(height: 32),
          const Text("Excel format expected:"),
          const Text("Columns: Roll, Name, Class, Division, Age, Phone, Gender"),
        ],
      ),
    );
  }
}