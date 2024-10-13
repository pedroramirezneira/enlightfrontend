import 'package:enlight/components/form_submission_button.dart';
import 'package:enlight/components/loading_indicator.dart';
import 'package:enlight/components/enlight_text_field.dart';
import 'package:enlight/services/unauthorized_service.dart';
import 'package:flutter/material.dart';

class PasswordRecoveryPage extends StatefulWidget {
  const PasswordRecoveryPage({super.key});

  @override
  State<PasswordRecoveryPage> createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage> {
  var loading = false;
  late final TextEditingController emailController;
  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
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
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: formKey,
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
                        controller: emailController,
                        email: true,
                      ),
                      FormSubmissionButton(
                        text: "Send recovery email",
                        formKey: formKey,
                        onPressed: () async {
                          setState(() => loading = true);
                          await UnauthorizedService.resetPassword(
                            context,
                            emailController.text,
                          );
                          setState(() => loading = false);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        LoadingIndicator(visible: loading)
      ],
    );
  }
}
