import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum RadioValue { spending, income }

// riverpod と statenotifier を使用した状態管理方法
class InputFormState extends StateNotifier<RadioValue> {
  InputFormState({Key? key}) : super(RadioValue.income);

  void changeState(value) {
    state = value;
  }

  @override
  get state;
}

// StateNotifierProvider で状態を発信する
final inputFormProvider = StateNotifierProvider<InputFormState, RadioValue>(
    (ref) => InputFormState());

class InputFormPage extends ConsumerWidget {
  InputFormPage({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _data = {
    // モック用の仮データ
    "id": 0,
    "type": 0,
    "detail": "",
    "cost": 0
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupValue = ref.watch(inputFormProvider);
    final inputFormController = ref.read(inputFormProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text("家計簿登録"),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: <Widget>[
              _createRadioListColumn(inputFormController, groupValue),
              _createTextFieldColumn(),
              _createSaveIconButton(inputFormController, context, _formKey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createRadioListColumn(
      InputFormState inputFormController, RadioValue groupValue) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          _createRadioList(inputFormController, groupValue, RadioValue.income),
          _createRadioList(
              inputFormController, groupValue, RadioValue.spending),
        ],
      ),
    );
  }

  Widget _createRadioList(InputFormState inputFormController,
      RadioValue groupValue, RadioValue value) {
    String text = value == RadioValue.spending ? "支出" : "収入";

    return RadioListTile(
      title: Text(text),
      value: value,
      groupValue: groupValue,
      onChanged: (value) => _onRadioSelected(value, inputFormController),
    );
  }

  Widget _createTextFieldColumn() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _createItemTextField(),
          _createMoneyTextField(),
        ],
      ),
    );
  }

  Widget _createItemTextField() {
    return TextFormField(
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
        if (value!.isEmpty) {
          return "項目は必須入力項目です";
        }
        return null;
      },
      initialValue: _data["detail"].toString(),
    );
  }

  Widget _createMoneyTextField() {
    return TextFormField(
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
        if (value!.isEmpty) {
          return "金額は必須入力項目です";
        }
        return null;
      },
      initialValue: _data["cost"].toString(),
    );
  }

  Widget _createSaveIconButton(InputFormState inputFormController,
      BuildContext context, GlobalKey<FormState> formKey) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: ElevatedButton(
        child: const Text("登録"),
        onPressed: () {
          formKey.currentState?.save();
          _data["type"] =
              inputFormController.state == RadioValue.income ? 1 : 0;
          Navigator.of(context).pop<dynamic>();
        },
      ),
    );
  }

  void _onRadioSelected(value, InputFormState inputFormController) {
    inputFormController.changeState(value);
  }
}
