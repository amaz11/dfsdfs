import 'package:flutter/material.dart';

class SizedBoxHight extends StatelessWidget {
  final double? hieght;
  const SizedBoxHight({super.key, this.hieght = 10});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: hieght,
    );
  }
}
