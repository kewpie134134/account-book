import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({Key? key}) : super(key: key);

  @override
  State<CustomDatePicker> createState() => _ChangeFormState();
}

class _ChangeFormState extends State<CustomDatePicker> {
  DateTime _date = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      locale: const Locale("ja"),
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );
    setState(() => _date = picked!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: <Widget>[
            Center(
              child: Text(DateFormat("yyyy/MM/dd").format(_date)),
            ),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Text('日付選択'),
            )
          ],
        ));
  }
}
