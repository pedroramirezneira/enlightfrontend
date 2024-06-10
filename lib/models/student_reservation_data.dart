import 'package:flutter/material.dart';

class ReservationData {
  final int reservationId;
  final int timeslotId;
  final String subjectName;
  final int subjectId;
  final String teacherName;
  final int teacherId;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  ReservationData({
    required this.reservationId,
    required this.timeslotId,
    required this.subjectName,
    required this.subjectId,
    required this.teacherName,
    required this.teacherId,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  factory ReservationData.fromJson(Map<String, dynamic> json) {
    return ReservationData(
      reservationId: json['reservation_id'],
      timeslotId: json['timeslot_id'],
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

class EmptyReservationData implements ReservationData {
  @override
  DateTime get date => DateTime.now();

  @override
  TimeOfDay get endTime => TimeOfDay.now();

  @override
  int get reservationId => -1;

  @override
  TimeOfDay get startTime => TimeOfDay.now();

  @override
  int get subjectId => -1;

  @override
  String get subjectName => "";

  @override
  int get teacherId => -1;

  @override
  String get teacherName => "";

  @override
  int get timeslotId => -1;
}
