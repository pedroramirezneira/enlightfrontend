import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/components/form_submission_button.dart';
import 'package:enlight/components/enlight_text_field.dart';
import 'package:enlight/components/loading_indicator.dart';
import 'package:enlight/models/student_reservation_data.dart';
import 'package:flutter/material.dart';

class RatingMenu extends StatefulWidget {
  final void Function({
    required BuildContext context,
    required List<ReservationData> data,
    required double rate,
    required int reservationId,
    required int teacherId,
  }) onPressed;
  final int reservationId;
  final int teacherId;
  final BuildContext context;
  final List<ReservationData> data;

  const RatingMenu({
    super.key,
    required this.data,
    required this.context,
    required this.onPressed,
    required this.reservationId,
    required this.teacherId,
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
                            if (double.parse(rateController.text) > 10 ||
                                double.parse(rateController.text) < 1) {
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
                              setState(() => loading = true);
                              widget.onPressed(
                                data: widget.data,
                                context: widget.context,
                                reservationId: widget.reservationId,
                                teacherId: widget.teacherId,
                                rate: double.parse(rateController.text),
                              );
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
