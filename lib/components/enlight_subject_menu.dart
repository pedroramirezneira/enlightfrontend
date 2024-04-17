import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/components/enlight_form_submission_button.dart';
import 'package:enlight/components/enlight_text_form_field.dart';
import 'package:enlight/util/teacher_ops.dart';
import 'package:enlight/util/token.dart';
import 'package:flutter/material.dart';

class EnlightSubjectMenu extends StatefulWidget {
  final void Function()? onPressed;
  final void Function()? onResponse;

  const EnlightSubjectMenu({
    super.key,
    this.onPressed,
    this.onResponse,
  });

  @override
  State<EnlightSubjectMenu> createState() => _EnlightSubjectMenuState();
}

class _EnlightSubjectMenuState extends State<EnlightSubjectMenu> {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController categoryNameController;
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    categoryNameController = TextEditingController();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const Text(
              "Create subject",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  EnlightTextFormField(
                    text: "Category Name",
                    controller: categoryNameController,
                  ),
                  EnlightTextFormField(
                    text: "Name",
                    controller: nameController,
                  ),
                  EnlightTextFormField(
                    text: "Description",
                    controller: descriptionController,
                    description: true,
                  ),
                  EnlightFormSubmissionButton(
                    text: "Create",
                    formKey: formKey,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    widget.onPressed != null ? widget.onPressed!() : null;
    TeacherOps.createSubject(
      categoryName: categoryNameController.text,
      name: nameController.text,
      description: descriptionController.text,
    ).then((code) {
      if (code == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AwesomeSnackbarContent(
              title: "Success",
              message: "Subject created successfully.",
              contentType: ContentType.success,
            ),
          ),
        );
      }
      if (code == 401) {
        Token.refreshAccessToken().then((_) => _submit());
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
  }
}
