// ignore_for_file: non_constant_identifier_names

class CreateReservationData {
  final int timeslot_id;
  final String date;
  final String modality;

  const CreateReservationData({
    required this.timeslot_id,
    required this.date,
    required this.modality,
  });

  Map<String, dynamic> toJson() {
    return {
      'timeslot_id': timeslot_id,
      'date': date,
      'modality': modality,
    };
  }
}
