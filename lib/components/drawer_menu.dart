import 'package:account_book/app_root.dart';
import 'package:flutter/material.dart';

class DrawerSelectYear extends StatelessWidget {
  const DrawerSelectYear({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text("user1"),
            accountEmail: Text("example@example.com"),
          ),
          ListTile(
            title: const Text("20xx年"),
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
          ),
        ],
      ),
    );
  }
}
