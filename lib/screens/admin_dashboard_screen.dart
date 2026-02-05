import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Reports"),
        backgroundColor: Colors.indigo[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "All Attendance Reports",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('attendance_reports')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No attendance reports yet"));
                  }

                  final reports = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      final data = reports[index].data() as Map<String, dynamic>;

                      return Card(
                        
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 3,
                        child: ListTile(
                          // leading: CircleAvatar(
                          //   backgroundColor: Colors.indigo[100],
                          //   child: const Icon(Icons.school, color: Colors.indigo),
                          // ),
                          title: Text(
                            "${data['class'] ?? 'Unknown Class'} - ${data['subject'] ?? 'Unknown Subject'}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Date: ${data['date'] ?? 'N/A'}"),
                              Text("Total: ${data['total'] ?? 0}"),
                              Text("Present: ${data['present'] ?? 0} | Absent: ${data['absent'] ?? 0}"),
                              Text(
                                "Boys: ${data['boysPresent'] ?? 0}P / ${data['boysAbsent'] ?? 0}A   |\n"
                                "Girls: ${data['girlsPresent'] ?? 0}P / ${data['girlsAbsent'] ?? 0}A",
                              ),
                            ],
                          ),
                          trailing: Text(
                            _formatTimestamp(data['timestamp']),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                       
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(Timestamp? ts) {
    if (ts == null) return '';
    final date = ts.toDate();
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}