import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/components/enlight_form_submission_button.dart';
import 'package:enlight/components/enlight_loading_indicator.dart';
import 'package:enlight/components/enlight_text_form_field.dart';
import 'package:enlight/pages/student_profile.dart';
import 'package:enlight/pages/teacher_profile/teacher_profile_page.dart';
import 'package:enlight/pages/recover_password.dart';
import 'package:enlight/pages/sign_up.dart';
import 'package:enlight/util/account_ops.dart';
import 'package:enlight/util/io.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  var loading = false;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              top: true,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: const AlignmentDirectional(0.0, 0.0),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 40.0, 0.0, 0.0),
                      child: SizedBox(
                        width: 308.0,
                        height: 100.0,
                        child: Align(
                          alignment: const AlignmentDirectional(0.0, 0.0),
                          child: Text(
                            'ENLIGHT',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.getFont(
                              'Montserrat',
                              color: const Color.fromARGB(255, 100, 201, 169),
                              fontSize: 50.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Form(
                    key: formKey,
                    child: SizedBox(
                      width: 350.0,
                      height: 556.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(-1.0, -1.0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10.0, 10.0, 0.0, 0.0),
                              child: Text(
                                'Welcome Back!',
                                style: GoogleFonts.getFont(
                                  'Montserrat',
                                  fontSize: 25.0,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: const AlignmentDirectional(-1.0, 0.0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10.0, 10.0, 0.0, 0.0),
                              child: Text(
                                'Fill the information below to access your account',
                                style: GoogleFonts.getFont(
                                  'Montserrat',
                                  letterSpacing: 0.0,
                                ),
                              ),
                            ),
                          ),
                          EnlightTextFormField(
                            text: "Email",
                            controller: emailController,
                          ),
                          EnlightTextFormField(
                            text: "Password",
                            controller: passwordController,
                            password: true,
                          ),
                          EnlightFormSubmissionButton(
                            text: "Sign in",
                            formKey: formKey,
                            onPressed: _onPressed,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) =>
                                      const PasswordRecoveryPage())));
                            },
                            child: const Text("Forgot password?"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          persistentFooterButtons: <Widget>[
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const SignUp()));
                },
                child: const Text("Don't have an account? Sign up."),
              ),
            ),
          ],
        ),
        EnlightLoadingIndicator(visible: loading),
      ],
    );
  }

  void _onPressed() {
    setState(() {
      loading = true;
    });
    AccountOps.login(
      email: emailController.text,
      password: passwordController.text,
    ).then(
      (code) {
        setState(() {
          loading = false;
        });
        if (code == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: AwesomeSnackbarContent(
                title: "Success",
                message: "You have successfully logged in.",
                contentType: ContentType.success,
              ),
            ),
          );
          IO.getRole().then((value) {
            if (value == "student") {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const StudentProfile()),
                (route) => false,
              );
            }
            if (value == "teacher") {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const TeacherProfile()),
                (route) => false,
              );
            }
          });
        }
        if (code == 401) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: AwesomeSnackbarContent(
                title: "Warning",
                message: "Incorrect password. Please try again.",
                contentType: ContentType.warning,
              ),
            ),
          );
        }
        if (code == 404) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: AwesomeSnackbarContent(
                title: "Warning",
                message: "This email is not registered. Please try again.",
                contentType: ContentType.warning,
              ),
            ),
          );
        }
        if (code == 500) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Internal server error. Please try again."),
            ),
          );
        }
      },
    );
  }
}
