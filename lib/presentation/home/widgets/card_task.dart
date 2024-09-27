import 'package:flutter/material.dart';
import '../../../core/assets/assets.gen.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/font_styles.dart';
import '../../../core/extensions/size_extension.dart';

class CardTask extends StatelessWidget {
  const CardTask({
    super.key,
    this.status = false,
    required this.task,
  });

  final String task;
  final bool status;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.4.ws(context)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.greenLight,
      ),
      child: ListTile(
        leading: Assets.images.task.image(
          width: 7.ws(context),
          fit: BoxFit.cover,
        ),
        trailing: SizedBox(
          width: 10,
          child: Transform.scale(
            scale: 1.2,
            child: Radio(
              fillColor: MaterialStateProperty.all(AppColors.primary),
              value: status,
              groupValue: true,
              onChanged: (status) {},
            ),
          ),
        ),
        title: Text(
          task,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: FontStyles.poppins.copyWith(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
