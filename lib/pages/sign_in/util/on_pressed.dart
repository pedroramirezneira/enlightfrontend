import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/pages/student_profile.dart';
import 'package:enlight/pages/teacher_profile.dart';
import 'package:enlight/util/account_ops.dart';
import 'package:enlight/util/io.dart';
import 'package:flutter/material.dart';

void onPressed({
  required BuildContext context,
  required String email,
  required String password,
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
        IO.getRole().then((value) {
          if (value == "student") {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const StudentProfile()),
              (route) => false,
            );
          }
          if (value == "teacher") {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const TeacherProfile()),
              (route) => false,
            );
          }
        });
      }
      if (code == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AwesomeSnackbarContent(
              title: "Warning",
              message: "Incorrect password. Please try again.",
              contentType: ContentType.warning,
            ),
          ),
        );
      }
      if (code == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AwesomeSnackbarContent(
              title: "Warning",
              message: "This email is not registered. Please try again.",
              contentType: ContentType.warning,
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
    },
  );
}
