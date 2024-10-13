import 'package:enlight/components/form_submission_button.dart';
import 'package:enlight/components/loading_indicator.dart';
import 'package:enlight/components/enlight_text_field.dart';
import 'package:enlight/services/teacher_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditTeacherProfile extends StatefulWidget {
  const EditTeacherProfile({
    super.key,
  });

  @override
  State<EditTeacherProfile> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditTeacherProfile> {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController descriptionController;
  var loading = false;
  var initialized = false;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    descriptionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final teacherService = Provider.of<TeacherService>(context);
    if (!initialized) {
      setState(() {
        descriptionController.text = teacherService.data.description;
        initialized = true;
      });
    }
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
                        onPressed: () async {
                          setState(() => loading = true);
                          final response = await teacherService.updateTeacher(
                            context,
                            descriptionController.text,
                          );
                          setState(() => loading = false);
                          if (!context.mounted) return;
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
        LoadingIndicator(visible: loading),
      ],
    );
  }
}
