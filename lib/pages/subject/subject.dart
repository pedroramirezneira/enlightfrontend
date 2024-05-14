import 'package:enlight/components/selectable_timeslot.dart';
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
  late DateTime selectedDay;
  late DateTime focusedDay;
  late CalendarFormat calendarFormat;

  @override
  void initState() {
    super.initState();
    selectedDay = DateTime.now();
    focusedDay = DateTime.now();
    calendarFormat = CalendarFormat.month;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
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
          Wrap(
            children: [
              for (var i = 0; i < 5; i++)
                SelectableTimeslot(
                  text: "10:00 - 11:00",
                  onPressed: () {},
                ),
            ],
          )
        ],
      ),
    );
  }
}
