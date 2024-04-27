import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskService {
  late final User? user;

  TaskService() {
    user = FirebaseAuth.instance.currentUser;
  }

  Future<DateTime?> getTaskStartDate() async {
    if (user != null) {
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();
        final taskStartDate = snapshot['taskStartDate'] as Timestamp?;
        if (taskStartDate != null) {
          return taskStartDate.toDate();
        }
      } catch (error) {
        print('Error fetching task start date: $error');
      }
    }
    return null;
  }

  int getCurrentDay(DateTime taskStartDate) {
    final now = DateTime.now();
    final difference = now.difference(taskStartDate);
    return difference.inDays;
  }

  // Future<List<DocumentSnapshot>> getTasksForDay(int day) async {
  //   try {
  //     final querySnapshot = await FirebaseFirestore.instance
  //         .collection('tasks')
  //         .where('day', isEqualTo: day)
  //         .get();
  //     return querySnapshot.docs;
  //   } catch (error) {
  //     print('Error fetching tasks for day $day: $error');
  //     return [];
  //   }
  // }

  Stream<List<DocumentSnapshot>> getTasksForDayStream(int day) {
    try {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('day')
          .doc(day.toString())
          .collection('dailyTasks')
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs);
    } catch (error) {
      print('Error fetching tasks for day $day: $error');
      // Return an empty stream in case of an error
      return Stream.value([]);
    }
  }

  Stream<List<DocumentSnapshot>> getMissedTasks(int currentDay) {
    try {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('day')
          .doc((currentDay - 1).toString())
          .collection('dailyTasks')
          .where('isCompleted', isEqualTo: false)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs);
    } catch (error) {
      print('Error fetching missed tasks: $error');
      return Stream.value([]);
    }
  }
}
