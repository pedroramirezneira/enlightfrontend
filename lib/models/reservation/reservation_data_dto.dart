// ignore_for_file: non_constant_identifier_names

import 'package:enlight/macros/data_class.dart';
import 'package:enlight/models/reservation/reservation_data.dart';
import 'package:flutter/material.dart';
import 'package:json/json.dart';

@DataClass()
@JsonCodable()
class ReservationDataDto {
  final int reservation_id;
  final int timeslot_id;
  final String subject_name;
  final int subject_id;
  final String teacher_name;
  final int teacher_id;
  final String student_name;
  final int student_id;
  final String date;
  final String start_time;
  final String end_time;

  ReservationData toData() {
    return ReservationData(
      reservationId: reservation_id,
      timeslotId: timeslot_id,
      subjectName: subject_name,
      subjectId: subject_id,
      teacherName: teacher_name,
      teacherId: teacher_id,
      studentName: student_name,
      studentId: student_id,
      date: DateTime.parse(date),
      startTime: _parseTimeOfDay(start_time),
      endTime: _parseTimeOfDay(end_time),
    );
  }
}

TimeOfDay _parseTimeOfDay(String time) {
  final parts = time.split(':');
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);
  return TimeOfDay(hour: hour, minute: minute);
}
