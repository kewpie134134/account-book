import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final StreamProviderFamily<List<Map<String, dynamic>>, String>
    householdAccountDataProvider =
    StreamProvider.family<List<Map<String, dynamic>>, String>(
        (ref, strSelectedYear) {
  final collection = FirebaseFirestore.instance
      .collection("users")
      .doc("user1")
      .collection("years")
      .doc(strSelectedYear)
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
    FutureProvider<List<String>>((ref) {
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
