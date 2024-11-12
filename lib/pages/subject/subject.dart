import 'package:enlight/components/loading_indicator.dart';
import 'package:enlight/components/selectable_timeslot.dart';
import 'package:enlight/models/day_data.dart';
import 'package:enlight/models/reservation/create_reservation_data.dart';
import 'package:enlight/models/subject_timeslot.dart';
import 'package:enlight/models/timeslot_data.dart';
import 'package:enlight/pages/subject/util/reserve_timeslots.dart';
import 'package:enlight/pages/subject/util/weekday.dart';
import 'package:enlight/services/subject_service.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Subject extends StatefulWidget {
  final int id;

  const Subject({
    super.key,
    required this.id,
  });

  @override
  State<Subject> createState() => _SubjectState();
}

class _SubjectState extends State<Subject> {
  SubjectTimeSlotData data = EmptySubjectTimeSlotData();
  late DateTime selectedDay;
  late DateTime focusedDay;
  late CalendarFormat calendarFormat;
  var loading = false;
  String selectedModality = "";
  TimeslotData? selectedTimeslot;

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now();
    focusedDay = DateTime.now();
    calendarFormat = CalendarFormat.month;
    _fetchData();
  }

  Future<void> _fetchData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final data = await SubjectService.getSubjectWithTimeslot(
        context,
        widget.id,
      );
      setState(() {
        this.data = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: () {
        if (data is EmptySubjectTimeSlotData || loading) {
          return const LoadingIndicator(visible: true);
        }
        return Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TableCalendar(
                    firstDay: DateTime(1900),
                    lastDay: DateTime.now().add(const Duration(days: 30)),
                    focusedDay: focusedDay,
                    selectedDayPredicate: (day) => day == selectedDay,
                    onDaySelected: (selectedDay, focusedDay) => setState(() {
                      this.selectedDay = selectedDay;
                      this.focusedDay = focusedDay;
                    }),
                    calendarFormat: calendarFormat,
                    onFormatChanged: (format) =>
                        setState(() => calendarFormat = format),
                  ),
                  () {
                    final DayData day = data.days.firstWhere(
                      (day) => day.name == Weekday.getDay(selectedDay.weekday),
                      orElse: () => DayData(
                        name: "Invalid",
                        timeslots: [],
                      ),
                    );
                    if (day.name == "Invalid") {
                      return const Visibility(
                        visible: false,
                        child: Placeholder(),
                      );
                    }
                    return Column(
                      children: [
                        Wrap(
                          children: data.days
                              .firstWhere(
                                (day) =>
                                    day.name ==
                                    Weekday.getDay(selectedDay.weekday),
                              )
                              .timeslots
                              .map(
                                (timeslot) => SelectableTimeslot(
                                  text:
                                      "${timeslot.start_time.substring(0, 5)} - ${timeslot.end_time.substring(0, 5)}",
                                  onPressed: () => setState(
                                      () => selectedTimeslot = timeslot),
                                ),
                              )
                              .toList(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Center(
                                child: Wrap(
                                  children: [
                                    if (data.modality == "both") ...[
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            selectedModality = "Online";
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              selectedModality == "Online"
                                                  ? const Color.fromARGB(
                                                      255, 100, 201, 169)
                                                  : const Color.fromARGB(
                                                      255, 43, 57, 68),
                                          maximumSize: const Size(150, 50),
                                        ),
                                        child: const Text("Online"),
                                      ),
                                      const SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            selectedModality = "Face-to-face";
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              selectedModality == "Face-to-face"
                                                  ? const Color.fromARGB(
                                                      255, 100, 201, 169)
                                                  : const Color.fromARGB(
                                                      255, 43, 57, 68),
                                          maximumSize: const Size(150, 50),
                                        ),
                                        child: const Text("Face-to-face"),
                                      ),
                                    ] else ...[
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            selectedModality = data.modality;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              selectedModality == data.modality
                                                  ? const Color.fromARGB(
                                                      255, 100, 201, 169)
                                                  : const Color.fromARGB(
                                                      255, 43, 57, 68),
                                          maximumSize: const Size(150, 50),
                                        ),
                                        child: Text(data.modality),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                "Max group size: ${data.size}",
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: SizedBox(
                            width: 500,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (selectedModality.isEmpty) {
                                  return;
                                }
                                setState(() => loading = true);
                                final data = CreateReservationData(
                                  timeslotId: selectedTimeslot!.id,
                                  date: selectedDay
                                      .toIso8601String()
                                      .split("T")[0],
                                  modality: selectedModality,
                                );
                                await reserveTimeslots(
                                  context: context,
                                  teacherId: this.data.teacherId,
                                  data: data,
                                );
                                setState(() => loading = false);
                              },
                              child: const Text("Reserve timeslots"),
                            ),
                          ),
                        ),
                      ],
                    );
                  }(),
                ],
              ),
            ),
            if (data is EmptySubjectTimeSlotData)
              const LoadingIndicator(visible: true)
          ],
        );
      }(),
    );
  }
}
