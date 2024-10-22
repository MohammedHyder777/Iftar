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
  Future<String> getUserFullName(uid) async {
    String name = '';
    DocumentSnapshot snapshot = await usersAuthCollection.doc(uid).get();
    var docData = snapshot.data() as Map;
    name = docData['name'];

    return name;
  }

  // The collection (m_coll) will contain collections of days
  // create a collection ref. for the collection of this day (coll_13_10_2022)
  static final CollectionReference collection = FirebaseFirestore.instance
      .collection('m_coll')
      .doc('subColl_${today.day}_${today.month}_${today.year}')
      .collection('orders');

  /// create or update a document for a certain uid. Ensure to update the model object IUser in home
  Future updateUserOrderData(String food, String name, int strength) async {
    // change the displayname of fb authentication user
    await FirebaseAuth.instance.currentUser!.updateDisplayName(name);

    await usersAuthCollection
        .doc(uid)
        .set({'name': name}, SetOptions(merge: true));
    await collection
        .doc(uid)
        .set({'food': food, 'name': name, 'strength': strength});
  }

  /// create a data list from snapshot
  static List<Data> _dataListFromSnapShot(QuerySnapshot snapshot) {
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
  static Stream<List<Data>> get document {
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
  static Future<bool> hasData(uid) async {
    bool ok;
    ok = await collection.doc(uid).get().then((value) => ok = value.exists);
    return ok;
  }

  /// Delete user data from today's collection without touching user auth collection and authentication
  void deleteOrder(uid) async {
    try {
      await collection.doc(uid).delete();
    } on FirebaseException catch (e) {
      print('Unable to connect database.');
      throw FirebaseException(
          plugin: e.plugin, code: e.code, message: e.message);
    }
  }

  //*/ Reports Streams ///////////////////////////////////////////////////:

  Stream<Map<String, int>> get glossaryStats {
  return FirebaseFirestore.instance.collectionGroup('orders').snapshots().map(getStatsFromSnapshot);
  }

  /// Returns a map {'food' : int count} extracted from a snapshot.
  Map<String, int> getStatsFromSnapshot(snap) {
    int fcount = 0;
    int notfcount = 0;
    int fastcount = 0;
    for (var doc in snap.docs) {
      switch (doc.data()['food']) {
        case 'فول':
          fcount++;
          break;
        case 'غير الفول':
          notfcount++;
          break;
        case 'لن أفطر معكم':
          fastcount++;
          break;
        default:
      }
    }
    Map<String, int> statsMap = {
      'فول': fcount,
      'غير الفول': notfcount,
      'لن أفطر معكم': fastcount
    };

    print(statsMap);
    return statsMap;
  }


}


