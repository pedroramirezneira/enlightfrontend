import 'package:enlight/components/fixed_scaffold.dart';
import 'package:enlight/models/account/account_data.dart';
import 'package:enlight/pages/edit_account/edit_account.dart';
import 'package:enlight/services/account_service.dart';
import 'package:enlight/util/messenger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentProfile extends StatelessWidget {
  const StudentProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountService>(context);
    if (account.loading) {
      return const FixedScaffold(
          title: "Account", body: CircularProgressIndicator.adaptive());
    }
    if (account.data is EmptyAccountData) {
      return const FixedScaffold(
        title: "Account",
        body: Text("An error occurred while loading your account."),
      );
    }
    final hasImage = account.data.picture != null;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Account",
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
      body: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(100),
                  onTap: () async {
                    Messenger.showPictureMenu(
                      context: context,
                      data: account.data,
                    );
                  },
                  child: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.surface.withOpacity(0.5),
                    radius: 100,
                    backgroundImage:
                        hasImage ? MemoryImage(account.data.picture!) : null,
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
                const SizedBox(height: 10),
                Text(
                  account.data.name,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
