import 'dart:convert';
import 'dart:typed_data';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/components/enlight_confirm_picture_dialog.dart';
import 'package:enlight/components/enlight_loading_indicator.dart';
import 'package:enlight/components/enlight_picture_menu.dart';
import 'package:enlight/components/enlight_subject_menu.dart';
import 'package:enlight/models/account_data.dart';
import 'package:enlight/models/teacher_account_data.dart';
import 'package:enlight/pages/edit_account.dart';
import 'package:enlight/pages/edit_profile_teacher.dart';
import 'package:enlight/pages/sign_in.dart';
import 'package:enlight/util/account_ops.dart';
import 'package:enlight/util/teacher_ops.dart';
import 'package:enlight/util/token.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TeacherProfile extends StatefulWidget {
  const TeacherProfile({super.key});

  @override
  State<TeacherProfile> createState() => _TeacherProfileState();
}

class _TeacherProfileState extends State<TeacherProfile> {
  late Future<TeacherAccountData> data;
  var loading = true;
  var initialLoaded = false;
  Uint8List? selectedImage;

  @override
  void initState() {
    super.initState();
    data = TeacherOps.getTeacher();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                    data.then((value) {
                      Navigator.of(context)
                        ..pop()
                        ..push(MaterialPageRoute(
                          builder: (context) => EditAccount(
                            data: value as AccountData,
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
                  title: const Text("Edit profile"),
                  leading: const Icon(Icons.edit_rounded),
                  onTap: () {
                    Navigator.of(context)
                      ..pop()
                      ..push(MaterialPageRoute(
                        builder: (context) => EditTeacherProfile(
                          onUpdate: () {
                            setState(() {
                              data = TeacherOps.getTeacher();
                            });
                          },
                        ),
                      ));
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
            builder: ((context, snapshot) {
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
                return CustomScrollView(
                  slivers: [
                    const SliverAppBar(
                      title: Text("Profile"),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(100),
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) =>
                                              EnlightPictureMenu(
                                            selectFromGallery:
                                                selectFromGallery,
                                            takePhoto: takePhoto,
                                          ),
                                        );
                                      },
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: hasImage
                                            ? MemoryImage(decoded)
                                            : null,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 26),
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          snapshot.data!.name,
                                          style: const TextStyle(fontSize: 30),
                                        ),
                                        Text(
                                          "${snapshot.data!.teacher.rating}/10.0",
                                          style: const TextStyle(fontSize: 18),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Description:",
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data!.teacher.description,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    const Text(
                                      "Tags:",
                                      style: TextStyle(
                                        fontSize: 20,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  for (var tag
                                      in snapshot.data!.teacher.subjects)
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(20, 0, 20, 0),
                                          child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    255, 100, 201, 169),
                                                borderRadius:
                                                    BorderRadius.circular(24),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    tag.name,
                                                    style: const TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontSize: 20,
                                                      letterSpacing: 0,
                                                    ),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                8, 0, 0, 0),
                                                    child: Text(
                                                      "price: \$100",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 16,
                                                        letterSpacing: 0,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            8, 0, 0, 0),
                                                    child: Text(
                                                      tag.description,
                                                      style: const TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: 16,
                                                        letterSpacing: 0,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                ],
                                              )),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              if (snapshot.hasError) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {
                    loading = false;
                  });
                });
              }
              return const EnlightLoadingIndicator(visible: false);
            }),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showSubjectDialog,
            child: const Icon(
              Icons.add,
            ),
          ),
        ),
        EnlightLoadingIndicator(visible: loading),
      ],
    );
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
          builder: (context) => EnlightConfirmPictureDialog(
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
          builder: (context) => EnlightConfirmPictureDialog(
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

  void _showSubjectDialog() {
    data.then(
      (value) {
        showModalBottomSheet<int>(
          context: context,
          builder: (context) => EnlightSubjectMenu(
            categories: value.teacher.categories,
            onPressed: () {
              setState(() {
                loading = true;
              });
            },
          ),
        ).then((code) {
          setState(() {
            loading = false;
          });
          if (code == 200) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: AwesomeSnackbarContent(
                  title: "Success",
                  message: "Subject successfully created.",
                  contentType: ContentType.success,
                ),
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
        });
      },
    );
  }
}
