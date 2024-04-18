import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/components/form_submission_button.dart';
import 'package:enlight/components/loading_indicator.dart';
import 'package:enlight/components/enlight_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
        LoadingIndicator(visible: loading)
      ],
    );
  }

  void Function()? _onPressed() {
    setState(() {
      loading = true;
    });
    http
        .post(
      Uri.https(
        dotenv.env["SERVER"]!,
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
          SnackBar(
            content: AwesomeSnackbarContent(
              title: "Success",
              message: "A recovery email has ben sent.",
              contentType: ContentType.success,
            ),
          ),
        );
        Navigator.of(context).pop();
        return;
      }
      if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AwesomeSnackbarContent(
              title: "Warning",
              message: "Email does not exist. Please try again.",
              contentType: ContentType.warning,
            ),
          ),
        );
        return;
      } else if (response.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AwesomeSnackbarContent(
              title: "Error",
              message: "Internal server error. Please try again.",
              contentType: ContentType.failure,
            ),
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
          padding: const EdgeInsets.all(15),
          child: Form(
            key: widget.formKey,
            child: SizedBox(
              width: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Find your account',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Text(
                    'Enter the email linked to your accont.',
                    style: TextStyle(fontSize: 16),
                  ),
                  EnlightTextField(
                    text: "Email",
                    controller: widget.emailController,
                    email: true,
                  ),
                  FormSubmissionButton(
                    text: "Send recovery email",
                    onPressed: widget.onPressed,
                    formKey: widget.formKey,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
