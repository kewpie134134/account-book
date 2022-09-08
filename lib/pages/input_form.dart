import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class InputFormPage extends ConsumerWidget {
  InputFormPage({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<Tab> _tabs = const <Tab>[
    Tab(text: "支出"),
    Tab(text: "収入"),
  ];

  final Map<String, dynamic> _data = {
    // モック用の仮データ
    "id": 0,
    "type": 0,
    "detail": "",
    "cost": 0
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      String tabText, GlobalKey<FormState> formKey, BuildContext context) {
    switch (tabText) {
      case "支出":
        return Column(
          children: [_createSpendingInputForm(formKey, context)],
        );
      case "収入":
        return Column(
          children: [_createIncomeInputForm(formKey, context)],
        );
      default:
        return const Text("エラー");
    }
  }

  Widget _createSpendingInputForm(
    GlobalKey<FormState> formKey,
    BuildContext context,
  ) {
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
              _createSaveIconButton(formKey, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createIncomeInputForm(
    GlobalKey<FormState> formKey,
    BuildContext context,
  ) {
    return SafeArea(
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              _createDateTextField(),
              _createItemTextField(),
              _createMoneyTextField(),
              _createDetailTextField(),
              _createSaveIconButton(formKey, context),
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
        _data["detail"] = value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "項目は必須入力項目です";
        }
        return null;
      },
      initialValue: _data["detail"].toString(),
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
        _data["cost"] = value is String ? int.parse(value) : value;
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "金額は必須入力項目です";
        }
        return null;
      },
      initialValue: _data["cost"].toString(),
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
  ) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: ElevatedButton(
        child: const Text("登録"),
        onPressed: () async {
          // validate を実行
          if (formKey.currentState!.validate()) {
            final DateTime now = DateTime.now();
            _data["date"] = DateFormat("yyyyMMddHHmmssSSS").format(now);
            formKey.currentState?.save(); // Form の onSaved 関数を実行する
            // Navigator.of(context).pop<dynamic>();
            await FirebaseFirestore.instance
                .collection("users")
                .doc("user1")
                .collection("date")
                .doc(_data["date"])
                .set(_data);
          }
        },
      ),
    );
  }
}
