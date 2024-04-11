import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/components/enlight_app_bar.dart';
import 'package:enlight/components/enlight_form_submission_button.dart';
import 'package:enlight/components/enlight_loading_indicator.dart';
import 'package:enlight/components/enlight_text_form_field.dart';
import 'package:enlight/models/account_data.dart';
import 'package:enlight/util/account_ops.dart';
import 'package:flutter/material.dart';

class EditAccount extends StatefulWidget {
  final AccountData data;
  final Function()? onUpdate;

  const EditAccount({
    super.key,
    required this.data,
    this.onUpdate,
  });

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController emailController;
  late final TextEditingController nameController;
  late final TextEditingController birthdayController;
  late final TextEditingController addressController;
  var loading = false;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    emailController = TextEditingController(text: widget.data.email);
    nameController = TextEditingController(text: widget.data.name);
    birthdayController = TextEditingController(text: widget.data.birthday);
    addressController = TextEditingController(text: widget.data.address);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: const EnlightAppBar(text: "Account"),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 15,
              ),
              child: Form(
                key: formKey,
                child: SizedBox(
                  width: 500,
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
            ),
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
        widget.onUpdate != null ? widget.onUpdate!() : null;
        widget.data.name = nameController.text;
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
