import 'package:enlight/macros/data_class.dart';

@DataClass()
class MessageData {
  final int senderId;
  final String message;
  final DateTime timestamp;
}
