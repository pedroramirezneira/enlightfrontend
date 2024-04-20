import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/components/subject_menu.dart';
import 'package:enlight/models/subject_data.dart';
import 'package:enlight/models/teacher_data.dart';
import 'package:enlight/util/teacher_ops.dart';
import 'package:enlight/util/token.dart';
import 'package:flutter/material.dart';

void showSubjectMenu({
  required BuildContext context,
  required TeacherData data,
  required void Function() onResponse,
}) {
  showModalBottomSheet<SubjectData>(
    useSafeArea: true,
    isScrollControlled: true,
    context: context,
    builder: (context) => SubjectMenu(
      categories: data.categories,
      onPressed: _submit,
    ),
  ).then((subject) {
    if (subject == null) {
      return;
    }
    data.subjects.add(subject);
    onResponse();
  });
}

void _submit({
  required BuildContext context,
  required String categoryName,
  required String name,
  required String description,
  required int price,
  required List<String> days,
}) {
  TeacherOps.createSubject(
    categoryName: categoryName,
    name: name,
    description: description,
    price: price,
    days: days,
  ).then((response) {
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AwesomeSnackbarContent(
            title: "Success",
            message: "Subject successfully created.",
            contentType: ContentType.success,
          ),
        ),
      );
      Navigator.of(context).pop(
        SubjectData(
          id: int.parse(response.body),
          name: name,
          description: description,
          categoryName: categoryName,
          price: price,
        ),
      );
    }
    if (response.statusCode == 401) {
      Token.refreshAccessToken().then(
        (_) => _submit(
          context: context,
          categoryName: categoryName,
          name: name,
          description: description,
          price: price,
          days: days,
        ),
      );
      return;
    }
    if (response.statusCode == 500) {
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
  });
}
