import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/components/subject_menu.dart';
import 'package:enlight/models/teacher_data.dart';
import 'package:flutter/material.dart';

void showSubjectDialog({
  required BuildContext context,
  required TeacherData data,
  required void Function() onSubmit,
  required void Function() onResponse,
}) {
  showModalBottomSheet<int>(
    context: context,
    builder: (context) => SubjectMenu(
      onPressed: onSubmit,
      categories: data.categories,
      subjects: data.subjects,
    ),
  ).then((code) {
    if (code == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AwesomeSnackbarContent(
            title: "Success",
            message: "Subject successfully created.",
            contentType: ContentType.success,
          ),
        ),
      );
    }
    if (code == 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AwesomeSnackbarContent(
            title: "Error",
            message: "Internal server error.",
            contentType: ContentType.failure,
          ),
        ),
      );
    }
    onResponse();
  });
}
