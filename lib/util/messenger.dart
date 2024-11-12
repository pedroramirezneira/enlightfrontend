import 'dart:typed_data';
import 'package:enlight/components/confirm_picture_dialog.dart';
import 'package:enlight/components/picture_menu.dart';
import 'package:enlight/models/account/account_data.dart';
import 'package:enlight/models/teacher/teacher_data.dart';
import 'package:enlight/services/account_service.dart';
import 'package:enlight/services/auth_service.dart';
import 'package:enlight/services/reservation_service.dart';
import 'package:enlight/services/teacher_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Messenger {
  static void showLogoutDialog({
    required BuildContext context,
  }) {
    showAdaptiveDialog<bool>(
      context: context,
      builder: (context) {
        final authService = AuthService.of(context);
        return AlertDialog.adaptive(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                authService.logout();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  static void showDeleteAccountDialog({
    required BuildContext context,
  }) {
    showAdaptiveDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: const Text("Delete account"),
          content: const Text("Are you sure you want to delete your account?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                AccountService.deleteAccount(context);
              },
              child: const Text("OK"),
            ),
          ],
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
        if (!context.mounted) return;
        final teacherService = Provider.of<TeacherService>(
          context,
          listen: false,
        );
        onAccept();
        teacherService.deleteSubject(context, subjectId);
        onResponse();
      },
    );
  }

  static void showCancelReservation({
    required BuildContext context,
    required int reservationId,
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
    ).then((value) async {
      if (value != true) {
        return;
      }
      onAccept();
      if (!context.mounted) return;
      final reservationService = Provider.of<ReservationService>(
        context,
        listen: false,
      );
      await reservationService.cancelReservation(context, reservationId);
      onResponse();
    });
  }

  static void showPictureMenu({
    required BuildContext context,
    required AccountData data,
  }) {
    showModalBottomSheet<String>(
      context: context,
      builder: (context) => const PictureMenu(),
    ).then((value) async {
      if (value == null) {
        return;
      }
      Uint8List? selected;
      if (!context.mounted) return;
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
        if (!context.mounted) return;
        _updatePicture(
          context: context,
          bytes: selected!,
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
  }) async {
    final accountService = Provider.of<AccountService>(context, listen: false);
    accountService.insertPicture(context, bytes);
  }
}
