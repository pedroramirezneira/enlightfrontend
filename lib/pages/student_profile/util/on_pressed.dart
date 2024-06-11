import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/models/student_reservation_data.dart';
import 'package:enlight/pages/student_profile/util/show_subject_dialog.dart';
import 'package:enlight/util/student_ops.dart';
import 'package:flutter/material.dart';

Future<void> onPressed({
  required BuildContext context,
  required List<ReservationData> data,
  required int reservationId,
  required int teacherId,
}) async {
  if (await StudentOps.completeReservation(reservationId)) {
    if (!context.mounted) return;
    showRateMenu(
      data: data,
      context: context,
      reservationId: reservationId,
      teacherId: teacherId,
    );
  } else {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AwesomeSnackbarContent(
          title: "Error",
          message: "Class is not completed yet.",
          contentType: ContentType.failure,
        ),
      ),
    );
  }
}
