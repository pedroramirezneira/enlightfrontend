import 'package:flutter/material.dart';

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

  const ReservationData({
    required this.reservationId,
    required this.timeslotId,
    required this.subjectName,
    required this.subjectId,
    required this.teacherName,
    required this.teacherId,
    required this.studentName,
    required this.studentId,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  factory ReservationData.fromJson(Map<String, dynamic> json) {
    return ReservationData(
      reservationId: json['reservation_id'],
      timeslotId: json['timeslot_id'],
      subjectName: json['subject_name'],
      subjectId: json['subject_id'],
      teacherName: json['teacher_name'],
      teacherId: json['teacher_id'],
      studentName: json['student_name'],
      studentId: json['student_id'],
      date: DateTime.parse(json['date']),
      startTime: _parseTimeOfDay(json['start_time']),
      endTime: _parseTimeOfDay(json['end_time']),
    );
  }
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

TimeOfDay _parseTimeOfDay(String time) {
  final parts = time.split(':');
  final hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);
  return TimeOfDay(hour: hour, minute: minute);
}
