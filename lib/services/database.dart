import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iftar/data.dart';
import 'package:iftar/user.dart';

// Date of Today:
DateTime today = DateTime.now();

class DatabaseService {
  final String? uid;
  DatabaseService([this.uid]);

  final CollectionReference usersAuthCollection =
      FirebaseFirestore.instance.collection('users_auth_coll');

  /// Add the user to the users_auth_coll:
  void addUserToDB(IUser iuser) async {
    await usersAuthCollection
        .doc(iuser.uid)
        .set({'name': iuser.name, 'uid': iuser.uid, 'email': iuser.email});
  }

  /// Check if the user is in the users_auth_coll
  Future<bool> hasDataInAuthCollection(uid) async {
    bool ok;
    ok = await usersAuthCollection.doc(uid).get().then((value) => value.exists);
    return ok;
  }

  /// Get the name of user with uid = uid
  String getUserFullName(uid) {
    String name = '';
    usersAuthCollection.doc(uid).get().then((value) {
      var docData = value.data() as Map;
      name = docData['name'];
    }).onError((error, stackTrace) {
      name = 'مستخدم جديد';
    });

    return name;
  }

  // The collection (m_coll) will contain collections of days
  // create a collection ref. for the collection of this day (coll_13_10_2022)
  final CollectionReference collection = FirebaseFirestore.instance
      .collection('m_coll')
      .doc('subColl_${today.day}_${today.month}_${today.year}')
      .collection('orders');

  /// create or update a document for a certain uid
  Future updateUserData(String food, String name, int strength) async {
    await usersAuthCollection.doc(uid).set({'name': name}, SetOptions(merge: true));
    await collection
        .doc(uid)
        .set({'food': food, 'name': name, 'strength': strength});
  }

  /// create a data list from snapshot
  List<Data> _dataListFromSnapShot(QuerySnapshot snapshot) {
    return snapshot.docs.map((adoc) {
      var docData = adoc.data() as Map;
      return Data(
        uid: adoc.id,
        name: docData['name'],
        food: docData['food'],
        strength: docData['strength'],
      );
    }).toList();
  }

  /// get data stream from a collection
  Stream<List<Data>> get document {
    return collection.snapshots().map(_dataListFromSnapShot);
  }

  // IUserData from a snapshot
  IUserData _iuserDataFromSnapShot(DocumentSnapshot snapshot) {
    var sdata = snapshot.data() as Map;
    return IUserData(
      uid: uid,
      name: sdata['name'],
      food: (snapshot.data() as Map)['food'],
      strength: sdata['strength'],
    );
  }

  // get user data(document)
  Stream<IUserData> get userData {
    return collection.doc(uid).snapshots().map(_iuserDataFromSnapShot);
  }

  /// Check if he has data (There is a doc with id = uid in the collection)
  Future<bool> hasData(uid) async {
    bool ok;
    ok = await collection.doc(uid).get().then((value) => ok = value.exists);
    return ok;
  }
}
