import 'package:account_book/app_root.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DrawerSelectYear extends StatelessWidget {
  const DrawerSelectYear({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection("users")
            .doc("user1")
            .collection("years")
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            final List<Widget> resList = [];
            resList.add(const UserAccountsDrawerHeader(
              accountName: Text("user1"),
              accountEmail: Text("example@example.com"),
            ));
            for (final document in documents) {
              resList.add(ListTile(
                title: Text(document.id),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push<dynamic>(
                    MaterialPageRoute(
                      builder: (context) {
                        return const AppRoute();
                      },
                    ),
                  );
                },
              ));
            }
            return Drawer(child: ListView(children: resList));
          } else if (snapshot.hasError) {
            return const Text("通信エラーが発生しました");
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
