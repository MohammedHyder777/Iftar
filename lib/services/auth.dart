import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iftar/services/database.dart';
import 'package:iftar/user.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // String name = '';

  /// Create custom user object IUser:
  IUser? _userFromFBUser(User? fbuser) {
    return fbuser != null
        ? IUser(fbuser.uid, fbuser.email, fbuser.displayName ?? 'Anon')
        : null;
  }

  /// user state changes stream
  Stream<IUser?> get user {
    return _firebaseAuth
        .authStateChanges()
        .map((user) => _userFromFBUser(user));
  }

  /// sign in anonymously
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

  /// sign in with email and passwrod
  Future signInWithEmail(email, pw) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: pw);

      User? user = result.user;

      // Get the fullname of this user
      // String fullName = await DatabaseService().getUserFullName(user!.uid);
      // Check if he has a doc in today's collection. If not create one.
      if (await DatabaseService.hasData(user!.uid)) {
        print(
            '====================\n بياناته مسجلة في قاعدة البيانات \n====================\n');
      } else {
        await DatabaseService(user.uid)
            .updateUserOrderData('لن أفطر معكم', user.displayName!, 500);
      }
      //////////////////////////////

      return _userFromFBUser(user);
    } on FirebaseAuthException catch (error) {
      throw FirebaseAuthException(code: error.code);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  /// sign in with google
  Future signInWithGoogle() async {
    // Trigger the authentication flow
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential result =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = result.user;

      // Check if he has a doc in user auth collection. If not create one.
      if (await DatabaseService().hasDataInAuthCollection(user!.uid)) {
        print('====================\n بياناته مسجلة  \n====================\n');
      } else {
        DatabaseService(user.uid).addUserToDB(_userFromFBUser(user)!);
      }
      // Check if he has a doc in today's collection. If not create one.
      if (await DatabaseService.hasData(user.uid)) {
        print(
            '====================\n بياناته مسجلة في قاعدة البيانات \n====================\n');
      } else {
        await DatabaseService(user.uid)
            .updateUserOrderData('لن أفطر معكم', googleUser!.displayName!, 500);
      }
      return _userFromFBUser(user);
    } on FirebaseAuthException catch (error) {
      throw FirebaseAuthException(code: error.code);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  /// register with email and add to database
  Future signUpWithEmail(String name, String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? fbuser = result.user;

      // Change displayname in fbuser:
      await fbuser!.updateDisplayName(name);
      // Create a document for the new user
      await DatabaseService(fbuser.uid)
          .updateUserOrderData('لن أفطر معكم', name, 500);
      // Add the user to the users_auth_collection
      DatabaseService(fbuser.uid).addUserToDB(_userFromFBUser(fbuser)!);

      return _userFromFBUser(fbuser);
    } on FirebaseAuthException catch (error) {
      throw FirebaseAuthException(code: error.code);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  /// sign out
  Future signOut() async {
    try {
      try { // The try block is to avoid PlatformException(status, Failed to disconnect., null, null) whith normal auth users.
        await GoogleSignIn().disconnect(); // To ask to choose a google account in the next google sign in.
      } catch(e){}

      return await _firebaseAuth.signOut();
    } on Exception catch (e) {
      print(e.toString());
      return null;
    }
  }

  /// Delete User account from fbauth and his data from fbfirestore
  void deleteUserAccount() async {
    // Delete data from firestore
    try {
      String uid = _firebaseAuth.currentUser!.uid;
      await DatabaseService().usersAuthCollection.doc(uid).delete();
      await DatabaseService.collection.doc(uid).delete();
    } on FirebaseException catch (e) {
      print('Unable to connect database.');
      throw FirebaseException(
          plugin: e.plugin, code: e.code, message: e.message);
    }

    // Delete user auth from firebase auth:

    try {
    await _firebaseAuth.currentUser!.delete();
    } on FirebaseException catch (e) {
      print('Cannot delete.');
    }
  }

}
