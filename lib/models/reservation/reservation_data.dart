import 'package:enlight/macros/data_class.dart';
import 'package:flutter/material.dart';

@DataClass()
class ReservationData {
  final int reservationId;
  final int timeslotId;
  final String subjectName;
  final int subjectId;
  final String teacherName;
  final int teacherId;
  final String studentName;
  final int studentId;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
}

class EmptyReservationData extends ReservationData {
  EmptyReservationData()
      : super(
          reservationId: -1,
          timeslotId: -1,
          subjectName: '',
          subjectId: -1,
          teacherName: '',
          teacherId: -1,
          studentName: '',
          studentId: -1,
          date: DateTime.now(),
          startTime: TimeOfDay.now(),
          endTime: TimeOfDay.now(),
        );
}
