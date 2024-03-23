import 'dart:convert';
import 'package:enlight/components/enlight_app_bar.dart';
import 'package:enlight/components/enlight_dropdown_button.dart';
import 'package:enlight/components/enlight_form_submission_button.dart';
import 'package:enlight/components/enlight_loading_indicator.dart';
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
  var loading = false;
  var dropdownValue = "Role";

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
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: const EnlightAppBar(),
          body: Stack(
            children: <Widget>[
              Center(
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
                          password: true,
                        ),
                        EnlightTextFormField(
                          text: "Name",
                          controller: nameController,
                        ),
                        EnlightTextFormField(
                          text: "Birth Date",
                          controller: birthDateController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Birth Date cannot be empty.";
                            }
                            if (!RegExp(
                                    r'^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[01])$')
                                .hasMatch(value)) {
                              return "Invalid date.";
                            }
                            return null;
                          },
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
        ),
        EnlightLoadingIndicator(visible: loading),
      ],
    );
  }

  void Function()? _onPressed() {
    if (dropdownValue == "Role") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Role cannot be empty."),
        ),
      );
      return null;
    }
    setState(() {
      loading = true;
    });
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
          "role": dropdownValue.toLowerCase(),
        },
      ),
    )
        .then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account successfully created."),
          ),
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SignIn()),
          (route) => false,
        );
        return;
      }
      if (response.statusCode == 409) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email already in use."),
          ),
        );
        return;
      }
      if (response.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Internal server error. Please try again."),
          ),
        );
        return;
      }
    });
    return null;
  }
}
