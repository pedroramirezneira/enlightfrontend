import 'dart:convert';
import 'dart:typed_data';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/components/picture_menu.dart';
import 'package:enlight/components/confirm_picture_dialog.dart';
import 'package:enlight/components/loading_indicator.dart';
import 'package:enlight/models/account_data.dart';
import 'package:enlight/pages/edit_account/edit_account.dart';
import 'package:enlight/pages/sign_in/sign_in.dart';
import 'package:enlight/util/account_ops.dart';
import 'package:enlight/util/token.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({super.key});

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  late Future<AccountData> data;
  var loading = true;
  var initialLoaded = false;
  Uint8List? selectedImage;

  @override
  void initState() {
    super.initState();
    data = AccountOps.getAccounWithPicture();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text(
              "Profile",
            ),
          ),
          endDrawer: Drawer(
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  padding: EdgeInsets.zero,
                  child: ListTile(
                    leading: InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back),
                    ),
                    title: const Text("Settings"),
                  ),
                ),
                ListTile(
                  title: const Text("Edit account"),
                  leading: const Icon(Icons.edit_rounded),
                  onTap: () {
                    data.then((data) {
                      Navigator.of(context)
                        ..pop()
                        ..push(MaterialPageRoute(
                          builder: (context) => EditAccount(
                            data: data,
                            onUpdate: () {
                              setState(() {
                                data;
                              });
                            },
                          ),
                        ));
                    });
                  },
                ),
                ListTile(
                  title: const Text("Logout"),
                  leading: const Icon(Icons.logout),
                  onTap: () {
                    showAdaptiveDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog.adaptive(
                          title: const Text("Logout"),
                          content:
                              const Text("Are you sure you want to logout?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: _logout,
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  title: const Text("Delete account"),
                  leading: const Icon(Icons.delete_rounded),
                  onTap: () {
                    showAdaptiveDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog.adaptive(
                          title: const Text("Delete Account"),
                          content: const Text(
                              "Are you sure you want to delete the account?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: _deleteAccount,
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          body: FutureBuilder(
            future: data,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (!initialLoaded) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    setState(() {
                      loading = false;
                      initialLoaded = true;
                    });
                  });
                }
                final hasImage = snapshot.data!.picture != null;
                final decoded = base64.decode(snapshot.data!.picture ?? "");
                return Scaffold(
                  body: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(100),
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => PictureMenu(
                                  selectFromGallery: selectFromGallery,
                                  takePhoto: takePhoto,
                                ),
                              );
                            },
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withOpacity(0.5),
                              radius: 100,
                              backgroundImage:
                                  hasImage ? MemoryImage(decoded) : null,
                              child: !hasImage
                                  ? Text(
                                      snapshot.data!.name[0].toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 50,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            snapshot.data!.name,
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                );
              }
              if (snapshot.hasError) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {
                    loading = false;
                  });
                });
              }
              return const LoadingIndicator(visible: false);
            },
          ),
        ),
        LoadingIndicator(visible: loading),
      ],
    );
  }

  void Function()? _logout() {
    Navigator.of(context)
      ..pop()
      ..pop();
    setState(() {
      loading = true;
    });
    AccountOps.logout().then((success) {
      setState(() {
        loading = false;
      });
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
    });
    return null;
  }

  void Function()? _deleteAccount() {
    Navigator.of(context)
      ..pop()
      ..pop();
    setState(() {
      loading = true;
    });
    AccountOps.delete().then((success) {
      setState(() {
        loading = false;
      });
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
    });
    return null;
  }

  void selectFromGallery() {
    final picker = ImagePicker();
    picker.pickImage(source: ImageSource.gallery).then((image) {
      if (image == null) {
        Navigator.of(context).pop();
        return;
      }
      image.readAsBytes().then((bytes) {
        setState(() {
          selectedImage = bytes;
        });
        Navigator.of(context).pop();
        showAdaptiveDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => ConfirmPictureDialog(
            bytes: selectedImage!,
            onConfirm: updatePicture,
            onCancel: () {
              Navigator.of(context).pop();
              setState(() {
                selectedImage = null;
              });
            },
          ),
        );
      });
    });
  }

  void takePhoto() {
    final picker = ImagePicker();
    picker.pickImage(source: ImageSource.camera).then((image) {
      if (image == null) {
        Navigator.of(context).pop();
        return;
      }
      image.readAsBytes().then((bytes) {
        setState(() {
          selectedImage = bytes;
        });
        Navigator.of(context).pop();
        showAdaptiveDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => ConfirmPictureDialog(
            bytes: selectedImage!,
            onConfirm: updatePicture,
            onCancel: () {
              Navigator.of(context).pop();
              setState(() {
                selectedImage = null;
              });
            },
          ),
        );
      });
    });
  }

  void updatePicture() {
    Navigator.of(context).pop();
    setState(() {
      loading = true;
    });
    AccountOps.insertPicture(picture: base64.encode(selectedImage!))
        .then((code) {
      if (code == 200) {
        setState(() {
          loading = false;
          data.then((value) {
            value.picture = base64.encode(selectedImage!);
            selectedImage = null;
          });
        });
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
        Token.refreshAccessToken().then((_) => updatePicture());
      }
      if (code == 500) {
        setState(() {
          loading = false;
        });
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
}
