import 'package:flutter/material.dart';
import 'package:todo_list_hive/core/constants/app_colors.dart';
import 'package:todo_list_hive/core/constants/font_styles.dart';
import 'package:todo_list_hive/core/extensions/size_extension.dart';

class CardDate extends StatelessWidget {
  const CardDate(
      {super.key, required this.day, required this.dd, this.status = false});

  final bool status;
  final String day;
  final int dd;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(
        right: 2.ws(context),
      ),
      color: (status)
          ? AppColors.primary.withOpacity(0.6)
          : AppColors.primary.withOpacity(0.2),
      child: Padding(
        padding: EdgeInsets.all(
          3.ws(context),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              day,
              style: FontStyles.poppins.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            Container(
              padding: EdgeInsets.all(3.ws(context)),
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$dd',
                style: FontStyles.poppins.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
