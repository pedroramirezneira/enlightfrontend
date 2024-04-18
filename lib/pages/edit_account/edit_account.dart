import 'package:enlight/components/form_submission_button.dart';
import 'package:enlight/components/loading_indicator.dart';
import 'package:enlight/components/enlight_text_field.dart';
import 'package:enlight/models/account_data.dart';
import 'package:enlight/pages/edit_account/util/on_pressed.dart';
import 'package:flutter/material.dart';

class EditAccount extends StatefulWidget {
  final AccountData data;
  final void Function() onUpdate;

  const EditAccount({
    super.key,
    required this.data,
    required this.onUpdate,
  });

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController nameController;
  late final TextEditingController birthdayController;
  late final TextEditingController addressController;
  var loading = false;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    nameController = TextEditingController(text: widget.data.name);
    birthdayController = TextEditingController(text: widget.data.birthday);
    addressController = TextEditingController(text: widget.data.address);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
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
                        onPressed: () {
                          setState(() {
                            loading = true;
                          });
                          onPressed(
                            context: context,
                            name: nameController.text,
                            birthday: birthdayController.text,
                            address: addressController.text,
                            widget: widget,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        LoadingIndicator(visible: loading),
      ],
    );
  }
}
