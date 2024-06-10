import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/components/rating_menu.dart';
import 'package:enlight/models/student_reservation_data.dart';
import 'package:enlight/util/student_ops.dart';
import 'package:flutter/material.dart';

void showRateMenu({
  required BuildContext context,
  required List<ReservationData> data,
  required int reservationId,
  required int teacherId,
}) {
  showModalBottomSheet<ReservationData>(
    useSafeArea: true,
    context: context,
    builder: (context) => RatingMenu(
      context: context,
      data: data,
      reservationId: reservationId,
      teacherId: teacherId,
      onPressed: _submit,
    ),
  );
}

void _submit({
  required BuildContext context,
  required List<ReservationData> data,
  required int reservationId,
  required int teacherId,
  required double rate,
}) {
  StudentOps.rateTeacher(
    reservationId,
    teacherId,
    rate,
  ).then((response) {
    if (response) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AwesomeSnackbarContent(
            title: "Success",
            message: "Successfully rated.",
            contentType: ContentType.success,
          ),
        ),
      );
      data.removeWhere(
                (element) => element.reservationId == reservationId);
    }
    if (!response) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AwesomeSnackbarContent(
            title: "Error",
            message: "The class is not completed yet.",
            contentType: ContentType.failure,
          ),
        ),
      );
    }
    Navigator.of(context).pop();
  }).catchError((error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AwesomeSnackbarContent(
          title: "Error",
          message: "Internal server error. Please try again.",
          contentType: ContentType.failure,
        ),
      ),
    );
  });
}
