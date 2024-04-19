import 'dart:convert';
import 'dart:typed_data';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/components/confirm_picture_dialog.dart';
import 'package:enlight/components/picture_menu.dart';
import 'package:enlight/models/account_data.dart';
import 'package:enlight/pages/sign_in/sign_in.dart';
import 'package:enlight/util/account_ops.dart';
import 'package:enlight/util/token.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Messenger {
  static void showLogoutDialog({
    required BuildContext context,
    required void Function() onAccept,
    required void Function() onResponse,
  }) {
    showAdaptiveDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("OK"),
            ),
          ],
        );
      },
    ).then(
      (value) {
        if (value == false) {
          return;
        }
        onAccept();
        AccountOps.logout().then(
          (success) {
            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: AwesomeSnackbarContent(
                    title: "Success",
                    message: "You have successfully logged out.",
                    contentType: ContentType.success,
                  ),
                ),
              );
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const SignIn()),
                (route) => false,
              );
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Internal server error. Please try again."),
              ),
            );
            onResponse();
          },
        );
      },
    );
  }

  static void showDeleteAccountDialog({
    required BuildContext context,
    required void Function() onAccept,
    required void Function() onResponse,
  }) {
    showAdaptiveDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: const Text("Delete account"),
          content: const Text("Are you sure you want to delete your account?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("OK"),
            ),
          ],
        );
      },
    ).then(
      (value) {
        if (value == false) {
          return;
        }
        onAccept();
        AccountOps.delete().then(
          (success) {
            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: AwesomeSnackbarContent(
                    title: "Success",
                    message: "You have successfully deleted your account.",
                    contentType: ContentType.success,
                  ),
                ),
              );
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const SignIn()),
                (route) => false,
              );
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Internal server error. Please try again."),
              ),
            );
            onResponse();
          },
        );
      },
    );
  }

  static void showPictureMenu({
    required BuildContext context,
    required AccountData data,
    required void Function() onSubmit,
    required void Function() onResponse,
  }) {
    showModalBottomSheet<String>(
      context: context,
      builder: (context) => const PictureMenu(),
    ).then((value) async {
      if (value == null) {
        return;
      }
      Uint8List? selected;
      if (value == "select") {
        selected = await _selectFromGallery(context: context);
      }
      if (!context.mounted) {
        return;
      }
      if (value == "take") {
        selected = await _takePhoto(context: context);
      }
      if (selected == null || !context.mounted) {
        return;
      }
      showAdaptiveDialog<bool>(
        context: context,
        builder: (context) => ConfirmPictureDialog(bytes: selected!),
      ).then((value) {
        if (value == null || !value) {
          return;
        }
        onSubmit();
        _updatePicture(
          context: context,
          bytes: selected!,
          data: data,
          onResponse: onResponse,
        );
      });
    });
  }

  static Future<Uint8List?> _selectFromGallery({
    required BuildContext context,
  }) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    }
    final bytes = await image.readAsBytes();
    if (!context.mounted) {
      return null;
    }
    return bytes;
  }

  static Future<Uint8List?> _takePhoto({
    required BuildContext context,
  }) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) {
      return null;
    }
    final bytes = await image.readAsBytes();
    if (!context.mounted) {
      return null;
    }
    return bytes;
  }

  static void _updatePicture({
    required BuildContext context,
    required Uint8List bytes,
    required AccountData data,
    required void Function() onResponse,
  }) {
    final encoded = base64.encode(bytes);
    AccountOps.insertPicture(picture: encoded).then(
      (code) {
        if (code == 200) {
          data.picture = encoded;
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
            (_) => _updatePicture(
              context: context,
              bytes: bytes,
              data: data,
              onResponse: onResponse,
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
      },
    );
  }
}
