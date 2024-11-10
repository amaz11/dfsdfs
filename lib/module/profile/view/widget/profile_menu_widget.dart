import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trealapp/core/colors/colors.dart';
import 'package:trealapp/core/textStyle/custom_text.dart';

class ProfileMenuWidget extends StatelessWidget {
  final String value;
  final String title;
  final IconData? icon;
  final bool endIcon;
  final Color? textColor;

  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.endIcon = true,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: lightGrayColor2),
          const SizedBox(width: 30),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: lightGrayColor2, width: .5))),
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.regular14Thin400
                        .copyWith(color: lightGrayColor.withOpacity(0.8)),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    style: TextStyles.regular14.copyWith(color: grayColor),
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
