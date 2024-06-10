import 'dart:convert';
import 'dart:typed_data';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/components/confirm_picture_dialog.dart';
import 'package:enlight/components/picture_menu.dart';
import 'package:enlight/models/account_data.dart';
import 'package:enlight/models/student_reservation_data.dart';
import 'package:enlight/models/teacher_data.dart';
import 'package:enlight/pages/sign_in/sign_in.dart';
import 'package:enlight/services/messaging_service.dart';
import 'package:enlight/services/reservation_service.dart';
import 'package:enlight/util/account_ops.dart';
import 'package:enlight/util/teacher_ops.dart';
import 'package:enlight/util/token.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

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
        if (value != true) {
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
              context.read<MessagingService>().chats = null;
              try {
                context.read<ReservationService>().reservations = null;
              } catch (error) {
                null;
              }
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
        if (value != true) {
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

  static void showDeleteSubjectDialog({
    required BuildContext context,
    required TeacherData data,
    required int subjectId,
    required void Function() onAccept,
    required void Function() onResponse,
  }) {
    showAdaptiveDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: const Text("Delete subject"),
          content: const Text("Are you sure you want to delete this subject?"),
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
        if (value != true) {
          return;
        }
        onAccept();
        TeacherOps.deleteSubject(id: subjectId).then(
          (success) {
            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: AwesomeSnackbarContent(
                    title: "Success",
                    message: "You have successfully deleted the subject.",
                    contentType: ContentType.success,
                  ),
                ),
              );
              data.subjects.removeWhere((element) => element.id == subjectId);
              onResponse();
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

  static void showCancelReservation({
    required BuildContext context,
    required int reservationId,
    required List<ReservationData> data,
    required void Function() onAccept,
    required void Function() onResponse,
  }) {
    showAdaptiveDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: const Text("Cancel reservation"),
          content:
              const Text("Are you sure you want to cancel this reservation?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Deny"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    ).then((value) {
      if (value != true) {
        return;
      }
      onAccept();
      AccountOps.cancelReservation(reservationId).then(
        (success) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: AwesomeSnackbarContent(
                  title: "Success",
                  message: "You have successfully canceled the reservation.",
                  contentType: ContentType.success,
                ),
              ),
            );
            data.removeWhere(
                (element) => element.reservationId == reservationId);
            onResponse();
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
    });
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
        selected = await _loadImage(
          context: context,
          source: ImageSource.gallery,
        );
      }
      if (!context.mounted) return;
      if (value == "take") {
        selected = await _loadImage(
          context: context,
          source: ImageSource.camera,
        );
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

  static Future<Uint8List?> _loadImage({
    required BuildContext context,
    required ImageSource source,
  }) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);
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
          data.picture = bytes;
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
        if (code == 401) {
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
