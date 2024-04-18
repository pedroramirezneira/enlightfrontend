import 'package:enlight/components/enlight_text_field.dart';
import 'package:enlight/components/form_submission_button.dart';
import 'package:enlight/components/loading_indicator.dart';
import 'package:enlight/pages/sign_in/util/on_pressed.dart';
import 'package:enlight/pages/recover_password.dart';
import 'package:enlight/pages/sign_up/sign_up.dart';
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
                          EnlightTextField(
                            text: "Email",
                            controller: emailController,
                          ),
                          EnlightTextField(
                            text: "Password",
                            controller: passwordController,
                            password: true,
                          ),
                          FormSubmissionButton(
                            text: "Sign in",
                            formKey: formKey,
                            onPressed: () {
                              setState(() {
                                loading = true;
                              });
                              onPressed(
                                context: context,
                                email: emailController.text,
                                password: passwordController.text,
                                onResponse: () =>
                                    setState(() => loading = false),
                              );
                            },
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
        LoadingIndicator(visible: loading),
      ],
    );
  }
}
