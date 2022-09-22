import 'package:account_book/components/drawer_menu.dart';
import 'package:account_book/entities/account_data.dart';
import 'package:account_book/pages/input_form.dart';
import 'package:account_book/stores/household_account_data.dart';
import 'package:account_book/stores/selected_date.dart';
import 'package:flutter/cupertino.dart';
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

    // アプリ内で選択されている月を Provider 経由で管理
    final strSelectedMonth = ref.watch(strSelectedMonthProvider);
    final strSelectedMonthController =
        ref.read(strSelectedMonthProvider.notifier);
    int thisMonth = int.parse(strSelectedMonth);

    // StreamProvider で管理している家計簿情報を取得
    final householdAccountDataList =
        ref.watch(householdAccountDataProvider(strSelectedYear));

    return DefaultTabController(
      initialIndex: thisMonth - 1, // 最初に表示するタブ
      length: _monthlyData.length, // タブの数
      child: Scaffold(
        drawer: const DrawerSelectYear(), // Drawer Widget
        appBar: AppBar(
          title: Text("$strSelectedYear年 家計簿一覧"),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: 'ユーザー情報と年度選択',
              );
            },
          ),
          bottom: TabBar(
            onTap: (value) {
              strSelectedMonthController.state = (value + 1).toString();
            },
            isScrollable: true, // スクロールを有効
            tabs:
                _monthlyData.map((month) => Tab(text: month["text"])).toList(),
          ),
        ),
        body: TabBarView(
          children: _monthlyData.map(
            (Map<String, String> monthData) {
              return householdAccountDataList.when(
                data: (data) {
                  return SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        _createHouseholdAccountBookDetail(
                          data,
                          monthData,
                          strSelectedYear,
                        ),
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
    List<Map<String, dynamic>> documents,
    Map<String, String> monthData,
    String strSelectedYear,
  ) {
    return Container(
      padding: const EdgeInsets.only(top: 48),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _createViewHeader(
            documents,
            monthData,
            strSelectedYear,
          ),
          _createWordCards(
            documents,
            monthData,
            strSelectedYear,
          ),
        ],
      ),
    );
  }

  Widget _createViewHeader(
    List<Map<String, dynamic>> documents,
    Map<String, String> monthData,
    String strSelectedYear,
  ) {
    var spendingAmount = 0;
    var incomeAmount = 0;
    final postsLength = (documents.where((document) {
      if (document["date"].substring(0, 7) ==
          "$strSelectedYear/${monthData['value']}") {
        if (document["type"] == IncomeSpendingType.spending.name) {
          spendingAmount += document["amount"] as int;
        } else {
          incomeAmount += document["amount"] as int;
        }
        return true;
      } else {
        return false;
      }
    }).length);
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
            title: const Text('家計簿数'),
            subtitle: Text("$postsLength 件"),
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
            title: const Text('支出総額'),
            subtitle: Text("${spendingAmount.toString()} 円"),
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
            title: const Text('収入総額'),
            subtitle: Text("${incomeAmount.toString()} 円"),
          ),
        ),
      ],
    );
  }

  Widget _createWordCards(
    List<Map<String, dynamic>> documents,
    Map<String, String> monthData,
    String strSelectedYear,
  ) {
    return Column(
      children: documents.map(
        (document) {
          if (document["date"].substring(0, 7) ==
              "$strSelectedYear/${monthData['value']}") {
            const colorPrimary = Colors.black12;
            const colorDetailButton = Colors.black;
            const colorEditButton = Colors.blueAccent;
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
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: ListTile(
                            leading: ClipOval(
                              child: Container(
                                color: colorPrimary,
                                width: 48,
                                height: 48,
                                child: Center(child: icon),
                              ),
                            ),
                            title: Row(
                              children: <Widget>[
                                const Icon(Icons.library_books),
                                const SizedBox(width: 8),
                                Text(document["item"]),
                              ],
                            ),
                            subtitle: Row(
                              children: <Widget>[
                                const Icon(Icons.store),
                                const SizedBox(width: 8),
                                Text(document["store"]),
                              ],
                            )),
                      ),
                      Expanded(
                        flex: 1,
                        child: ListTile(
                          title: Row(
                            children: <Widget>[
                              const Icon(CupertinoIcons.money_yen),
                              const SizedBox(width: 8),
                              Text("${document["amount"].toString()}円"),
                            ],
                          ),
                          subtitle: Row(
                            children: <Widget>[
                              const Icon(Icons.payment),
                              const SizedBox(width: 8),
                              Text(document["payment"]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 68),
                        const Icon(
                          Icons.calendar_month,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                            child: Text(
                          document["date"],
                          style: const TextStyle(color: Colors.black),
                        )),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: colorDetailButton,
                              backgroundColor:
                                  colorDetailButton.withOpacity(0.2),
                            ),
                            onPressed: () {},
                            child: const Text("詳細"),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                            child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: colorEditButton,
                            backgroundColor: colorEditButton.withOpacity(0.2),
                          ),
                          onPressed: () {},
                          child: const Text("編集"),
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
      ).toList(),
    );
  }
}
