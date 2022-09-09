import 'package:account_book/components/drawer_menu.dart';
import 'package:account_book/entities/account_data.dart';
import 'package:account_book/pages/input_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const List<Tab> _tabs = <Tab>[
  Tab(text: "総合"),
  Tab(text: "収入"),
  Tab(text: "支出"),
];

class ListPage2 extends StatelessWidget {
  const ListPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // StreamBuilder を使って、データ更新を自動で行う
    return StreamBuilder<QuerySnapshot>(
      // stream に Stream<QuerySnapshot> を渡す
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc("user1")
          .collection("datetime")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // List<DocumentSnapshot> を snapshot から取り出す
          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          return DefaultTabController(
            length: _tabs.length,
            child: Scaffold(
              appBar: AppBar(
                title: const Text("家計簿一覧(FB)"),
                bottom: const TabBar(
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
                            documents,
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
                        return InputFormPage();
                      },
                    ),
                  );
                },
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Text("情報取得に失敗しました。");
        } else {
          return const Text("予期せぬエラーが発生しました。再読み込みを試してください。");
        }
      },
    );
  }

  Widget _createHouseholdAccountBookDetail(
      String tabText, List<DocumentSnapshot> documents) {
    String tabType = "total";

    switch (tabText) {
      case "総合":
        tabType = "total";
        return Column(
          children: _createWordCards(tabType, documents),
        );
      case "収入":
        tabType = IncomeSpendingType.income.name;
        return Column(
          children: _createWordCards(tabType, documents),
        );
      case "支出":
        tabType = IncomeSpendingType.spending.name;
        return Column(
          children: _createWordCards(tabType, documents),
        );
      default:
        return const Text("エラー");
    }
  }

  List<Widget> _createWordCards(
      String tabType, List<DocumentSnapshot> documents) {
    return documents.map(
      (document) {
        if (document["type"] == tabType || tabType == "total") {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _createWordTile(tabType, document),
            ),
          );
        }
        return Container();
      },
    ).toList();
  }

  Widget _createWordTile(String tabType, DocumentSnapshot document) {
    Icon icon = document["type"] == IncomeSpendingType.spending.name
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
      title: Text(document["item"]),
      subtitle: Text(document["detail"]),
    );
  }
}
