import 'package:account_book/app_root.dart';
import 'package:account_book/stores/household_account_data.dart';
import 'package:account_book/stores/selected_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrawerSelectYear extends ConsumerWidget {
  const DrawerSelectYear({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final yearsList = ref.watch(householdAccountYearProvider);
    final strSelectedYearController =
        ref.read(strSelectedYearProvider.notifier);

    return Drawer(
      child: ListView(
        children: <Widget>[
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            accountName: Text("user1"),
            accountEmail: Text("example@example.com"),
          ),
          yearsList.when(
            data: (data) {
              return Column(
                children: data.map((doc) {
                  return ListTile(
                    title: Text(
                      doc,
                      style: doc ==
                              ref.watch(strSelectedYearProvider.notifier).state
                          ? const TextStyle(fontWeight: FontWeight.bold)
                          : const TextStyle(fontWeight: FontWeight.normal),
                    ),
                    onTap: () {
                      // 選択した年を Provider に知らせる
                      strSelectedYearController.state = doc;
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
