import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:day_picker/day_picker.dart';
import 'package:enlight/components/enlight_text_field.dart';
import 'package:enlight/components/form_submission_button.dart';
import 'package:enlight/models/timeslot_data.dart';
import 'package:enlight/models/timeslot_menu_data.dart';
import 'package:flutter/material.dart';

class TimeslotMenu extends StatefulWidget {
  final days = <DayInWeek>[
    DayInWeek("Mon", dayKey: "Monday"),
    DayInWeek("Tue", dayKey: "Tuesday"),
    DayInWeek("Wed", dayKey: "Wednesday"),
    DayInWeek("Thu", dayKey: "Thursday"),
    DayInWeek("Fri", dayKey: "Friday"),
    DayInWeek("Sat", dayKey: "Saturday"),
    DayInWeek("Sun", dayKey: "Sunday"),
  ];

  TimeslotMenu({super.key});

  @override
  State<TimeslotMenu> createState() => _TimeslotMenuState();
}

class _TimeslotMenuState extends State<TimeslotMenu> {
  late final GlobalKey<FormState> formKey;
  late final GlobalKey<ScaffoldMessengerState> messengerKey;
  late List<String> selectedDays;
  late final TextEditingController startTimeController;
  late final TextEditingController endTimeController;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    messengerKey = GlobalKey<ScaffoldMessengerState>();
    selectedDays = [];
    startTimeController = TextEditingController();
    endTimeController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: messengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Add timeslot",
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SelectWeekDays(
                      padding: 8,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      days: widget.days,
                      border: false,
                      selectedDaysFillColor:
                          const Color.fromARGB(255, 100, 201, 169),
                      boxDecoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          colors: [
                            Color.fromARGB(255, 43, 57, 68),
                            Color.fromARGB(255, 43, 57, 68)
                          ],
                          tileMode: TileMode.repeated,
                        ),
                      ),
                      onSelect: (values) {
                        setState(() {
                          selectedDays = values;
                        });
                      },
                    ),
                  ),
                  EnlightTextField(
                    text: "Start Time",
                    controller: startTimeController,
                    time: true,
                  ),
                  EnlightTextField(
                    text: "End Time",
                    controller: endTimeController,
                    time: true,
                  ),
                  FormSubmissionButton(
                    text: "Add",
                    formKey: formKey,
                    onPressed: () {
                      if (selectedDays.isEmpty) {
                        messengerKey.currentState!.showSnackBar(
                          const SnackBar(
                            content: AwesomeSnackbarContent(
                              title: "Watch out",
                              message: "Please select at least one day.",
                              contentType: ContentType.help,
                            ),
                          ),
                        );
                        return;
                      }
                      Navigator.of(context).pop(
                        TimeslotMenuData(
                          days: selectedDays,
                          timeslot: TimeslotData(
                            id: 0,
                            start_time: startTimeController.text,
                            end_time: endTimeController.text,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
