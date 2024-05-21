import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/util/student_ops.dart';
import 'package:flutter/material.dart';

void reserveTimeslots({
  required BuildContext context,
  required int timeslotId,
  required String date,
}) async {
  final response = await StudentOps.reserveTimeslot(timeslotId, date);
  if (!context.mounted) return;
  if (response == false) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AwesomeSnackbarContent(
          title: "Error",
          message: "Internal server error.",
          contentType: ContentType.failure,
        ),
      ),
    );
    return;
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: AwesomeSnackbarContent(
        title: "Success",
        message: "Successful reservation.",
        contentType: ContentType.success,
      ),
    ),
  );
}
