import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/pages/sign_in/sign_in.dart';
import 'package:enlight/util/account_ops.dart';
import 'package:flutter/material.dart';

void onPressed({
  required BuildContext context,
  required String email,
  required String password,
  required String name,
  required String birthday,
  required String address,
  required String? selectedValue,
  required void Function() onResponse,
}) {
  if (selectedValue == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AwesomeSnackbarContent(
          title: "Watch out",
          message: "Role cannot be empty.",
          contentType: ContentType.help,
        ),
      ),
    );
    onResponse();
    return;
  }
  AccountOps.signUp(
    email: email,
    password: password,
    name: name,
    birthday: birthday,
    address: address,
    role: selectedValue.toLowerCase(),
  ).then((code) {
    if (code == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AwesomeSnackbarContent(
            title: "Success",
            message: "Your account has been successfully created.",
            contentType: ContentType.success,
          ),
        ),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SignIn()),
        (route) => false,
      );
    }
    if (code == 409) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AwesomeSnackbarContent(
            title: "Warning",
            message: "This email is already in use.",
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
  });
}
