import 'dart:convert';
import 'dart:typed_data';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/util/account_ops.dart';
import 'package:enlight/util/token.dart';
import 'package:flutter/material.dart';

void updatePicture({
  required BuildContext context,
  required Function setLoading,
  required Function refreshPicture,
  required Uint8List? selectedImage,
}) {
  Navigator.of(context).pop();
  setLoading(true);
  AccountOps.insertPicture(picture: base64.encode(selectedImage!)).then((code) {
    if (code == 200) {
      setLoading(false);
      refreshPicture(selectedImage: selectedImage);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AwesomeSnackbarContent(
            title: "Success",
            message: "Successful update.",
            contentType: ContentType.success,
          ),
        ),
      );
    }
    if (code == 400) {
      Token.refreshAccessToken().then(
          (_) => updatePicture(context: context, selectedImage: selectedImage, setLoading: setLoading, refreshPicture: refreshPicture));
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
  });
}
