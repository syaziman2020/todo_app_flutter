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
    required this.color,
    required this.onTap,
    required this.onTapEdit,
    required this.onTapDelete,
  });

  final String task;
  final bool status;
  final Color color;
  final Function() onTap;
  final Function() onTapEdit;
  final Function() onTapDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.4.ws(context)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: color,
      ),
      child: ListTile(
        onTap: onTapEdit,
        contentPadding: const EdgeInsets.only(right: 0, left: 10),
        leading: Assets.images.task.image(
          width: 7.ws(context),
          fit: BoxFit.cover,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onTap,
              icon: Icon(
                (status) ? Icons.check_circle : Icons.radio_button_off,
                color: AppColors.primary,
              ),
            ),
            PopupMenuButton(
              color: AppColors.white,
              surfaceTintColor: AppColors.white,
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  onTap: onTapEdit,
                  child: Row(
                    children: [
                      const Icon(Icons.edit),
                      10.w,
                      Text(
                        'Edit',
                        style: FontStyles.poppins,
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  onTap: onTapDelete,
                  child: Row(
                    children: [
                      const Icon(Icons.delete),
                      10.w,
                      Text(
                        'Delete',
                        style: FontStyles.poppins,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        title: Text(
          task,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: FontStyles.poppins.copyWith(
            decoration:
                (status) ? TextDecoration.lineThrough : TextDecoration.none,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
