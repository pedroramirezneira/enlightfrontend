import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/pages/edit_account/edit_account.dart';
import 'package:enlight/util/account_ops.dart';
import 'package:enlight/util/token.dart';
import 'package:flutter/material.dart';

void onPressed({
  required BuildContext context,
  required String name,
  required String birthday,
  required String address,
  required EditAccount widget,
  required void Function() onResponse,
}) {
  AccountOps.updateAccount(
    name: name,
    birthday: birthday,
    address: address,
  ).then((code) {
    onResponse();
    if (code == 200) {
      widget.data.name = name;
      widget.data.birthday = birthday;
      widget.data.address = address;
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
          name: name,
          birthday: birthday,
          address: address,
          widget: widget,
          onResponse: onResponse
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
  });
}
