import 'package:enlight/components/loading_indicator.dart';
import 'package:enlight/components/selectable_timeslot.dart';
import 'package:enlight/models/day_data.dart';
import 'package:enlight/models/subject_data.dart';
import 'package:enlight/models/timeslot_data.dart';
import 'package:enlight/pages/subject/util/reserve_timeslots.dart';
import 'package:enlight/pages/subject/util/weekday.dart';
import 'package:enlight/util/subject_ops.dart';
import 'package:enlight/util/token.dart';
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
  var loading = false;
  TimeslotData? selectedTimeslot;

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
      body: Stack(
        children: <Widget>[
          FutureBuilder(
            future: data,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TableCalendar(
                        firstDay: DateTime(1900),
                        lastDay: DateTime.now().add(const Duration(days: 30)),
                        focusedDay: focusedDay,
                        selectedDayPredicate: (day) => day == selectedDay,
                        onDaySelected: (selectedDay, focusedDay) =>
                            setState(() {
                          this.selectedDay = selectedDay;
                          this.focusedDay = focusedDay;
                        }),
                        calendarFormat: calendarFormat,
                        onFormatChanged: (format) =>
                            setState(() => calendarFormat = format),
                      ),
                      () {
                        final DayData day = snapshot.data!.days.firstWhere(
                          (day) =>
                              day.name == Weekday.getDay(selectedDay.weekday),
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
                              children: snapshot.data!.days
                                  .firstWhere(
                                    (day) =>
                                        day.name ==
                                        Weekday.getDay(selectedDay.weekday),
                                  )
                                  .timeslots
                                  .map(
                                    (timeslot) => SelectableTimeslot(
                                      text:
                                          "${timeslot.startTime.substring(0, 5)} - ${timeslot.endTime.substring(0, 5)}",
                                      onPressed: () => setState(() => selectedTimeslot = timeslot),
                                    ),
                                  )
                                  .toList(),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: SizedBox(
                                width: 500,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() => loading = true);
                                    reserveTimeslots(
                                      context: context,
                                      date: selectedDay.toIso8601String().split("T")[0],
                                      timeslotId: selectedTimeslot!.id,
                                      onResponse: () {
                                        setState(() => loading = false);
                                      }
                                    );
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
                );
              }
              if (snapshot.hasError) {
                if (snapshot.error == 401) {
                  Token.refreshAccessToken().then(
                    (_) => data = SubjectOps.getSubject(widget.id),
                  );
                  return const LoadingIndicator(visible: true);
                }
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              return const LoadingIndicator(visible: true);
            },
          ),
          LoadingIndicator(visible: loading)
        ],
      ),
    );
  }
}
