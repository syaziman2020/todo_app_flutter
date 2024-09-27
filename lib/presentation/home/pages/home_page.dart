import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/font_styles.dart';
import '../../../core/extensions/size_extension.dart';
import '../widgets/card_category.dart';
import '../widgets/card_date.dart';
import '../widgets/card_task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedRemind = DateTime.now();
  DateTime selectedDateTime = DateTime.now();
  bool? repeat = false;
  late TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        elevation: 0,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setState) => AlertDialog(
                    backgroundColor: AppColors.white,
                    surfaceTintColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    title: Text(
                      'Add your Task',
                      style: FontStyles.poppins.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Task', style: FontStyles.poppins),
                        4.h,
                        TextFormField(
                          controller: controller,
                          maxLines: 4,
                          cursorColor: AppColors.primary,
                          keyboardType: TextInputType.text,
                          style: FontStyles.poppins.copyWith(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Input your task...',
                            hintStyle:
                                FontStyles.poppins.copyWith(fontSize: 14),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 126, 126, 126),
                                  width: 2,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 2,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                        20.h,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate:
                                        DateTime(DateTime.now().year + 100),
                                  ).then((selectedDate) {
                                    // After selecting the date, display the time picker.
                                    if (selectedDate != null) {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((selectedTime) {
                                        // Handle the selected date and time here.
                                        if (selectedTime != null) {
                                          selectedDateTime = DateTime(
                                            selectedDate.year,
                                            selectedDate.month,
                                            selectedDate.day,
                                            selectedTime.hour,
                                            selectedTime.minute,
                                          );
                                          print(
                                              selectedDateTime); // You can use the selectedDateTime as needed.
                                        }
                                      });
                                    }
                                  });
                                },
                                icon: const Icon(Icons.date_range)),
                            InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: selectedRemind,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(DateTime.now().year + 100),
                                ).then((selectedDate) {
                                  // After selecting the date, display the time picker.
                                  if (selectedDate != null) {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((selectedTime) {
                                      // Handle the selected date and time here.
                                      if (selectedTime != null) {
                                        selectedRemind = DateTime(
                                          selectedDate.year,
                                          selectedDate.month,
                                          selectedDate.day,
                                          selectedTime.hour,
                                          selectedTime.minute,
                                        );
                                        print(
                                            selectedRemind); // You can use the selectedDateTime as needed.
                                      }
                                    });
                                  }
                                });
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.notifications),
                                  3.w,
                                  Text(
                                    'Remind me',
                                    style: FontStyles.poppins,
                                  )
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.repeat_rounded),
                                SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Checkbox(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                    side: MaterialStateBorderSide.resolveWith(
                                      (states) => const BorderSide(
                                        width: 1.0,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    fillColor: MaterialStateProperty.all(
                                        AppColors.white),
                                    checkColor: AppColors.primary,
                                    value: repeat,
                                    onChanged: (val) {
                                      repeat = (val ?? false);
                                      setState(() {});
                                    },
                                  ),
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    actions: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: Color.fromARGB(255, 109, 109, 109),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ).copyWith(
                                overlayColor: MaterialStateProperty.all(
                                  Colors.transparent,
                                ), // Set splash color
                              ),
                              child: Text(
                                'Cancel',
                                style: FontStyles.poppins.copyWith(
                                  color: AppColors.black,
                                ),
                              ),
                            ),
                          ),
                          10.w,
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                selectedDateTime = DateTime.now();
                                selectedRemind = DateTime.now();
                                repeat = false;
                                controller.clear;
                                setState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ).copyWith(
                                overlayColor: MaterialStateProperty.all(
                                  Colors.transparent,
                                ), // Set splash color
                              ),
                              child: Text(
                                'Save',
                                style: FontStyles.poppins.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              });
        },
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
                  CardDate(day: 'Mon', dd: 11, status: true),
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
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
