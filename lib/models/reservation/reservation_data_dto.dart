// ignore_for_file: non_constant_identifier_names

import 'package:enlight/models/reservation/reservation_data.dart';
import 'package:flutter/material.dart';

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

  const ReservationDataDto({
    required this.reservation_id,
    required this.timeslot_id,
    required this.subject_name,
    required this.subject_id,
    required this.teacher_name,
    required this.teacher_id,
    required this.student_name,
    required this.student_id,
    required this.date,
    required this.start_time,
    required this.end_time,
  });

  factory ReservationDataDto.fromJson(Map<String, dynamic> json) {
    return ReservationDataDto(
      reservation_id: json['reservation_id'],
      timeslot_id: json['timeslot_id'],
      subject_name: json['subject_name'],
      subject_id: json['subject_id'],
      teacher_name: json['teacher_name'],
      teacher_id: json['teacher_id'],
      student_name: json['student_name'],
      student_id: json['student_id'],
      date: json['date'],
      start_time: json['start_time'],
      end_time: json['end_time'],
    );
  }

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
