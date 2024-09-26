import 'package:flutter/material.dart';
import 'package:todo_list_hive/core/assets/assets.gen.dart';
import 'package:todo_list_hive/core/constants/app_colors.dart';
import 'package:todo_list_hive/core/constants/font_styles.dart';
import 'package:todo_list_hive/core/extensions/size_extension.dart';
import 'package:todo_list_hive/presentation/home/widgets/card_category.dart';
import 'package:todo_list_hive/presentation/home/widgets/card_date.dart';
import 'package:todo_list_hive/presentation/home/widgets/card_task.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        elevation: 0,
        onPressed: () {},
        backgroundColor: AppColors.primaryLight,
        child: const Icon(Icons.add),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.ws(context)),
        child: AppBar(
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: Text(
            'My ToDo',
            style: FontStyles.poppins.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          backgroundColor: AppColors.primary.withOpacity(0.3),
          flexibleSpace: Padding(
            padding: EdgeInsets.only(
              top: 23.ws(context),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  10.w,
                  CardDate(day: 'Mon', dd: 11),
                  CardDate(day: 'Mon', dd: 11),
                  CardDate(
                    day: 'Mon',
                    dd: 11,
                    status: true,
                  ),
                  CardDate(day: 'Mon', dd: 11),
                  CardDate(day: 'Mon', dd: 11),
                  CardDate(day: 'Mon', dd: 11),
                  CardDate(day: 'Mon', dd: 11),
                  CardDate(day: 'Mon', dd: 11),
                  CardDate(day: 'Mon', dd: 11),
                  CardDate(day: 'Mon', dd: 11),
                  CardDate(day: 'Mon', dd: 11),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CardCategory(
                  onTap: () {},
                  title: "All",
                  color: AppColors.primaryLight,
                ),
                CardCategory(
                  onTap: () {},
                  title: "Daily",
                  color: AppColors.greenLight,
                ),
                CardCategory(
                  onTap: () {},
                  title: "Overdue",
                  color: AppColors.yellowLight,
                ),
              ],
            ),
          ),
          10.h,
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              children: [
                CardTask(
                  task: "Helloo",
                ),
                CardTask(
                  task: "Helloo",
                ),
                CardTask(
                  task: "Helloo",
                ),
                CardTask(
                  task: "Helloo",
                ),
                CardTask(
                  task: "Helloo",
                ),
                CardTask(
                  task: "Helloo",
                ),
                CardTask(
                  task: "Helloo",
                ),
                CardTask(
                  task: "Helloo",
                ),
                CardTask(
                  task: "Helloo",
                ),
                CardTask(
                  task: "Helloo",
                ),
                CardTask(
                  task: "Helloo",
                ),
                CardTask(
                  task: "Helloo",
                ),
                CardTask(
                  task: "Helloo",
                ),
                CardTask(
                  task: "Helloo",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
