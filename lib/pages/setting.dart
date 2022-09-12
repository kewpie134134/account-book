import 'package:account_book/stores/payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingPage extends ConsumerWidget {
  SettingPage({Key? key}) : super(key: key);

  // 入力フォームを監視するための FormKey
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref, [bool mounted = true]) {
    final paymentItems = ref.watch(paymentItemsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("設定"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: paymentItems.when(
                data: (data) {
                  return Column(
                    children: <Widget>[
                      _createPaymentSettingTextField(data),
                      _createSettingConfirmButton(_formKey, context, mounted),
                    ],
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _createPaymentSettingTextField(Iterable<dynamic> data) {
    final String initialValue = data.toList()[0]["payment"].join(",");

    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        icon: Icon(Icons.payment),
        hintText: "支払方法編集",
        labelText: "Item Setting",
      ),
      onSaved: (value) {
        // Save 処理が走った時に処理
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "支払方法を入力してください";
        }
        // 支払方法の区切り(,)をバリデーションする
        return null;
      },
      initialValue: initialValue,
    );
  }

  _createSettingConfirmButton(
    GlobalKey<FormState> formKey,
    BuildContext context,
    bool mounted,
  ) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: ElevatedButton(
        child: const Text("保存"),
        onPressed: () async {
          // validate を実行
          if (formKey.currentState!.validate()) {
            formKey.currentState?.save(); // Form の onSaved 関数を実行する
            await FirebaseFirestore.instance
                .collection("users")
                .doc("user1")
                .collection("payment")
                .doc("array");
            // .set(data);
            // payment の値を配列の形でセットして Firestore に PUT したい
            // その際、riverpod 経由でできるとよいかも。
            // ついでに、input_form.dart の payment GET のロジックも修正したい
          }
        },
      ),
    );
  }
}
