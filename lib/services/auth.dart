import 'package:firebase_auth/firebase_auth.dart';
import 'package:iftar/services/database.dart';
import 'package:iftar/user.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // Create custom user object IUser:
  IUser? _userFromFBUser(User? fbuser){
    return fbuser != null? IUser(fbuser.uid, fbuser.email) : null;
  }

  /// change user stream
  Stream<IUser?> get user {
    return _firebaseAuth.authStateChanges()
        .map((user) => _userFromFBUser(user));
  }



  // sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _firebaseAuth.signInAnonymously();
      User? user = result.user;
      return _userFromFBUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and passwrod
  Future signInWithEmail(email, pw) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: pw);

      User? user = result.user;
      return _userFromFBUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email
  Future signUpWithEmail(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User? fbuser = result.user;
      // Create a document for the new user
      await DatabaseService(fbuser!.uid).updateUserData('فول', 'Mohammed', 500);

      return _userFromFBUser(fbuser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  // sign out
  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } on Exception catch (e) {
      print(e.toString());
      return null;
    }
  }
}