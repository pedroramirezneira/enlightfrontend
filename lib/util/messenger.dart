import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/pages/sign_in/sign_in.dart';
import 'package:enlight/util/account_ops.dart';
import 'package:flutter/material.dart';

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
}
