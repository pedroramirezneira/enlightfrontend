import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/components/enlight_dropdown_button.dart';
import 'package:enlight/components/enlight_form_submission_button.dart';
import 'package:enlight/components/enlight_loading_indicator.dart';
import 'package:enlight/components/enlight_text_form_field.dart';
import 'package:enlight/pages/sign_in.dart';
import 'package:enlight/util/account_ops.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController nameController;
  late final TextEditingController birthdayController;
  late final TextEditingController addressController;
  var loading = false;
  var dropdownValue = "Role";

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    birthdayController = TextEditingController();
    addressController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
            body: CustomScrollView(
          slivers: [
            const SliverAppBar(),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                          child: SizedBox(
                            width: 308,
                            height: 100,
                            child: Align(
                                alignment: const AlignmentDirectional(0, 0),
                                child: Text(
                                  'ENLIGHT',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.getFont(
                                    'Montserrat',
                                    color: const Color.fromARGB(
                                        255, 100, 201, 169),
                                    fontSize: 50,
                                  ),
                                )),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Form(
                          key: formKey,
                          child: SizedBox(
                            width: 500,
                            child: Column(
                              children: <Widget>[
                                EnlightTextFormField(
                                  text: "Email",
                                  controller: emailController,
                                  email: true,
                                ),
                                EnlightTextFormField(
                                  text: "Password",
                                  controller: passwordController,
                                  password: true,
                                ),
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
                                EnlightDropdownButton(
                                  value: dropdownValue,
                                  text: "Role",
                                  items: const <String>[
                                    "Student",
                                    "Teacher",
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      dropdownValue = value!;
                                    });
                                  },
                                ),
                                EnlightFormSubmissionButton(
                                  text: "Sign up",
                                  formKey: formKey,
                                  onPressed: _onPressed,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        )),
        EnlightLoadingIndicator(visible: loading),
      ],
    );
  }

  void _onPressed() {
    if (dropdownValue == "Role") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AwesomeSnackbarContent(
            title: "Watch out",
            message: "Role cannot be empty.",
            contentType: ContentType.help,
          ),
        ),
      );
      return;
    }
    setState(() {
      loading = true;
    });
    AccountOps.signUp(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
      birthday: birthdayController.text,
      address: addressController.text,
      role: dropdownValue.toLowerCase(),
    ).then((code) {
      setState(() {
        loading = false;
      });
      if (code == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AwesomeSnackbarContent(
              title: "Success",
              message: "Your account has been successfully created.",
              contentType: ContentType.success,
            ),
          ),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SignIn()),
          (route) => false,
        );
      }
      if (code == 409) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AwesomeSnackbarContent(
              title: "Warning",
              message: "This email is already in use.",
              contentType: ContentType.warning,
            ),
          ),
        );
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
  }
}
