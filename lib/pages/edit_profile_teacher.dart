import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/components/enlight_app_bar.dart';
import 'package:enlight/components/enlight_form_submission_button.dart';
import 'package:enlight/components/enlight_loading_indicator.dart';
import 'package:enlight/components/enlight_text_form_field.dart';
import 'package:enlight/models/teacher_profile_data.dart';
import 'package:enlight/util/account_ops.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EditTeacherProfile extends StatefulWidget {
  const EditTeacherProfile({super.key});

  @override
  State<EditTeacherProfile> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditTeacherProfile> {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController descriptionController;
  late final TextEditingController pictureController;
  late Future<TeacherProfileData> data;
  var loading = true;
  var initialLoaded = false;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    data = AccountOps.getProfile();
    descriptionController = TextEditingController();
    pictureController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: const EnlightAppBar(text: "Profile"),
          body: FutureBuilder(
            future: data,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (!initialLoaded) {
                  descriptionController.text = snapshot.data!.description;
                  pictureController.text = snapshot.data!.picture;
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    setState(() {
                      loading = false;
                      initialLoaded = true;
                    });
                  });
                }
                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: kIsWeb ? 400 : 15,
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          EnlightTextFormField(
                            text: "Description",
                            controller: descriptionController,
                          ),
                          EnlightTextFormField(
                            text: "Profile Picture",
                            controller: pictureController,
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
    AccountOps.updateProfile(
      description: descriptionController.text,
      picture: pictureController.text,
    ).then((code) {
      setState(() {
        loading = false;
      });
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