import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirestoreService {
  void saveUserDataToFirestore(
    User user,
    String userName,
    String phoneNumber,
  ) {
    // Get a reference to the Firestore database
    final firestore = FirebaseFirestore.instance;

    // Create a new document for the user with their UID
    firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'userName': userName,
      'displayName': userName,
      'phoneNumber': phoneNumber,
    }).then((_) {
      print('User data added to Firestore successfully!');
    }).catchError((error) {
      print('Error adding user data to Firestore: $error');
    });
  }

  static Future<void> addInitialTasksForUser(
      String userId, Function(double) progressCallback) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Retrieve weight of the user from Firestore (you should add this part)
      double weight = 0; // Placeholder for user weight

      SharedPreferences prefs = await SharedPreferences.getInstance();

      // // Retrieve the last completed day
      // int lastCompletedDay = prefs.getInt('lastCompletedDay') ?? -1;
      // print('initialTasksAddeddeeee');
      // print(lastCompletedDay);

      // Store tasks document in local storage if not stored before
      if (!prefs.containsKey('tasksData')) {
        QuerySnapshot taskSnapshot = await firestore.collection('tasks').get();
        if (taskSnapshot.docs.isNotEmpty) {
          List<Map<String, dynamic>> tasksData = taskSnapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
          prefs.setString('tasksData', jsonEncode(tasksData));
        }
      }

      // Create daily tasks for the user from the last completed day + 1 to Day 56
      for (int currentDay = 0; currentDay <= 56; currentDay++) {
        // Get daily tasks for the current day
        List<String> dailyTasks = getTasksForDay(currentDay, weight);

        // Get tasks data from local storage
        List<Map<String, dynamic>> tasksData = [];
        String? tasksDataString = prefs.getString('tasksData');
        if (tasksDataString != null && tasksDataString.isNotEmpty) {
          tasksData =
              List<Map<String, dynamic>>.from(jsonDecode(tasksDataString));
        }

        // Maintain a set to keep track of tasks added for the current day
        Set<String> addedTasks = <String>{};

        // Check if the day field exists in the dailyTasks list
        for (Map<String, dynamic> taskData in tasksData) {
          if (dailyTasks.contains(taskData['day'])) {
            print(taskData['day']);
            // Check if the task with the same title already exists for the current day
            bool taskExists = await firestore
                .collection('users')
                .doc(userId)
                .collection('day')
                .doc(currentDay.toString())
                .collection('dailyTasks')
                .where('taskTitle', isEqualTo: taskData['taskTitle'])
                .get()
                .then((querySnapshot) => querySnapshot.docs.isNotEmpty);

            // If the task doesn't exist, add it
            if (!taskExists) {
              await firestore
                  .collection('users')
                  .doc(userId)
                  .collection('day')
                  .doc(currentDay.toString())
                  .collection('dailyTasks')
                  .add({
                'taskTitle': taskData['taskTitle'],
                'category': taskData['category'],
                'day': taskData['day'],
                'description': taskData['description'],
                'effect': taskData['effect'],
                'isCompleted': taskData['isCompleted'],
                'priority': taskData['priority'],
                'reason': taskData['reason'],
                'time': taskData['time'],
              });
            }
          }
        }

        // // Update the last completed day in SharedPreferences
        // prefs.setInt('lastCompletedDay', currentDay);

        // Update progress
        double progress = (currentDay + 1) / 56;
        // Send progress to UI
        progressCallback(progress);
      }
    } catch (error) {
      throw 'Failed to add initial tasks: $error';
    }
  }

  static List<String> getTasksForDay(int currentDay, double weight) {
    List<String> tasks = [];

    // On Arrival
    if (currentDay == 0) {
      tasks.addAll(["On Arrival", "On Arrival", "On Arrival", "Day 0"]);
    }

    // First 10 days of life
    if (currentDay >= 1 && currentDay <= 10) {
      tasks.add("First 10 days of life");
    }

    // Day 1-3
    if (currentDay >= 1 && currentDay <= 3) {
      tasks.add("Day 1-3");
    }

    // Day 1-4
    if (currentDay >= 1 && currentDay <= 4) {
      tasks.add("Day 1-4");
    }

    // 10-14 days
    if (currentDay >= 10 && currentDay <= 14) {
      tasks.add("10-14 days");
    }

    // 14-16 days
    if (currentDay >= 14 && currentDay <= 16) {
      tasks.add("14-16 days");
    }

    // From day 25 onwards
    if (currentDay >= 25) {
      tasks.add("From day 25 onwards");
    }

    // Weekly
    if ((currentDay - 1) % 7 == 0 && currentDay > 1) {
      tasks.add("Weekly");
    }

    // Daily
    tasks.add("Daily");

    // 1x daily (Morning), (Afternoon), (Evening)
    if (currentDay >= 1 && currentDay <= 56) {
      tasks.addAll(
          ["1x daily (Morning)", "1x daily (Afternoon)", "1x daily (Evening)"]);
    }

    // Once Daily
    if (currentDay >= 1 && currentDay <= 56) {
      tasks.add("Once Daily");
    }

    // When weight crosses 3kg
    if (currentDay == 42 && weight >= 3) {
      tasks.add("When weight crosses 3kg");
    }

    // 3x a week
    if (currentDay % 3 == 0) {
      tasks.add("3x a week");
    }

    // Additional cases
    if (currentDay == 1 || currentDay == 2 || currentDay == 29) {
      tasks.add("After removing the flock");
    }
    if (currentDay == 26 || currentDay == 27 || currentDay == 29) {
      tasks.add("During site cleaning");
    }
    if (currentDay == 22 || currentDay == 23) {
      tasks.add("After removing the litter");
    }
    if (currentDay == 19) {
      tasks.add("Before washing starts");
    }
    if (currentDay == 21 || currentDay == 22 || currentDay == 23) {
      tasks.add("During washing");
    }
    if (currentDay == 21) {
      tasks.add("After washing with detergent");
    }
    if (currentDay == 23 ||
        currentDay == 26 ||
        currentDay == 27 ||
        currentDay == 29) {
      tasks.add("After rinsing");
    }
    if (currentDay == 26 || currentDay == 27 || currentDay == 29) {
      tasks.addAll([
        "After washing",
        "Before cleaning",
        "During cleaning",
        "After scrubbing",
        "After refilling header tank",
        "After adding sanitizer",
        "After running sanitizer",
        "After disinfection period",
        "After cleaning"
      ]);
    }

    // Hours After Placement
    if (currentDay == 0) {
      tasks.add("2 Hours After Placement");
      tasks.add("8 Hours After Placement");
      tasks.add("12 Hours After Placement");
      tasks.add("24 Hours After Placement");
      tasks.add("48 Hours After Placement");
    }

    return tasks;
  }

// Future<void> fetchTasks() async {
//   try {
//     // Get the current user
//     User? user = FirebaseAuth.instance.currentUser;
//
//     if (user != null) {
//       // Get the user document
//       DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .get();
//
//       // Check if the user document exists and contains taskStartDate
//       if (userSnapshot.exists && userSnapshot.data() != null) {
//         // Get the taskStartDate
//
//         if (taskStartDate != null) {
//           // Get the current day
//           DateTime currentDate = DateTime.now();
//           DateTime startDate = taskStartDate.toDate();
//           int differenceInDays = currentDate.difference(startDate).inDays;
//
//           // Fetch tasks based on the difference in days
//           QuerySnapshot querySnapshot =
//           await FirebaseFirestore.instance.collection('tasks').where('day', isEqualTo: differenceInDays).get();
//           setState(() {
//             tasks = querySnapshot.docs;
//           });
//         }
//       }
//     }
//   } catch (error) {
//     print('Error fetching tasks: $error');
//   }
// }

// Future<void> updateTasksForAllUsers() async {
//   try {
//     // Get all tasks from the initialTasks collection
//     QuerySnapshot initialTasksSnapshot =
//         await FirebaseFirestore.instance.collection('initialTasks').get();
//
//     // Iterate over each user document in the users collection
//     QuerySnapshot usersSnapshot =
//         await FirebaseFirestore.instance.collection('users').get();
//
//     for (DocumentSnapshot userDoc in usersSnapshot.docs) {
//       List<String> taskIds = [];
//
//       // Iterate over each task in the initialTasks collection
//       for (DocumentSnapshot taskDoc in initialTasksSnapshot.docs) {
//         // Add task ID to the user's task list
//         String taskId = taskDoc.id;
//         taskIds.add(taskId);
//
//         // Add the task to the user's tasks subcollection
//         await userDoc.reference.collection('tasks').doc(taskId);
//         // .set(taskDoc.data());
//       }
//
//       // Update the user's task list with the task IDs
//       await userDoc.reference.update({'tasks': taskIds});
//     }
//
//     print('Tasks updated for all users successfully!');
//   } catch (error) {
//     print('Failed to update tasks for all users: $error');
//     throw error;
//   }
// }
}
