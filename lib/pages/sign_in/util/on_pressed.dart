import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/components/student_navigation_app.dart';
import 'package:enlight/components/teacher_navigation_app.dart';
import 'package:enlight/services/messaging_service.dart';
import 'package:enlight/services/notification_service.dart';
import 'package:enlight/services/reservation_service.dart';
import 'package:enlight/util/account_ops.dart';
import 'package:enlight/util/chat_ops.dart';
import 'package:enlight/util/io.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void onPressed({
  required BuildContext context,
  required String email,
  required String password,
  required void Function() onResponse,
}) {
  AccountOps.login(
    email: email,
    password: password,
  ).then(
    (code) {
      if (code == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AwesomeSnackbarContent(
              title: "Success",
              message: "You have successfully logged in.",
              contentType: ContentType.success,
            ),
          ),
        );
        try {
          context.read<MessagingService>().chats = ChatOps.getChats();
          context.read<ReservationService>().reservations =
              AccountOps.getReservation();
          NotificationService.start(context);
        } catch (error) {
          null;
        }
        IO.getRole().then((value) {
          if (value == "student") {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const StudentNavigationApp(),
              ),
              (route) => false,
            );
          }
          if (value == "teacher") {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const TeacherNavigationApp(),
              ),
              (route) => false,
            );
          }
        });
      }
      if (code == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AwesomeSnackbarContent(
              title: "Error",
              message: "Incorrect password or email. Please try again.",
              contentType: ContentType.failure,
            ),
          ),
        );
      }
      if (code == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AwesomeSnackbarContent(
              title: "Error",
              message: "Internal server error. Please try again.",
              contentType: ContentType.failure,
            ),
          ),
        );
      }
      onResponse();
    },
  );
}
