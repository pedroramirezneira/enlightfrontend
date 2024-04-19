import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/components/loading_indicator.dart';
import 'package:enlight/components/subject_menu.dart';
import 'package:enlight/models/account_data.dart';
import 'package:enlight/models/teacher_account_data.dart';
import 'package:enlight/pages/edit_account/edit_account.dart';
import 'package:enlight/pages/edit_teacher_profile/edit_teacher_profile.dart';
import 'package:enlight/pages/teacher_profile/util/tags_container.dart';
import 'package:enlight/util/messenger.dart';
import 'package:enlight/util/teacher_ops.dart';
import 'package:flutter/material.dart';

class TeacherProfile extends StatefulWidget {
  const TeacherProfile({super.key});

  @override
  State<TeacherProfile> createState() => _TeacherProfileState();
}

class _TeacherProfileState extends State<TeacherProfile> {
  late Future<TeacherAccountData> data;
  var loading = true;
  var initialLoaded = false;

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
                    data.then((data) {
                      Navigator.of(context)
                        ..pop()
                        ..push(
                          MaterialPageRoute(
                            builder: (context) => EditAccount(
                              data: data as AccountData,
                              onUpdate: () => setState(() => data),
                            ),
                          ),
                        );
                    });
                  },
                ),
                ListTile(
                  title: const Text("Edit profile"),
                  leading: const Icon(Icons.edit_rounded),
                  onTap: () {
                    data.then((data) {
                      Navigator.of(context)
                        ..pop()
                        ..push(
                          MaterialPageRoute(
                            builder: (context) => EditTeacherProfile(
                              data: data.teacher,
                              onUpdate: () => setState(() => data),
                            ),
                          ),
                        );
                    });
                  },
                ),
                ListTile(
                  title: const Text("Logout"),
                  leading: const Icon(Icons.logout),
                  onTap: () {
                    Messenger.showLogoutDialog(
                      context: context,
                      onAccept: () => setState(() => loading = true),
                      onResponse: () => setState(() => loading = false),
                    );
                  },
                ),
                ListTile(
                  title: const Text("Delete account"),
                  leading: const Icon(Icons.delete_rounded),
                  onTap: () {
                    Messenger.showDeleteAccountDialog(
                      context: context,
                      onAccept: () => setState(() => loading = true),
                      onResponse: () => setState(() => loading = false),
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
                                        data.then((data) {
                                          Messenger.showPictureMenu(
                                            context: context,
                                            data: data,
                                            onSubmit: () =>
                                                setState(() => loading = true),
                                            onResponse: () {
                                              setState(() {
                                                loading = false;
                                                data.picture;
                                              });
                                            },
                                          );
                                        });
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
                                    height: 10,
                                  ),
                                  for (var tag
                                      in snapshot.data!.teacher.subjects)
                                    Column(
                                      children: [
                                        TagContainer(
                                            name: tag.name,
                                            description: tag.description,
                                            price: tag.price),
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
              return const LoadingIndicator(visible: false);
            }),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showSubjectDialog,
            child: const Icon(
              Icons.add,
            ),
          ),
        ),
        LoadingIndicator(visible: loading),
      ],
    );
  }

  void _showSubjectDialog() {
    data.then(
      (value) {
        showModalBottomSheet<int>(
          context: context,
          builder: (context) => SubjectMenu(
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
