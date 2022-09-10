import 'package:account_book/components/drawer_menu.dart';
import 'package:account_book/entities/account_data.dart';
import 'package:account_book/pages/input_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const List<Tab> _tabs = <Tab>[
  Tab(text: "1月"),
  Tab(text: "2月"),
  Tab(text: "3月"),
  Tab(text: "4月"),
  Tab(text: "5月"),
  Tab(text: "6月"),
  Tab(text: "7月"),
  Tab(text: "8月"),
  Tab(text: "9月"),
  Tab(text: "10月"),
  Tab(text: "11月"),
  Tab(text: "12月"),
];

class ListPage extends StatelessWidget {
  const ListPage({Key? key}) : super(key: key);

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
            initialIndex: 0, // 最初に表示するタブ
            length: _tabs.length, // タブの数
            child: Scaffold(
              drawer: const DrawerSelectYear(),
              appBar: AppBar(
                title: const Text("家計簿一覧"),
                bottom: const TabBar(
                  isScrollable: true, // スクロールを有効
                  tabs: _tabs,
                ),
              ),
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
                        return const InputFormPage();
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
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _createHouseholdAccountBookDetail(
      String tabText, List<DocumentSnapshot> documents) {
    return Container(
      padding: const EdgeInsets.only(top: 48),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _createViewHeader(),
          Column(
            children: _createWordCards(documents),
          ),
        ],
      ),
    );
  }

  Widget _createViewHeader() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: ListTile(
            leading: ClipOval(
              child: Container(
                color: Colors.grey[300],
                width: 48,
                height: 48,
                child: Icon(
                  Icons.storage,
                  color: Colors.grey[800],
                ),
              ),
            ),
            title: const Text('Posts'),
            subtitle: const Text('20 Posts'),
          ),
        ),
        Expanded(
          flex: 1,
          child: ListTile(
            leading: ClipOval(
              child: Container(
                color: Colors.grey[300],
                width: 48,
                height: 48,
                child: Icon(
                  Icons.style,
                  color: Colors.grey[800],
                ),
              ),
            ),
            title: const Text('All Types'),
            subtitle: const Text(''),
          ),
        ),
      ],
    );
  }

  List<Widget> _createWordCards(
    List<DocumentSnapshot> documents,
  ) {
    return documents.map(
      (document) {
        const colorPrimary = Colors.black12;
        const colorNegative = Colors.blueAccent;
        const colorPositive = Colors.greenAccent;
        final isSpendingTypeString =
            document["type"] == IncomeSpendingType.spending.name;
        Icon icon = isSpendingTypeString
            ? const Icon(
                Icons.subdirectory_arrow_left_outlined,
                color: Colors.pink,
              )
            : const Icon(
                Icons.add_box,
                color: Colors.blue,
              );

        return Card(
          elevation: 8,
          shadowColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              ListTile(
                leading: ClipOval(
                  child: Container(
                    color: colorPrimary,
                    width: 48,
                    height: 48,
                    child: Center(child: icon),
                  ),
                ),
                title: Text(document["item"]),
                subtitle: Text(document["date"]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 72),
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        border: Border.all(color: colorPrimary, width: 4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(child: Text(document["detail"])),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: colorPrimary, width: 2),
                        ),
                      ),
                      child: Text(
                        document["detail"],
                        style: const TextStyle(color: Colors.blueAccent),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: colorNegative,
                        ),
                        onPressed: () {},
                        child: Text(document["detail"]),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                        child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: colorPositive,
                        backgroundColor: colorPositive.withOpacity(0.2),
                      ),
                      onPressed: () {},
                      child: Text(document["detail"]),
                    ))
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ).toList();
  }
}
