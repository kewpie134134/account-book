import 'package:account_book/stores/payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 支払方法のリストを Provider で管理
final paymentItemListProvider = StateProvider<List>((ref) {
  return [];
});

class SettingPage extends ConsumerWidget {
  const SettingPage({Key? key}) : super(key: key);

  // 入力フォームを監視するための FormKey
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              child: ref.watch(paymentItemsProvider).when(
                data: (data) {
                  return Column(
                    children: <Widget>[
                      _createPaymentSettingTextField(
                          ref, data.toList()[0]["payment"]),
                      _createSettingConfirmButton(
                        _formKey,
                        context,
                        ref,
                      ),
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

  Widget _createPaymentSettingTextField(WidgetRef ref, List paymentItemsList) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        icon: Icon(Icons.payment),
        hintText: "支払方法編集",
        labelText: "Item Setting",
      ),
      onSaved: (value) {
        // Save 処理が走った時に処理
        ref.read(paymentItemListProvider.notifier).state =
            value.toString().split(",");
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "支払方法はカンマ(,)で区切って入力してください";
        }
        if (!RegExp(r"^[^,]").hasMatch(value)) {
          return "先頭文字はカンマ(,)以外を入力してください";
        }
        if (!RegExp(r"[^,]$").hasMatch(value)) {
          return "最後の文字はカンマ(,)以外を入力してください";
        }
        // 支払方法の区切り(,)をバリデーションする
        return null;
      },
      initialValue: paymentItemsList.join(","),
    );
  }

  Widget _createSettingConfirmButton(
    GlobalKey<FormState> formKey,
    BuildContext context,
    WidgetRef ref,
  ) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: ElevatedButton(
        child: const Text("保存"),
        onPressed: () async {
          // validate を実行
          if (formKey.currentState!.validate()) {
            formKey.currentState?.save(); // Form の onSaved 関数を実行する
            FirebaseFirestore.instance
                .collection("users")
                .doc("user1")
                .collection("payment")
                .doc("array")
                .set({
              "payment":
                  FieldValue.arrayUnion(ref.read(paymentItemListProvider))
            });
            // ついでに、input_form.dart の payment GET のロジックも修正したい
          }
        },
      ),
    );
  }
}
