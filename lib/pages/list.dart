import 'package:account_book/components/drawer_menu.dart';
import 'package:account_book/entities/account_data.dart';
import 'package:account_book/pages/input_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const List<Map<String, String>> _monthlyData = [
  {"text": "1月", "value": "01"},
  {"text": "2月", "value": "02"},
  {"text": "3月", "value": "03"},
  {"text": "4月", "value": "04"},
  {"text": "5月", "value": "05"},
  {"text": "6月", "value": "06"},
  {"text": "7月", "value": "07"},
  {"text": "8月", "value": "08"},
  {"text": "9月", "value": "09"},
  {"text": "10月", "value": "10"},
  {"text": "11月", "value": "11"},
  {"text": "12月", "value": "12"},
];

class ListPage extends StatelessWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 今月
    int thisMonth = int.parse(DateFormat("M").format(DateTime.now()));
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
            initialIndex: thisMonth - 1, // 最初に表示するタブ
            length: _monthlyData.length, // タブの数
            child: Scaffold(
              drawer: const DrawerSelectYear(),
              appBar: AppBar(
                title: const Text("家計簿一覧"),
                bottom: TabBar(
                  isScrollable: true, // スクロールを有効
                  tabs: _monthlyData
                      .map((month) => Tab(text: month["text"]))
                      .toList(),
                ),
              ),
              body: TabBarView(
                children: _monthlyData.map(
                  (Map<String, String> monthData) {
                    return SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          _createHouseholdAccountBookDetail(
                              documents, monthData),
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
      List<DocumentSnapshot> documents, Map<String, String> monthData) {
    return Container(
      padding: const EdgeInsets.only(top: 48),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _createViewHeader(),
          Column(
            children: _createWordCards(documents, monthData),
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
      List<DocumentSnapshot> documents, Map<String, String> monthData) {
    const selectedYear = "2022"; // riverpod から値を取り出したい

    return documents.map(
      (document) {
        if (document["date"].substring(0, 7) ==
            "$selectedYear/${monthData['value']}") {
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
        } else {
          return Container();
        }
      },
    ).toList();
  }
}
