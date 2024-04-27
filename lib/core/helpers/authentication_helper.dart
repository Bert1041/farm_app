import 'package:firebase_auth/firebase_auth.dart';

import '../common/widgets/reusable_loader.dart';
import '../services/firestore.dart';

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  get user => _auth.currentUser;

  //SIGN UP METHOD
  Future<bool> signUpWithEmailAndPassword(
    context, {
    required String email,
    required String password,
    required String userName,
    required String phoneNumber,
  }) async {
    try {
      // Show loading spinner
      LoadingSpinner.show(context);

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // print(userCredential.user);
      // After successful signup, save user data to Firestore
      FirestoreService()
          .saveUserDataToFirestore(userCredential.user!, userName, phoneNumber);
      // Store tasks document in local storage

      // Hide loading spinner
      LoadingSpinner.hide(context);
      return true;
    } on FirebaseAuthException catch (e) {
      print('Failed to sign up with email and password: $e');
      LoadingSpinner.hide(context);
      // Show error snackbar
      LoadingSpinner.showErrorSnackbar(context, 'An error occurred: $e');
      return false;
    }
  }

  //SIGN IN METHOD
  Future<bool> signIn(context,
      {required String email, required String password}) async {
    try {
      LoadingSpinner.show(context);
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      LoadingSpinner.hide(context);
      return true;
    } on FirebaseAuthException catch (e) {
      LoadingSpinner.hide(context);
      LoadingSpinner.showErrorSnackbar(context, 'An error occurred: $e');
      return false; // Login failed
    }
  }

  //SIGN IN WITH GOOGLE METHOD
  // Future<UserCredential> signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication? googleAuth =
  //       await googleUser?.authentication;
  //
  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
  //
  //   // Once signed in, return the UserCredential
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  //SIGN OUT METHOD
  Future signOut() async {
    await _auth.signOut();

    print('signout');
  }
}
