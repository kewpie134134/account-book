import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final householdAccountDataProvider = StreamProvider((ref) {
  final collection = FirebaseFirestore.instance
      .collection("users")
      .doc("user1")
      .collection("years")
      .doc("2022")
      .collection("datetime");

  final Stream<List<Map<String, dynamic>>> stream =
      collection.snapshots().map((col) {
    return col.docs.map((doc) {
      return doc.data();
    }).toList();
  });
  return stream;
});

final FutureProvider<List<String>> householdAccountYearProvider =
    FutureProvider((ref) {
  final collection = FirebaseFirestore.instance
      .collection("users")
      .doc("user1")
      .collection("years");

  return collection.get().then((snapshot) {
    return snapshot.docs.map((doc) {
      return doc.id;
    }).toList();
  });
});
