import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/components/form_submission_button.dart';
import 'package:enlight/components/loading_indicator.dart';
import 'package:enlight/components/enlight_text_field.dart';
import 'package:enlight/models/teacher_account_data.dart';
import 'package:enlight/util/teacher_ops.dart';
import 'package:flutter/material.dart';

class EditTeacherProfile extends StatefulWidget {
  final Function()? onUpdate;

  const EditTeacherProfile({
    super.key,
    this.onUpdate,
  });

  @override
  State<EditTeacherProfile> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditTeacherProfile> {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController descriptionController;
  late Future<TeacherAccountData> data;
  late String encoded;
  var loading = true;
  var initialLoaded = false;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    data = TeacherOps.getTeacher();
    descriptionController = TextEditingController();
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
          body: FutureBuilder(
            future: data,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (!initialLoaded) {
                  descriptionController.text =
                      snapshot.data!.teacher.description;
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    setState(() {
                      loading = false;
                      initialLoaded = true;
                    });
                  });
                }
                return Center(
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
                              controller: descriptionController,
                            ),
                            FormSubmissionButton(
                              text: "Save",
                              formKey: formKey,
                              onPressed: save,
                            ),
                          ],
                        ),
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
              return const LoadingIndicator(visible: false);
            },
          ),
        ),
        LoadingIndicator(visible: loading),
      ],
    );
  }

  dynamic Function()? save() {
    setState(() {
      loading = true;
    });
    TeacherOps.updateTeacher(
      description: descriptionController.text,
    ).then((code) {
      if (code == 200) {
        widget.onUpdate != null ? widget.onUpdate!() : null;
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
