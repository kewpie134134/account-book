import 'package:account_book/pages/input_form.dart';
import 'package:account_book/pages/home.dart';
import 'package:account_book/pages/list.dart';
import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text("お問い合わせは以下まで"),
            accountEmail: Text("example@example.com"),
          ),
          ListTile(
            title: const Text("収入支出"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(
                MaterialPageRoute(
                  builder: (context) {
                    return const HomePage();
                  },
                ),
              );
            },
          ),
          ListTile(
            title: const Text("家計簿一覧"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(
                MaterialPageRoute(
                  builder: (context) {
                    return const ListPage();
                  },
                ),
              );
            },
          ),
          ListTile(
            title: const Text("入力フォーム"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push<dynamic>(
                MaterialPageRoute(
                  builder: (context) {
                    return InputFormPage();
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
