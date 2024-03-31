import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/components/enlight_app_bar.dart';
import 'package:enlight/components/enlight_form_submission_button.dart';
import 'package:enlight/components/enlight_loading_indicator.dart';
import 'package:enlight/components/enlight_text_form_field.dart';
import 'package:enlight/models/account_data.dart';
import 'package:enlight/util/account_ops.dart';
import 'package:flutter/material.dart';

class EditAccount extends StatefulWidget {
  const EditAccount({super.key});

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController emailController;
  late final TextEditingController nameController;
  late final TextEditingController birthdayController;
  late final TextEditingController addressController;
  late Future<AccountData> data;
  var loading = true;
  var initialLoaded = false;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    data = AccountOps.getAccount();
    emailController = TextEditingController();
    nameController = TextEditingController();
    birthdayController = TextEditingController();
    addressController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: const EnlightAppBar(text: "Account"),
          body: FutureBuilder(
            future: data,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (!initialLoaded) {
                  emailController.text = snapshot.data!.email;
                  nameController.text = snapshot.data!.name;
                  birthdayController.text = snapshot.data!.birthday;
                  addressController.text = snapshot.data!.address;
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    setState(() {
                      loading = false;
                      initialLoaded = true;
                    });
                  });
                }
                return Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          EnlightTextFormField(
                            text: "Name",
                            controller: nameController,
                          ),
                          EnlightTextFormField(
                            text: "Birthday",
                            controller: birthdayController,
                            date: true,
                          ),
                          EnlightTextFormField(
                            text: "Address",
                            controller: addressController,
                          ),
                          EnlightFormSubmissionButton(
                            text: "Save",
                            formKey: formKey,
                            onPressed: _onPressed,
                          ),
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
                return Container(
                  padding: const EdgeInsets.all(15),
                  child: Center(
                    child: Text(
                      snapshot.error.toString(),
                    ),
                  ),
                );
              }
              return const EnlightLoadingIndicator(visible: false);
            },
          ),
        ),
        EnlightLoadingIndicator(visible: loading),
      ],
    );
  }

  dynamic Function()? _onPressed() {
    setState(() {
      loading = true;
    });
    AccountOps.updateAccount(
      name: nameController.text,
      birthday: birthdayController.text,
      address: addressController.text,
    ).then((code) {
      if (code == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AwesomeSnackbarContent(
              title: "Success",
              message: "Your account was successfully updated.",
              contentType: ContentType.success,
            ),
          ),
        );
        Navigator.of(context).pop();
      }
      if (code == 401) {
        // Logic to refresh access token once it has expired.
      }
      if (code == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AwesomeSnackbarContent(
              title: "Error",
              message: "Internal server error. Please try again.",
              contentType: ContentType.failure,
            ),
          ),
        );
      }
    });
    return null;
  }
}
