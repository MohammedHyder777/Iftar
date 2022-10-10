import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iftar/data.dart';
import 'package:iftar/user.dart';

class DatabaseService {
  final String? uid;
  DatabaseService([this.uid]);

  // create a collection ref.
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('cpath');

  // create or update a document for a certain uid
  Future updateUserData(String food, String name, int strength) async {
    return await collection
        .doc(uid)
        .set({'food': food, 'name': name, 'strength': strength});
  }

  // create a data list from snapshot
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

  // get data stream from a collection
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
}
