import 'package:flutter/material.dart';

class StudentReservationData {
  final String subjectName;
  final int subjectId;
  final String teacherName;
  final int teacherId;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  StudentReservationData({
    required this.subjectName,
    required this.subjectId,
    required this.teacherName,
    required this.teacherId,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  factory StudentReservationData.fromJson(Map<String, dynamic> json) {
    return StudentReservationData(
      subjectName: json['name_subject'],
      subjectId: json['subject_id'],
      teacherName: json['name_teacher'],
      teacherId: json['teacher_id'],
      date: DateTime.parse(json['date']),
      startTime: _parseTimeOfDay(json['start_time']),
      endTime: _parseTimeOfDay(json['end_time']),
    );
  }

  static TimeOfDay _parseTimeOfDay(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }
}
