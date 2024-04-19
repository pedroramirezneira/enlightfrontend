import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/util/account_ops.dart';
import 'package:flutter/material.dart';

void onPressed({
  required BuildContext context,
  required String email,
  required void Function() onResponse,
}) {
  AccountOps.requestPasswordReset(email: email).then(
    (code) {
      if (code == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AwesomeSnackbarContent(
              title: "Success",
              message: "A recovery email has ben sent.",
              contentType: ContentType.success,
            ),
          ),
        );
        Navigator.of(context).pop();
      }
      if (code == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AwesomeSnackbarContent(
              title: "Warning",
              message: "Email does not exist. Please try again.",
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
      onResponse();
    },
  );
}
