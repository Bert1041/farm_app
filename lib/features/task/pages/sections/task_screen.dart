import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskScreen extends StatefulWidget {
  final String userId;
  const TaskScreen({super.key, required this.userId});

  @override
  TaskScreenState createState() => TaskScreenState();
}

class TaskScreenState extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return const Text('No data available');
          }

          // Calculate the number of days since the user's start date
          DateTime startDate =
              (snapshot.data!.data()! as Map)['startDate']?.toDate() ??
                  DateTime.now();
          int daysSinceStart = DateTime.now().difference(startDate).inDays;

          print(startDate);
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('tasks')
                // .where('day', isEqualTo: daysSinceStart + 2) // Day numbering starts from 1
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> taskSnapshot) {
              if (taskSnapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (!taskSnapshot.hasData ||
                  taskSnapshot.data!.docs.isEmpty) {
                return const Text('No tasks for today');
              }

              // Display tasks for today
              return ListView(
                children: taskSnapshot.data!.docs.map((taskDoc) {
                  return ListTile(
                    title: Text(taskDoc['name']),
                    subtitle: Text(taskDoc['description']),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
