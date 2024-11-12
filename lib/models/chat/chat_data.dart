import 'package:enlight/macros/data_class.dart';
import 'package:enlight/models/account/account_data.dart';

@DataClass()
class ChatData {
  int newMessages = 0;
  final AccountData account;
}
