import 'package:enlight/components/enlight_app_bar.dart';
import 'package:enlight/components/enlight_form_submission_button.dart';
import 'package:enlight/components/enlight_text_form_field.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EnlightAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                EnlightTextFormField(
                  text: "Email",
                  controller: emailController,
                ),
                EnlightTextFormField(
                  text: "Password",
                  controller: passwordController,
                ),
                EnlightFormSubmissionButton(
                  text: "Sign in",
                  formKey: formKey,
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const Placeholder()),
                      (route) => false,
                    );
                  },
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Forgot password?"),
                )
              ],
            ),
          ),
        ],
      ),
      persistentFooterButtons: <Widget>[
        Center(
          child: TextButton(
            onPressed: () {},
            child: const Text("Don't have an account? Sign up."),
          ),
        ),
      ],
    );
  }
}
