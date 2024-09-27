import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/font_styles.dart';
import '../../../core/extensions/size_extension.dart';

class CardCategory extends StatelessWidget {
  CardCategory({
    super.key,
    required this.onTap,
    required this.title,
    required this.color,
  });

  final Function() onTap;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          top: 3.ws(context),
          right: 2.5.ws(context),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
        ),
        child: Text(
          title,
          style: FontStyles.poppins.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
