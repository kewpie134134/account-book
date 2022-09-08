import 'package:account_book/entities/account_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InputFormPage extends StatelessWidget {
  InputFormPage({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<Tab> _tabs = const <Tab>[
    Tab(text: "支出"),
    Tab(text: "収入"),
  ];

  final AccountBookData _data = AccountBookData(
    "",
    IncomeSpendingType.spending.name,
    "",
    "",
    "",
    "",
    0,
    "",
  );

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
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
                      tab.text!,
                      _formKey,
                      context,
                      mounted,
                    ),
                  ],
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  Widget _createInputForm(
    String tabText,
    GlobalKey<FormState> formKey,
    BuildContext context,
    bool mounted,
  ) {
    switch (tabText) {
      case "支出":
        return Column(
          children: [_createSpendingInputForm(formKey, context, mounted)],
        );
      case "収入":
        return Column(
          children: [_createIncomeInputForm(formKey, context, mounted)],
        );
      default:
        return const Text("エラー");
    }
  }

  Widget _createSpendingInputForm(
      GlobalKey<FormState> formKey, BuildContext context, bool mounted) {
    return SafeArea(
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              _createDateTextField(),
              _createStoreTextField(),
              _createItemTextField(),
              _createPaymentTextField(), // セレクターにしたい
              _createMoneyTextField(),
              _createDetailTextField(),
              _createSaveIconButton(formKey, context, mounted),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createIncomeInputForm(
      GlobalKey<FormState> formKey, BuildContext context, bool mounted) {
    return SafeArea(
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              _createDateTextField(),
              Container(),
              _createItemTextField(),
              Container(),
              _createMoneyTextField(),
              _createDetailTextField(),
              _createSaveIconButton(formKey, context, mounted),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createDateTextField() {
    return TextFormField(
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "項目は必須入力項目です";
        }
        return null;
      },
      initialValue: "",
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
          return "項目は必須入力項目です";
        }
        return null;
      },
      initialValue: "",
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
      initialValue: _data.detail,
    );
  }

  Widget _createPaymentTextField() {
    return TextFormField(
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
          return "項目は必須入力項目です";
        }
        return null;
      },
      initialValue: "",
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
        // Save 処理が走った時に処理
        _data.amount = int.parse(value!);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "金額は必須入力項目です";
        }
        return null;
      },
      initialValue: _data.amount.toString(),
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
      onSaved: (value) {
        // Save が走った時に処理
        _data.detail = value.toString();
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "項目は必須入力項目です";
        }
        return null;
      },
      initialValue: "",
    );
  }

  Widget _createSaveIconButton(
    GlobalKey<FormState> formKey,
    BuildContext context,
    bool mounted,
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
            formKey.currentState?.save(); // Form の onSaved 関数を実行する
            await FirebaseFirestore.instance
                .collection("users")
                .doc("user1")
                .collection("date")
                .doc(_data.doc)
                .set(_data.toMap());
            if (!mounted) return;
            Navigator.of(context).pop<dynamic>();
          }
        },
      ),
    );
  }
}
