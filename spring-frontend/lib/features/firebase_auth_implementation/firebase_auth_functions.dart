import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

final Future<FirebaseApp> firebaseInitialization = Firebase.initializeApp();
FirebaseAuth auth = FirebaseAuth.instance;

class FirebaseAuthFunctions {
  final _auth = FirebaseAuth.instance;

  //Create function to sign up user through email verification and password (using Firebase)
  Future<void> signUpUser(String email, String password) async {
    UserCredential user;
    try {
      user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // await _auth.currentUser.sendEmailVerification();
      // You can add additional logic here, such as saving user data to a database
    } catch (e) {
      // Handle any errors that occur during the sign-up process
      print('Error signing up user: $e');
    }
  }
}
