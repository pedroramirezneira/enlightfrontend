import 'package:enlight/components/form_submission_button.dart';
import 'package:enlight/components/loading_indicator.dart';
import 'package:enlight/components/enlight_text_field.dart';
import 'package:enlight/models/teacher_data.dart';
import 'package:enlight/pages/edit_teacher_profile/util/on_pressed.dart';
import 'package:flutter/material.dart';

class EditTeacherProfile extends StatefulWidget {
  final TeacherData data;
  final void Function() onUpdate;

  const EditTeacherProfile({
    super.key,
    required this.data,
    required this.onUpdate,
  });

  @override
  State<EditTeacherProfile> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditTeacherProfile> {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController descriptionController;
  var loading = false;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    descriptionController =
        TextEditingController(text: widget.data.description);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: const Text(
              "Profile",
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
                        text: "Description",
                        description: true,
                        controller: descriptionController,
                      ),
                      FormSubmissionButton(
                        text: "Save",
                        formKey: formKey,
                        onPressed: () {
                          setState(() => loading = true);
                          onPressed(
                            context: context,
                            description: descriptionController.text,
                            widget: widget,
                            onResponse: () => setState(() => loading = false),
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
