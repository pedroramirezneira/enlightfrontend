import 'package:enlight/components/fixed_scaffold.dart';
import 'package:enlight/models/account/account_data.dart';
import 'package:enlight/models/teacher/teacher_data.dart';
import 'package:enlight/pages/edit_account/edit_account.dart';
import 'package:enlight/pages/edit_teacher_profile/edit_teacher_profile.dart';
import 'package:enlight/pages/teacher_profile/util/show_subject_dialog.dart';
import 'package:enlight/pages/teacher_profile/util/tags_container.dart';
import 'package:enlight/services/account_service.dart';
import 'package:enlight/services/teacher_service.dart';
import 'package:enlight/util/messenger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TeacherProfile extends StatefulWidget {
  const TeacherProfile({super.key});

  @override
  State<TeacherProfile> createState() => _TeacherProfileState();
}

class _TeacherProfileState extends State<TeacherProfile> {
  var loading = false;
  String stars(int rating) {
    var stars = "";
    for (var i = 0; i < rating; i += 2) {
      stars += "⭐";
    }
    return stars;
  }

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountService>(context);
    final teacher = Provider.of<TeacherService>(context);
    if (account.loading || teacher.loading) {
      return const FixedScaffold(
          title: "Account", body: CircularProgressIndicator.adaptive());
    }
    if (account.data is EmptyAccountData || teacher.data is EmptyTeacherData) {
      return const FixedScaffold(
        title: "Account",
        body: Text("An error occurred while loading your account."),
      );
    }
    final hasImage = account.data.picture != null;
    return Scaffold(
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
                  ..push(
                    MaterialPageRoute(
                      builder: (context) => const EditAccount(),
                    ),
                  );
              },
            ),
            ListTile(
              title: const Text("Edit profile"),
              leading: const Icon(Icons.edit_rounded),
              onTap: () {
                Navigator.of(context)
                  ..pop()
                  ..push(
                    MaterialPageRoute(
                      builder: (context) => const EditTeacherProfile(),
                    ),
                  );
              },
            ),
            ListTile(
              title: const Text("Logout"),
              leading: const Icon(Icons.logout),
              onTap: () {
                Messenger.showLogoutDialog(context: context);
              },
            ),
            ListTile(
              title: const Text("Delete account"),
              leading: const Icon(Icons.delete_rounded),
              onTap: () {
                Messenger.showDeleteAccountDialog(context: context);
              },
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text("Account"),
            floating: true,
            snap: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          InkWell(
                            borderRadius: BorderRadius.circular(100),
                            onTap: () {
                              Messenger.showPictureMenu(
                                context: context,
                                data: account.data,
                              );
                            },
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withOpacity(0.5),
                              radius: 50,
                              backgroundImage: hasImage
                                  ? MemoryImage(account.data.picture!)
                                  : null,
                              child: !hasImage
                                  ? Text(
                                      account.data.name[0].toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 50,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                          SizedBox(width: 24),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                account.data.name,
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(
                                stars(teacher.data.rating.toInt()),
                                style: const TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      const Text(
                        "Description:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        teacher.data.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Tags:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      for (var tag in teacher.data.subjects)
                        Column(
                          children: [
                            TagContainer(
                              name: tag.name,
                              description: tag.description,
                              price: tag.price,
                              deleteSubject: () {
                                Messenger.showDeleteSubjectDialog(
                                  context: context,
                                  data: teacher.data,
                                  subjectId: tag.id,
                                  onAccept: () =>
                                      setState(() => loading = true),
                                  onResponse: () {
                                    setState(() {
                                      loading = false;
                                    });
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showSubjectMenu(
            context: context,
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
