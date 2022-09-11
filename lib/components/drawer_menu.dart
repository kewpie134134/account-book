import 'package:account_book/app_root.dart';
import 'package:account_book/stores/household_account_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrawerSelectYear extends ConsumerWidget {
  const DrawerSelectYear({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final years = ref.watch(householdAccountYearProvider);
    return Drawer(
      child: ListView(
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text("user1"),
            accountEmail: Text("example@example.com"),
          ),
          years.when(
            data: (data) {
              return Column(
                children: data.map((doc) {
                  return ListTile(
                    title: Text(doc),
                    onTap: () {
                      // ここで Riverpod に値を渡したい
                      Navigator.of(context).pop();
                      Navigator.of(context).push<dynamic>(
                        MaterialPageRoute(
                          builder: (context) {
                            return const AppRoute();
                          },
                        ),
                      );
                    },
                  );
                }).toList(),
              );
            },
            error: (error, stackTrace) {
              return Text(
                error.toString(),
                style: const TextStyle(fontSize: 24),
              );
            },
            loading: () {
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ],
      ),
    );
  }
}
