import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentItemsProvider = FutureProvider((ref) {
  final collection = FirebaseFirestore.instance
      .collection("users")
      .doc("user1")
      .collection("payment");

  return collection.get().then((snapshot) {
    return snapshot.docs.map((doc) {
      return doc.data();
    });
  });
});
