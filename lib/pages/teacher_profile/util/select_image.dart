import 'dart:typed_data';
import 'package:enlight/components/confirm_picture_dialog.dart';
import 'package:enlight/pages/teacher_profile/util/update_picture.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void selectFromGallery({
  required BuildContext context,
  required Function setLoading,
  required Function refreshPicture,
}) {
  Uint8List? selectedImage;
  final picker = ImagePicker();
  picker.pickImage(source: ImageSource.gallery).then((image) {
    if (image == null) {
      Navigator.of(context).pop();
      return;
    }
    image.readAsBytes().then((bytes) {
      selectedImage = bytes;
      Navigator.of(context).pop();
      showAdaptiveDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => ConfirmPictureDialog(
          bytes: selectedImage!,
          onConfirm: () => updatePicture(
              context: context,
              selectedImage: selectedImage!,
              setLoading: setLoading,
              refreshPicture: refreshPicture),
          onCancel: () {
            Navigator.of(context).pop();
            selectedImage = null;
          },
        ),
      );
    });
  });
}

void takePhoto({
  required BuildContext context,
  required Function setLoading,
  required Function refreshPicture,
}) {
  Uint8List? selectedImage;
  final picker = ImagePicker();
  picker.pickImage(source: ImageSource.camera).then((image) {
    if (image == null) {
      Navigator.of(context).pop();
      return;
    }
    image.readAsBytes().then((bytes) {
      selectedImage = bytes;
      Navigator.of(context).pop();
      showAdaptiveDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => ConfirmPictureDialog(
          bytes: selectedImage!,
          onConfirm: () => updatePicture(context: context, selectedImage: selectedImage!, setLoading: setLoading, refreshPicture: refreshPicture),
          onCancel: () {
            Navigator.of(context).pop();
            selectedImage = null;
          },
        ),
      );
    });
  });
}
