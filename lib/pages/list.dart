import 'package:account_book/components/drawer_menu.dart';
import 'package:account_book/mocks/data.dart';
import 'package:account_book/components/input_form.dart';
import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  const ListPage({Key? key}) : super(key: key);

  final List<Tab> _tabs = const <Tab>[
    Tab(text: "総合"),
    Tab(text: "収入"),
    Tab(text: "支出"),
  ];

  @override
  Widget build(BuildContext context) {
    List householdAccountBookList = getHouseholdAccountDataList();

    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("家計簿一覧"),
          bottom: TabBar(
            tabs: _tabs,
          ),
        ),
        drawer: const DrawerMenu(),
        body: TabBarView(
          children: _tabs.map(
            (Tab tab) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _createHouseholdAccountBookDetail(
                      tab.text!,
                      householdAccountBookList,
                    ),
                  ],
                ),
              );
            },
          ).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push<dynamic>(
              MaterialPageRoute(
                builder: (context) {
                  return InputForm();
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _createHouseholdAccountBookDetail(
      String tabText, List householdAccountDataList) {
    int tabType = 3;

    switch (tabText) {
      case "総合":
        tabType = 3;
        return Column(
          children: _createWordCards(tabType, householdAccountDataList),
        );
      case "収入":
        tabType = 1;
        return Column(
          children: _createWordCards(tabType, householdAccountDataList),
        );
      case "支出":
        tabType = 0;
        return Column(
          children: _createWordCards(tabType, householdAccountDataList),
        );
      default:
        return const Text("エラー");
    }
  }

  List<Widget> _createWordCards(int tabType, List householdAccountDataList) {
    return householdAccountDataList.map(
      (householdAccountData) {
        if (householdAccountData["type"] == tabType || tabType == 3) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _createWordTile(householdAccountData, tabType),
            ),
          );
        }
        return Container();
      },
    ).toList();
  }

  Widget _createWordTile(householdAccountData, int tabType) {
    Icon icon = householdAccountData["type"] == 0
        ? const Icon(
            Icons.subdirectory_arrow_left_outlined,
            color: Colors.pink,
          )
        : const Icon(
            Icons.add_box,
            color: Colors.blue,
          );
    return ListTile(
      leading: icon,
      title: Text(householdAccountData["detail"]),
      subtitle: Text("${householdAccountData["cost"]}円"),
    );
  }
}

/// モックデータ
List getHouseholdAccountDataList() {
  List householdAccountData = [];
  var tData = data["data"] as dynamic;
  tData.forEach((var item) {
    int id = int.parse(item['id']);
    int type = int.parse(item['type']);
    String detail = item['detail'];
    int cost = int.parse(item['cost']);

    householdAccountData
        .add({"id": id, "type": type, "detail": detail, "cost": cost});
  });
  return householdAccountData;
}
