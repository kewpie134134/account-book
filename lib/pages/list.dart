import 'package:account_book/components/drawer_menu.dart';
import 'package:account_book/entities/account_data.dart';
import 'package:account_book/pages/input_form.dart';
import 'package:account_book/stores/household_account_data.dart';
import 'package:account_book/stores/selected_date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class ListPage extends ConsumerWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // アプリ内で選択されている年を Provider 経由で管理
    final strSelectedYear = ref.watch(strSelectedYearProvider);
    final strSelectedYearController =
        ref.read(strSelectedYearProvider.notifier);

    // アプリ内で選択されている月を Provider 経由で管理
    final strSelectedMonth = ref.watch(strSelectedMonthProvider);
    final strSelectedMonthController =
        ref.read(strSelectedMonthProvider.notifier);
    int thisMonth = int.parse(strSelectedMonth);

    // StreamProvider で管理している家計簿情報を取得
    final householdAccountDataList = ref.watch(householdAccountDataProvider);

    return DefaultTabController(
      initialIndex: thisMonth - 1, // 最初に表示するタブ
      length: _monthlyData.length, // タブの数
      child: Scaffold(
        drawer: const DrawerSelectYear(),
        appBar: AppBar(
          title: const Text("家計簿一覧"),
          bottom: TabBar(
            isScrollable: true, // スクロールを有効
            tabs:
                _monthlyData.map((month) => Tab(text: month["text"])).toList(),
          ),
        ),
        body: TabBarView(
          children: _monthlyData.map(
            (Map<String, String> monthData) {
              return Container(
                child: householdAccountDataList.when(
                  data: (data) {
                    return SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          _createHouseholdAccountBookDetail(data, monthData),
                        ],
                      ),
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
  }

  Widget _createHouseholdAccountBookDetail(
      List<Map<String, dynamic>> documents, Map<String, String> monthData) {
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
      List<Map<String, dynamic>> documents, Map<String, String> monthData) {
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
