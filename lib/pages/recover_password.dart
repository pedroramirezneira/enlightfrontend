import 'dart:convert';

import 'package:enlight/components/enlight_form_submission_button.dart';
import 'package:enlight/components/enlight_loading_indicator.dart';
import 'package:enlight/components/enlight_text_form_field.dart';
import 'package:enlight/env.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PasswordRecoveryPage extends StatefulWidget {
  const PasswordRecoveryPage({super.key});

  @override
  State<PasswordRecoveryPage> createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage> {
  var loading = false;
  late final TextEditingController _emailController;
  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: const Text('Recover password'),
          ),
          body: PasswordRecoveryForm(
            onPressed: _onPressed,
            emailController: _emailController, 
            formKey: formKey,
          ),
        ),
        EnlightLoadingIndicator(visible: loading)
      ],
    );
  }

  void Function()? _onPressed() {
    setState(() {
      loading = true;
    });
    http
        .post(
      Uri.http(
        server,
        '/password-reset/request',
      ),
      headers: Map.from({"Content-Type": "application/json"}),
      body: json.encode(
        {
          "email": _emailController.text,
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
            content: Text("A recovery email has ben sent."),
          ),
        );
        Navigator.of(context).pop();
        return;
      }
      if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email does not exist. Please try again."),
          ),
        );
        return;
      } else if (response.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Internal Server Error. Please try again."),
          ),
        );
        return;
      }
    });
    return null;
  }
}

class PasswordRecoveryForm extends StatefulWidget {
  final void Function()? onPressed;
  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;

  const PasswordRecoveryForm({
    super.key,
    required this.onPressed,
    required this.formKey,
    required this.emailController,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PasswordRecoveryFormState createState() => _PasswordRecoveryFormState();
}

class _PasswordRecoveryFormState extends State<PasswordRecoveryForm> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: widget.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Find your account',
                  style: TextStyle(
                      fontSize: 20
                   ),
                ),
                const Text (
                  'Enter the email linked to your accont.',
                  style: TextStyle(
                      fontSize: 16
                   ),
                ),
                EnlightTextFormField(
                   text: "Email",
                   controller: widget.emailController,
                ),
                EnlightFormSubmissionButton(
                   text: "Send recovery email",
                   onPressed: widget.onPressed, 
                   formKey: widget.formKey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
