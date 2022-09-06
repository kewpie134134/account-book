import 'package:flutter/material.dart';

class HouseholdAccountBookList extends StatelessWidget {
  const HouseholdAccountBookList({Key? key}) : super(key: key);

  final List<Tab> _tabs = const <Tab>[
    Tab(text: "総合"),
    Tab(text: "収入"),
    Tab(text: "支出"),
  ];

  // ★ 必要か検討
  //   static Route<dynamic> route() {
  //   return MaterialPageRoute<dynamic>(
  //     builder: (_) => const HouseholdAccountBookList(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("家計簿"),
        ),
      ),
    );
  }
}
