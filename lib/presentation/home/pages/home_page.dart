import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/font_styles.dart';
import '../../../core/extensions/size_extension.dart';
import '../../../data/models/task_model.dart';
import '../bloc/task_bloc.dart';
import '../widgets/card_category.dart';
import '../widgets/card_date.dart';
import '../widgets/card_task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    context.read<TaskBloc>().add(LoadAllTasks());

    super.initState();
  }

  void showDialogInput(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        bool? repeat = false;
        DateTime? selectedRemind;
        DateTime? selectedDateTime;
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 10),
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
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    controller: controller,
                    maxLines: 4,
                    cursorColor: AppColors.primary,
                    keyboardType: TextInputType.text,
                    style: FontStyles.poppins.copyWith(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Input your task...',
                      hintStyle: FontStyles.poppins.copyWith(fontSize: 14),
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
                ),
                20.h,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
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
                                selectedDateTime = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  selectedTime.hour,
                                  selectedTime.minute,
                                );
                                setState(() {});
                                if (kDebugMode) {
                                  print(selectedDateTime);
                                } // You can use the selectedDateTime as needed.
                              }
                            });
                          }
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.date_range),
                          8.w,
                          Text(
                            (selectedDateTime != null)
                                ? DateFormat('yyyy-MM-dd HH:mm:ss')
                                    .format(selectedDateTime ?? DateTime.now())
                                : "Set Datetime",
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
                            side: WidgetStateBorderSide.resolveWith(
                              (states) => const BorderSide(
                                width: 1.0,
                                color: AppColors.primary,
                              ),
                            ),
                            fillColor: WidgetStateProperty.all(AppColors.white),
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
                ),
                20.h,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
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
                                setState(() {});
                                if (kDebugMode) {
                                  print(selectedRemind);
                                } // You can use the selectedDateTime as needed.
                              }
                            });
                          }
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.notifications),
                          8.w,
                          Text(
                            (selectedRemind != null)
                                ? DateFormat('yyyy-MM-dd HH:mm:ss')
                                    .format(selectedRemind ?? DateTime.now())
                                : "Remind me",
                            style: FontStyles.poppins,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        controller.clear();
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
                        overlayColor: WidgetStateProperty.all(
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
                        if (controller.text.trim().isEmpty) {
                          snackBarCustom(
                              context, 'Task is empty, please input your task');
                        } else if (selectedDateTime == null) {
                          snackBarCustom(
                              context, 'Please select your datetime');
                        } else if (selectedDateTime!.isBefore(DateTime.now())) {
                          snackBarCustom(context,
                              'The selected date and time have passed. Please choose a valid time.');
                        } else if (selectedRemind != null &&
                            selectedRemind!.isBefore(DateTime.now())) {
                          snackBarCustom(context,
                              'The selected date and time have passed. Please choose a valid time.');
                        } else {
                          context.read<TaskBloc>().add(
                                AddTask(
                                  TaskModel(
                                    title: controller.text,
                                    dateTime: selectedDateTime,
                                    remind: selectedRemind,
                                    repeat: repeat ?? false,
                                  ),
                                ),
                              );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ).copyWith(
                        overlayColor: WidgetStateProperty.all(
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
      },
    );
  }

  void showDialogUpdate(
    BuildContext context,
    String task,
    String id, {
    bool? repeat,
    DateTime? selectedRemind,
    DateTime? selectedDateTime,
  }) {
    controller.text = task;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 10),
            backgroundColor: AppColors.white,
            surfaceTintColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            title: Text(
              'Edit your Task',
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
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    controller: controller,
                    maxLines: 4,
                    cursorColor: AppColors.primary,
                    keyboardType: TextInputType.text,
                    style: FontStyles.poppins.copyWith(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Input your task...',
                      hintStyle: FontStyles.poppins.copyWith(fontSize: 14),
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
                ),
                20.h,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
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
                                selectedDateTime = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  selectedTime.hour,
                                  selectedTime.minute,
                                );
                                setState(() {});
                                if (kDebugMode) {
                                  print(selectedDateTime);
                                } // You can use the selectedDateTime as needed.
                              }
                            });
                          }
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.date_range),
                          8.w,
                          Text(
                            (selectedDateTime != null)
                                ? DateFormat('yyyy-MM-dd HH:mm:ss')
                                    .format(selectedDateTime ?? DateTime.now())
                                : "Set Datetime",
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
                            side: WidgetStateBorderSide.resolveWith(
                              (states) => const BorderSide(
                                width: 1.0,
                                color: AppColors.primary,
                              ),
                            ),
                            fillColor: WidgetStateProperty.all(AppColors.white),
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
                ),
                20.h,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
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
                                setState(() {});
                                if (kDebugMode) {
                                  print(selectedRemind);
                                } // You can use the selectedDateTime as needed.
                              }
                            });
                          }
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.notifications),
                          8.w,
                          Text(
                            (selectedRemind != null)
                                ? DateFormat('yyyy-MM-dd HH:mm:ss')
                                    .format(selectedRemind ?? DateTime.now())
                                : "Remind me",
                            style: FontStyles.poppins,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        controller.clear();
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
                        overlayColor: WidgetStateProperty.all(
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
                        if (controller.text.trim().isEmpty) {
                          snackBarCustom(
                              context, 'Task is empty, please input your task');
                        } else if (selectedDateTime == null) {
                          snackBarCustom(
                              context, 'Please select your datetime');
                        } else {
                          context.read<TaskBloc>().add(
                                UpdateTaskAtIndex(
                                  TaskModel(
                                    uid: id,
                                    title: controller.text,
                                    dateTime: selectedDateTime,
                                    remind: selectedRemind,
                                    repeat: repeat!,
                                  ),
                                ),
                              );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ).copyWith(
                        overlayColor: WidgetStateProperty.all(
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
      },
    );
  }

  void snackBarCustom(BuildContext context, String message,
      {bool status = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor:
            status ? const Color.fromARGB(255, 0, 196, 23) : Colors.red,
        content: Text(
          message,
          style: FontStyles.poppins.copyWith(
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget header() {
    return PreferredSize(
      preferredSize: Size.fromHeight(45.ws(context)),
      child: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          'S-ToDo: Simple ToDo',
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
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                return Row(
                  children: [
                    10.w,
                    if (state is TaskLoaded) ...{
                      ...List.generate(10, (index) {
                        List<TaskModel?> tasks = state.tasks;
                        DateTime date =
                            DateTime.now().add(Duration(days: index));
                        String day = DateFormat('EEE').format(date);
                        int dd = date.day;
                        bool taskMatch = tasks.any((task) {
                          return task != null &&
                              task.dateTime != null &&
                              task.dateTime!.year == date.year &&
                              task.dateTime!.month == date.month &&
                              task.dateTime!.day == date.day &&
                              !task.status; // Status masih false
                        });
                        return CardDate(day: day, dd: dd, status: taskMatch);
                      }),
                    } else ...{
                      ...List.generate(10, (index) {
                        DateTime date =
                            DateTime.now().add(Duration(days: index));
                        String day = DateFormat('EEE').format(date);
                        int dd = date.day;
                        return CardDate(day: day, dd: dd, status: false);
                      }),
                    }
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        elevation: 0,
        onPressed: () {
          showDialogInput(context);
        },
        backgroundColor: AppColors.primaryLight,
        child: const Icon(Icons.add),
      ),
      appBar: header(),
      body: Column(
        children: [
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CardCategory(
                  onTap: () {
                    context.read<TaskBloc>().add(LoadAllTasks());
                  },
                  title: "All",
                  color: AppColors.primaryLight,
                ),
                CardCategory(
                  onTap: () {
                    context.read<TaskBloc>().add(DailyTasks());
                  },
                  title: "Daily",
                  color: AppColors.greenLight,
                ),
                CardCategory(
                  onTap: () {
                    context.read<TaskBloc>().add(OverdueTasks());
                  },
                  title: "Overdue",
                  color: AppColors.yellowLight,
                ),
              ],
            ),
          ),
          10.h,
          Expanded(
            child: BlocConsumer<TaskBloc, TaskState>(
              listener: (context, state) {
                if (state is TaskError) {
                  snackBarCustom(context, state.message);
                } else if (state is TaskAddedSuccess) {
                  controller.clear();
                  Navigator.pop(context);
                  snackBarCustom(context, "Task added", status: true);
                } else if (state is TaskUpdatedSuccess) {
                  controller.clear();
                  Navigator.pop(context);
                  snackBarCustom(context, "Task Updated", status: true);
                } else if (state is TaskDeletedSuccess) {
                  snackBarCustom(context, 'Task Deleted', status: true);
                }
              },
              builder: (context, state) {
                if (state is TaskLoaded) {
                  List<TaskModel?> tasks = state.tasks;
                  tasks.sort((a, b) {
                    if (a!.dateTime == null || b!.dateTime == null) {
                      return 0;
                    }
                    return b.dateTime!.compareTo(a.dateTime!);
                  });
                  List<TaskModel?> uncompletedTasks =
                      tasks.where((task) => task!.status == false).toList();
                  List<TaskModel?> completedTasks =
                      tasks.where((task) => task!.status == true).toList();
                  if (tasks.isNotEmpty) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: uncompletedTasks.length,
                              itemBuilder: (context, index) {
                                return CardTask(
                                  onTap: () {
                                    context.read<TaskBloc>().add(
                                        ChangeTaskAtIndex(
                                            uncompletedTasks[index]!.uid,
                                            !uncompletedTasks[index]!.status));
                                  },
                                  color: (uncompletedTasks[index]!.status)
                                      ? AppColors.primaryLight
                                      : (uncompletedTasks[index]!.dateTime !=
                                                  null &&
                                              uncompletedTasks[index]!
                                                  .dateTime!
                                                  .isBefore(DateTime.now()))
                                          ? AppColors.yellowLight
                                          : AppColors.primaryLight,
                                  task: uncompletedTasks[index]!.title,
                                  status: uncompletedTasks[index]!.status,
                                  onTapDelete: () {
                                    context.read<TaskBloc>().add(
                                        DeleteTaskAtIndex(
                                            uncompletedTasks[index]!.uid!));
                                  },
                                  onTapEdit: () {
                                    showDialogUpdate(
                                      context,
                                      uncompletedTasks[index]!.title,
                                      uncompletedTasks[index]!.uid!,
                                      repeat: uncompletedTasks[index]!.repeat,
                                      selectedDateTime:
                                          uncompletedTasks[index]!.dateTime,
                                      selectedRemind:
                                          uncompletedTasks[index]!.remind,
                                    );
                                  },
                                );
                              },
                            ),
                            if (completedTasks.isNotEmpty) ...{
                              Padding(
                                padding:
                                    EdgeInsets.only(bottom: 3.4.ws(context)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.expand_more),
                                    Text(
                                      'Done',
                                      style: FontStyles.poppins,
                                    ),
                                  ],
                                ),
                              ),
                            },
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: completedTasks.length,
                              itemBuilder: (context, index) {
                                return CardTask(
                                  color: (completedTasks[index]!.status)
                                      ? AppColors.primaryLight
                                      : (completedTasks[index]!.dateTime !=
                                                  null &&
                                              completedTasks[index]!
                                                  .dateTime!
                                                  .isBefore(DateTime.now()))
                                          ? AppColors.yellowLight
                                          : AppColors.primaryLight,
                                  onTap: () {
                                    context.read<TaskBloc>().add(
                                          ChangeTaskAtIndex(
                                              completedTasks[index]!.uid,
                                              !completedTasks[index]!.status),
                                        );
                                  },
                                  onTapEdit: () {
                                    showDialogUpdate(
                                      context,
                                      completedTasks[index]!.title,
                                      completedTasks[index]!.uid!,
                                      repeat: completedTasks[index]!.repeat,
                                      selectedDateTime:
                                          completedTasks[index]!.dateTime,
                                      selectedRemind:
                                          completedTasks[index]!.remind,
                                    );
                                  },
                                  onTapDelete: () {
                                    context.read<TaskBloc>().add(
                                        DeleteTaskAtIndex(
                                            completedTasks[index]!.uid!));
                                  },
                                  task: completedTasks[index]!.title,
                                  status: completedTasks[index]!.status,
                                );
                              },
                            ),
                          ]),
                    );
                  } else {
                    Center(
                      child: Text(
                        'Task Is Empty',
                        style: FontStyles.poppins.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }
                } else if (state is TaskListLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  );
                }
                return Center(
                  child: Text(
                    'Task Is Empty',
                    style: FontStyles.poppins.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
