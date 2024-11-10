import 'package:flutter/material.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';

class AddExpenseScreen extends StatelessWidget {
  const AddExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Apply for Leave",
              style: TextStyles.title16.copyWith(color: grayColor)),
          shadowColor: Colors.black26,
          // elevation: 1,
          backgroundColor: Colors.white,
        ),
        body: const Center(child: Text("Add Expense")));
  }
}
