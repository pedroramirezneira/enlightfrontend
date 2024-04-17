import 'package:enlight/components/enlight_form_submission_button.dart';
import 'package:enlight/components/enlight_loading_indicator.dart';
import 'package:enlight/components/enlight_text_form_field.dart';
import 'package:enlight/util/teacher_ops.dart';
import 'package:enlight/util/token.dart';
import 'package:flutter/material.dart';

class EnlightSubjectMenu extends StatefulWidget {
  final void Function() onPressed;

  const EnlightSubjectMenu({
    super.key,
    required this.onPressed,
  });

  @override
  State<EnlightSubjectMenu> createState() => _EnlightSubjectMenuState();
}

class _EnlightSubjectMenuState extends State<EnlightSubjectMenu> {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController categoryNameController;
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  var loaded = false;

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
    !loaded
        ? WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            setState(() {
              loaded = true;
            });
            showModalBottomSheet<bool>(
              context: context,
              builder: (context) => buildForm(context),
            ).then((pressed) =>
                pressed == true ? _submit() : Navigator.of(context).pop(null));
          })
        : null;
    return const EnlightLoadingIndicator(visible: false);
  }

  void _submit() {
    widget.onPressed();
    TeacherOps.createSubject(
      categoryName: categoryNameController.text,
      name: nameController.text,
      description: descriptionController.text,
    ).then((code) {
      if (code == 200) {
        Navigator.of(context).pop(200);
      } else if (code == 401) {
        Token.refreshAccessToken().then((_) => _submit());
      } else if (code == 500) {
        Navigator.of(context).pop(500);
      } else {
        Navigator.of(context).pop(null);
      }
    });
  }

  Widget buildForm(BuildContext context) {
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
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
