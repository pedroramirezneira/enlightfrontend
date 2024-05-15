import 'package:enlight/components/loading_indicator.dart';
import 'package:enlight/components/selectable_timeslot.dart';
import 'package:enlight/models/day_data.dart';
import 'package:enlight/models/subject_data.dart';
import 'package:enlight/pages/subject/day_index.dart';
import 'package:enlight/util/subject_ops.dart';
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
  late Future<SubjectData> data;
  late DateTime selectedDay;
  late DateTime focusedDay;
  late CalendarFormat calendarFormat;

  @override
  void initState() {
    super.initState();
    data = SubjectOps.getSubject(widget.id);
    selectedDay = DateTime.now();
    focusedDay = DateTime.now();
    calendarFormat = CalendarFormat.month;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                TableCalendar(
                  firstDay: DateTime(1900),
                  lastDay: DateTime.now().add(const Duration(days: 30)),
                  focusedDay: focusedDay,
                  selectedDayPredicate: (day) => day != selectedDay,
                  onDaySelected: (selectedDay, focusedDay) => setState(() {
                    this.selectedDay = selectedDay;
                    this.focusedDay = focusedDay;
                  }),
                  calendarFormat: calendarFormat,
                  onFormatChanged: (format) =>
                      setState(() => calendarFormat = format),
                ),
                () {
                  final DayData day = snapshot.data!.days.firstWhere(
                    (day) => day.name == DayIndex.getDay(selectedDay.weekday),
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
                  return Wrap(
                    children: snapshot.data!.days
                        .firstWhere(
                          (day) =>
                              day.name == DayIndex.getDay(selectedDay.weekday),
                        )
                        .timeslots
                        .map(
                          (timeslot) => SelectableTimeslot(
                            text: "${timeslot.startTime}-${timeslot.endTime}",
                            onPressed: () {},
                          ),
                        )
                        .toList(),
                  );
                }(),
              ],
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          return const LoadingIndicator(visible: true);
        },
      ),
    );
  }
}
