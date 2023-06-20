import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider {
  FirebaseAuth auth = FirebaseAuth.instance;

  AuthProvider();

  //create account
  Future<String?> createAccount({required String userName, required String email, required String password}) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      return "Account created";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return ('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return('The account already exists for that email.');
      }
    } catch (e) {
      return(e.toString());
    }
  }

  //login
  Future<String?> login({required String email, required String password}) async {
    try {
      // prosledjivanje emaila i lozinke da bi se izvršilo logovanje
      await auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return "Welcome";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return('Wrong password provided for that user.');
      }
    }
  }

  //sign out
  void signOut() {
    auth.signOut();
  }

  // nova lozinka
  Future<String> updatePassword(String password, String email) async {
    var firebaseUser = await auth.currentUser!;
    firebaseUser.updatePassword(password);
    AuthCredential credential = EmailAuthProvider.credential(
        email: email, password: password);

      await auth.currentUser!.reauthenticateWithCredential(credential);
      return "Password updated";

  }
}
