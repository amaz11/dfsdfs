import 'package:flutter/material.dart';
import 'package:trealapp/core/colors/colors.dart';

class InternetConnction extends StatelessWidget {
  const InternetConnction({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: whiteColor,
      body: Center(child: Text("No internet connection!")),
    );
  }
}
