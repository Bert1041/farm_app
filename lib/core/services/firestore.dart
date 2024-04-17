import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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


}
