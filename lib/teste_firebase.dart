import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

Future<List<QueryDocumentSnapshot>> teste() async {
  final listData = await _firebaseFirestore.collection('teste').get();

  return listData.docs;
}
