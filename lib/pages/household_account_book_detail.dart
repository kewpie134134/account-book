import 'package:account_book/components/drawer_menu.dart';
import 'package:flutter/material.dart';

class PieData {
  String activity;
  double money;
  PieData(this.activity, this.money);
}

class HouseholdAccountBookDetail extends StatelessWidget {
  const HouseholdAccountBookDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("収入支出"),
      ),
      drawer: const DrawerMenu(),
      body: const Text("円グラフを表示させたい"),
    );
  }
}
