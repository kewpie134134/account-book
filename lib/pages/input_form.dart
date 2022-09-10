import 'package:account_book/utils/half_length.dart';
import 'package:account_book/entities/account_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InputFormPage extends StatefulWidget {
  const InputFormPage({Key? key}) : super(key: key);

  @override
  State<InputFormPage> createState() => _InputFormPageState();
}

class _InputFormPageState extends State<InputFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<Tab> _tabs = const <Tab>[
    Tab(text: "支出"),
    Tab(text: "収入"),
  ];

  final AccountBookData _data = AccountBookData(
      "", IncomeSpendingType.spending.name, "", "", "", "", 0, "");

  // TextFormField で DatePicker を利用する
  final TextEditingController textEditingController = TextEditingController(
    text: DateFormat("yyyy/MM/dd").format(DateTime.now()),
  );

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    // StreamBuilder を使って最初に 1 度だけ読み込む
    return FutureBuilder<QuerySnapshot>(
      // future に Future<QuerySnapshot> を渡す
      future: FirebaseFirestore.instance
          .collection("users")
          .doc("user1")
          .collection("payment")
          .get(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          // List<DocumentSnapshot> を snapshot から取り出す
          final List<DocumentSnapshot> documents = snapshot.data!.docs;
          return DefaultTabController(
            length: _tabs.length,
            child: Scaffold(
              appBar: AppBar(
                title: const Text("家計簿登録"),
                bottom: TabBar(
                  tabs: _tabs,
                ),
              ),
              body: TabBarView(
                children: _tabs.map(
                  (Tab tab) {
                    return SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          _createInputForm(
                              tab.text!, _formKey, context, mounted, documents),
                        ],
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Text("情報取得に失敗しました。");
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }

  Widget _createInputForm(
    String tabText,
    GlobalKey<FormState> formKey,
    BuildContext context,
    bool mounted,
    List<DocumentSnapshot> documents,
  ) {
    switch (tabText) {
      case "支出":
        return Column(
          children: [
            _createInputFormArea(
              formKey,
              context,
              mounted,
              IncomeSpendingType.spending,
              documents,
            )
          ],
        );
      case "収入":
        return Column(
          children: [
            _createInputFormArea(
              formKey,
              context,
              mounted,
              IncomeSpendingType.income,
              documents,
            )
          ],
        );
      default:
        return const Text("エラー");
    }
  }

  Widget _createInputFormArea(
    GlobalKey<FormState> formKey,
    BuildContext context,
    bool mounted,
    IncomeSpendingType type,
    List<DocumentSnapshot> documents,
  ) {
    final isSpendingType = type == IncomeSpendingType.spending;

    return SafeArea(
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              _createDateTextField(context),
              isSpendingType ? _createStoreTextField() : Container(),
              _createItemTextField(),
              isSpendingType ? _createPaymentTextField(documents) : Container(),
              _createMoneyTextField(),
              _createDetailTextField(),
              _createSaveIconButton(
                formKey,
                context,
                mounted,
                type,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createDateTextField(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        icon: Icon(Icons.calendar_month),
        hintText: "日付",
        labelText: "Date",
      ),
      onSaved: (value) {
        // Save 処理が走った時に処理
        _data.date = value.toString();
      },
      onTap: () {
        _getDate(context);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "日付は必須入力項目です";
        }
        if (!RegExp(r"^[0-9]{4}/(0[1-9]|1[0-2])/(0[1-9]|[12][0-9]|3[01])$")
            .hasMatch(value)) {
          return "日付の形式は yyyy/mm/dd の形式です";
        }
        return null;
      },
    );
  }

  Widget _createStoreTextField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        icon: Icon(Icons.store),
        hintText: "店舗",
        labelText: "Store",
      ),
      onSaved: (value) {
        // Save 処理が走った時に処理
        _data.store = value.toString();
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "店舗は必須入力項目です";
        }
        return null;
      },
    );
  }

  Widget _createItemTextField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        icon: Icon(Icons.library_books),
        hintText: "項目",
        labelText: "Item",
      ),
      onSaved: (value) {
        // Save 処理が走った時に処理
        _data.item = value.toString();
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "項目は必須入力項目です";
        }
        return null;
      },
    );
  }

  Widget _createPaymentTextField(List<DocumentSnapshot> documents) {
    final items = documents
        .map((document) => DropdownMenuItem<String>(
              value: document["payment"],
              child: Text(document["payment"]),
            ))
        .toList();
    return DropdownButtonFormField(
      value: items[0].value,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        icon: Icon(Icons.payment),
        hintText: "支払方法",
        labelText: "Payment",
      ),
      onSaved: (value) {
        // Save 処理が走った時に処理
        _data.payment = value.toString();
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "支払方法は必須入力項目です";
        }
        return null;
      },
      items: items,
      onChanged: (String? value) {
        setState(() {
          value;
        });
      },
    );
  }

  Widget _createMoneyTextField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        icon: Icon(CupertinoIcons.money_dollar),
        hintText: "金額",
        labelText: "Money",
      ),
      onSaved: (value) {
        // 全角文字の場合、半角文字に変換する
        String halfLengthValue =
            JapaneseString(value!.replaceAll(",", "").toString())
                .alphanumericToHalfLength();
        // Save 処理が走った時に処理
        _data.amount = int.parse(halfLengthValue);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "金額は必須入力項目です";
        }
        if (!RegExp(r"^[0-9０-９][0-9０-９,]*$").hasMatch(value)) {
          return "金額を入力したください";
        }
        return null;
      },
    );
  }

  Widget _createDetailTextField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        icon: Icon(Icons.notes),
        hintText: "詳細",
        labelText: "Detail",
      ),
      keyboardType: TextInputType.multiline,
      maxLength: 140,
      maxLines: null,
      onSaved: (value) {
        // Save が走った時に処理
        _data.detail = value.toString();
      },
      validator: (value) {
        return null;
      },
    );
  }

  Widget _createSaveIconButton(
    GlobalKey<FormState> formKey,
    BuildContext context,
    bool mounted,
    IncomeSpendingType type,
  ) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: ElevatedButton(
        child: const Text("登録"),
        onPressed: () async {
          // validate を実行
          if (formKey.currentState!.validate()) {
            final DateTime now = DateTime.now();
            _data.doc = DateFormat("yyyyMMddHHmmssSSS").format(now);
            _data.type = type.name;
            formKey.currentState?.save(); // Form の onSaved 関数を実行する
            await FirebaseFirestore.instance
                .collection("users")
                .doc("user1")
                .collection("datetime")
                .doc(_data.doc)
                .set(_data.toMap());
            if (!mounted) return;
            Navigator.of(context).pop<dynamic>();
          }
        },
      ),
    );
  }

  Future _getDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 3),
      lastDate: DateTime(DateTime.now().year + 3),
    );

    if (selectedDate != null) {
      textEditingController.text =
          DateFormat("yyyy/MM/dd").format(selectedDate);
    } else {
      return;
    }
  }
}
