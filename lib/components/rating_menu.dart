import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/components/form_submission_button.dart';
import 'package:enlight/components/enlight_text_field.dart';
import 'package:enlight/components/loading_indicator.dart';
import 'package:flutter/material.dart';

class RatingMenu extends StatefulWidget {
  final BuildContext context;

  const RatingMenu({
    super.key,
    required this.context,
  });

  @override
  State<RatingMenu> createState() => _RateMenuState();
}

class _RateMenuState extends State<RatingMenu> {
  late final GlobalKey<FormState> formKey;
  late final GlobalKey<ScaffoldMessengerState> messengerKey;
  late final TextEditingController rateController;
  var loading = false;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    messengerKey = GlobalKey<ScaffoldMessengerState>();
    rateController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ScaffoldMessenger(
          key: messengerKey,
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Rate Teacher"),
            ),
            body: Center(
              child: Column(
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        EnlightTextField(
                          text: "Rate from 1 to 10",
                          controller: rateController,
                          number: true,
                        ),
                        FormSubmissionButton(
                          text: "Submit",
                          formKey: formKey,
                          onPressed: () {
                            final result =
                                double.tryParse(rateController.text) ??
                                    int.parse(rateController.text).toDouble();
                            if (result > 10 || result < 1) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: AwesomeSnackbarContent(
                                    title: "Error",
                                    message: "Rating should be from 1 to 10.",
                                    contentType: ContentType.failure,
                                  ),
                                ),
                              );
                              return;
                            }
                            if (formKey.currentState!.validate()) {
                              Navigator.of(context).pop(result);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        LoadingIndicator(visible: loading),
      ],
    );
  }
}
