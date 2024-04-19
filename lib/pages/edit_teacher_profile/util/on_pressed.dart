import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/pages/edit_teacher_profile/edit_teacher_profile.dart';
import 'package:enlight/util/teacher_ops.dart';
import 'package:enlight/util/token.dart';
import 'package:flutter/material.dart';

void onPressed({
  required BuildContext context,
  required String description,
  required EditTeacherProfile widget,
  required void Function() onResponse,
}) {
  TeacherOps.updateTeacher(
    description: description,
  ).then(
    (code) {
      if (code == 200) {
        widget.data.description = description;
        widget.onUpdate();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AwesomeSnackbarContent(
              title: "Success",
              message: "Your account was successfully updated.",
              contentType: ContentType.success,
            ),
          ),
        );
        Navigator.of(context).pop();
      }
      if (code == 401) {
        Token.refreshAccessToken().then(
          (_) => onPressed(
            context: context,
            description: description,
            widget: widget,
            onResponse: onResponse,
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
