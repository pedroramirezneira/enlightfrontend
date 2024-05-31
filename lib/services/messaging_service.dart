import 'package:enlight/models/account_data.dart';
import 'package:enlight/util/account_ops.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MessagingService extends ChangeNotifier {
  int newMessages = 0;

  late final Future<AccountData> _account;

  final _chat = FirebaseDatabase.instance.ref("chat");

  MessagingService() {
    _chat.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        print(data);
      }
    });
  }
}
