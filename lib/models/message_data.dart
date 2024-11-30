// ignore_for_file: non_constant_identifier_names

import 'package:enlight/macros/data_class.dart';
import 'package:json/json.dart';

@DataClass()
@JsonCodable()
class MessageData {
  final int sender_id;
  final String message;
  final String timestamp;
}
