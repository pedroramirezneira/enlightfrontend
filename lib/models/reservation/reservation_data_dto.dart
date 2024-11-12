import 'package:enlight/macros/data_class.dart';
import 'package:enlight/models/reservation/reservation_data.dart';
import 'package:flutter/material.dart';
import 'package:json/json.dart';

@DataClass()
@JsonCodable()
class ReservationDataDto {
  final int reservationId;
  final int timeslotId;
  final String subjectName;
  final int subjectId;
  final String teacherName;
  final int teacherId;
  final String studentName;
  final int studentId;
  final String date;
  final String startTime;
  final String endTime;

  ReservationData toData() {
    return ReservationData(
      reservationId: reservationId,
      timeslotId: timeslotId,
      subjectName: subjectName,
      subjectId: subjectId,
      teacherName: teacherName,
      teacherId: teacherId,
      studentName: studentName,
      studentId: studentId,
      date: DateTime.parse(date),
      startTime: _parseTimeOfDay(startTime),
      endTime: _parseTimeOfDay(endTime),
    );
  }
}

TimeOfDay _parseTimeOfDay(String time) {
  final parts = time.split(':');
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);
  return TimeOfDay(hour: hour, minute: minute);
}
