import 'dart:convert';
import 'dart:typed_data';
import 'package:enlight/components/loading_indicator.dart';
import 'package:enlight/models/account_data.dart';
import 'package:enlight/pages/edit_account/edit_account.dart';
import 'package:enlight/util/account_ops.dart';
import 'package:enlight/util/messenger.dart';
import 'package:flutter/material.dart';

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
                        ..push(
                          MaterialPageRoute(
                            builder: (context) => EditAccount(
                              data: data,
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
}
