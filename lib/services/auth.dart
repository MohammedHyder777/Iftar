import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iftar/services/database.dart';
import 'package:iftar/user.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Create custom user object IUser:
  IUser? _userFromFBUser(User? fbuser, String name) {
    return fbuser != null ? IUser(fbuser.uid, fbuser.email, name) : null;
  }

  /// user state changes stream
  Stream<IUser?> get user {
    return _firebaseAuth
        .authStateChanges()
        .map((user) => _userFromFBUser(user, 'fullName'));
  }

  // sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _firebaseAuth.signInAnonymously();
      User? user = result.user;
      return _userFromFBUser(user, 'Anon');
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

      // Get the fullname of this user
      String fullName = DatabaseService(user!.uid).getUserFullName(user.uid);
      // Check if he has a doc in today collection. If not create one.
      if (await DatabaseService().hasData(user.uid)) {
      } else {
        await DatabaseService(user.uid)
            .updateUserOrderData('لن أفطر معكم', fullName, 500);
      }
      //////////////////////////////

      return _userFromFBUser(user, fullName);
    } on FirebaseAuthException catch (error) {
      throw FirebaseAuthException(code: error.code);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and add to database
  Future signUpWithEmail(String name, String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? fbuser = result.user;
      // Create a document for the new user
      await DatabaseService(fbuser!.uid)
          .updateUserOrderData('لن أفطر معكم', name, 500);
      // Add the user to the users_auth_collection
      DatabaseService(fbuser.uid).addUserToDB(_userFromFBUser(fbuser, name)!);

      return _userFromFBUser(fbuser, name);
    } on FirebaseAuthException catch (error) {
      throw FirebaseAuthException(code: error.code);
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

  /// Delete User account from fbauth and his data from fbfirestore
  void deleteUserAccount() async {

    // Delete data from firestore
    String uid = _firebaseAuth.currentUser!.uid;
    DatabaseService().usersAuthCollection.doc(uid).delete();
    DatabaseService().collection.doc(uid).delete();

    // Delete user auth from firebase auth:
    _firebaseAuth.currentUser!.delete();
  }
}
