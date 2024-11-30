class CreateReservationData {
  final int timeslotId;
  final String date;
  final String modality;

  const CreateReservationData({
    required this.timeslotId,
    required this.date,
    required this.modality,
  });

  Map<String, dynamic> toJson() {
    return {
      'timeslotId': timeslotId,
      'date': date,
      'modality': modality,
    };
  }
}
