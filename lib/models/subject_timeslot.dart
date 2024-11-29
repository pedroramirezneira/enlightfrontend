import 'package:enlight/macros/data_class.dart';
import 'package:enlight/models/day_data.dart';
import 'package:json/json.dart';

@DataClass()
@JsonCodable()
class SubjectTimeSlotData {
  // ignore: non_constant_identifier_names
  final int teacher_id;
  final String modality;
  final int size;
  final int id;
  // ignore: non_constant_identifier_names
  String category_name;
  String name;
  String description;
  int price;
  List<DayData> days;
}

class EmptySubjectTimeSlotData extends SubjectTimeSlotData {
  EmptySubjectTimeSlotData()
      : super(
          id: -1,
          category_name: "",
          name: "",
          description: "",
          price: 0,
          days: [],
          teacher_id: -1,
          modality: "",
          size: -1,
        );
}
