import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/components/enlight_app_bar.dart';
import 'package:enlight/components/enlight_loading_indicator.dart';
import 'package:enlight/models/student_profile_data.dart';
import 'package:enlight/pages/edit_account.dart';
import 'package:enlight/pages/edit_profile_teacher.dart';
import 'package:enlight/pages/sign_in.dart';
import 'package:enlight/util/account_ops.dart';
import 'package:flutter/material.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({super.key});

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  late final Future<StudentProfileData> data;
  var loading = false;

  @override
  void initState() {
    super.initState();
    data = AccountOps.getStudentProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: const EnlightAppBar(
            text: "Profile",
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
                    Navigator.of(context)
                      ..pop()
                      ..push(MaterialPageRoute(
                        builder: (context) => const EditAccount(),
                      ));
                  },
                ),
                ListTile(
                  title: const Text("Edit profile"),
                  leading: const Icon(Icons.edit_rounded),
                  onTap: () {
                    Navigator.of(context)
                      ..pop()
                      ..push(MaterialPageRoute(
                        builder: (context) => const EditTeacherProfile(),
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
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Stack(
                  children: [
                    Scaffold(
                      body: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                NetworkImage(snapshot.data!.picture),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            snapshot.data!.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              if (snapshot.hasError) {}
              return const EnlightLoadingIndicator(visible: true);
            },
          ),
        ),
        EnlightLoadingIndicator(visible: loading),
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
}
