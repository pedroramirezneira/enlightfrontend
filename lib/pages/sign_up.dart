import 'dart:convert';

import 'package:enlight/components/enlight_app_bar.dart';
import 'package:enlight/components/enlight_form_submission_button.dart';
import 'package:enlight/components/enlight_text_form_field.dart';
import 'package:enlight/env.dart';
import 'package:enlight/pages/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  late final TextEditingController birthDateController;
  late final TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    birthDateController = TextEditingController();
    addressController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EnlightAppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
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
                EnlightTextFormField(
                  text: "Name",
                  controller: nameController,
                ),
                EnlightTextFormField(
                  text: "Birth Date",
                  controller: birthDateController,
                ),
                EnlightTextFormField(
                  text: "Address",
                  controller: addressController,
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
    );
  }

  void Function()? _onPressed() {
    http
        .post(
      Uri.http(
        server,
        "/account",
      ),
      headers: Map.from({"Content-Type": "application/json"}),
      body: json.encode(
        {
          "email": emailController.text,
          "password": passwordController.text,
          "name": nameController.text,
          "birth_date": birthDateController.text,
          "address": addressController.text,
        },
      ),
    )
        .then((response) {
      if (response.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Internal server error. Please try again."),
          ),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account successfully created."),
          ),
        );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SignIn()),
        (route) => false,
      );
    });
    return null;
  }
}
