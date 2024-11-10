import 'package:flutter/material.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';
import 'package:trealapp/module/auth/view/widget/form_widget.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: blueColor,
      drawer: null,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_headLine(), Expanded(child: FormWidget())],
      ),
    ));
  }

  Widget _headLine() {
    return Container(
      color: blueColor,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("TREAL", style: TextStyles.title32.copyWith(color: whiteColor)),
          Text("Simplify Your Workday, Track and Manage Effortlessly",
              style: TextStyles.regular16.copyWith(color: whiteColor)),
        ],
      ),
    );
  }
}
