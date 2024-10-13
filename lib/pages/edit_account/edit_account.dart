import 'package:enlight/components/form_submission_button.dart';
import 'package:enlight/components/loading_indicator.dart';
import 'package:enlight/components/enlight_text_field.dart';
import 'package:enlight/models/account/update_account_data.dart';
import 'package:enlight/services/account_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditAccount extends StatefulWidget {
  const EditAccount({
    super.key,
  });

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController nameController;
  late final TextEditingController birthdayController;
  late final TextEditingController addressController;
  var initialized = false;
  var loading = false;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    nameController = TextEditingController();
    birthdayController = TextEditingController();
    addressController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final accountService = Provider.of<AccountService>(context, listen: false);
    if (!initialized) {
      setState(() {
        nameController.text = accountService.data.name;
        birthdayController.text = accountService.data.birthday;
        addressController.text = accountService.data.address;
        initialized = true;
      });
    }

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text(
              "Account",
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: formKey,
                child: SizedBox(
                  width: 500,
                  child: Column(
                    children: <Widget>[
                      EnlightTextField(
                        text: "Name",
                        controller: nameController,
                      ),
                      EnlightTextField(
                        text: "Birthday",
                        controller: birthdayController,
                        date: true,
                      ),
                      EnlightTextField(
                        text: "Address",
                        controller: addressController,
                      ),
                      FormSubmissionButton(
                        text: "Save",
                        formKey: formKey,
                        onPressed: () async {
                          setState(() => loading = true);
                          final data = UpdateAccountData(
                            name: nameController.text,
                            birthday: birthdayController.text,
                            address: addressController.text,
                          );
                          final response =
                              await accountService.updateAccount(context, data);
                          if (!context.mounted) return;
                          setState(() => loading = false);
                          if (response.statusCode == 200) {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (loading) const LoadingIndicator(visible: true)
      ],
    );
  }
}
