import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/components/autocomplete_field.dart';
import 'package:enlight/components/form_submission_button.dart';
import 'package:enlight/components/enlight_text_field.dart';
import 'package:enlight/components/loading_indicator.dart';
import 'package:enlight/components/timeslot_menu.dart';
import 'package:enlight/models/category_data.dart';
import 'package:enlight/models/day_data.dart';
import 'package:enlight/models/timeslot_menu_data.dart';
import 'package:flutter/material.dart';

class SubjectMenu extends StatefulWidget {
  final List<CategoryData> categories;
  final void Function({
    required BuildContext context,
    required String categoryName,
    required String name,
    required String description,
    required int price,
    required List<DayData> days,
  }) onPressed;

  const SubjectMenu({
    super.key,
    required this.categories,
    required this.onPressed,
  });

  @override
  State<SubjectMenu> createState() => _SubjectMenuState();
}

class _SubjectMenuState extends State<SubjectMenu> {
  late final GlobalKey<FormState> formKey;
  late final GlobalKey<ScaffoldMessengerState> messengerKey;
  late final TextEditingController categoryNameController;
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late final TextEditingController priceController;
  final List<DayData> days = [];
  var loading = false;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    messengerKey = GlobalKey<ScaffoldMessengerState>();
    categoryNameController = TextEditingController();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    priceController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ScaffoldMessenger(
          key: messengerKey,
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Create subject",
              ),
            ),
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          AutocompleteField(
                            text: "Category Name",
                            data: widget.categories,
                            controller: categoryNameController,
                          ),
                          EnlightTextField(
                            text: "Name",
                            controller: nameController,
                          ),
                          EnlightTextField(
                            text: "Price",
                            controller: priceController,
                            number: true,
                          ),
                          EnlightTextField(
                            text: "Description",
                            controller: descriptionController,
                            description: true,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Wrap(
                              spacing: 18,
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                for (final day in days)
                                  Column(
                                    children: <Widget>[
                                      Text(day.name),
                                      for (final timeslot in day.timeslots)
                                        Text(
                                          "${timeslot.startTime} - ${timeslot.endTime}",
                                        ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: ElevatedButton(
                              onPressed: () async {
                                final data = await showModalBottomSheet<
                                    TimeslotMenuData>(
                                  context: context,
                                  builder: (context) => TimeslotMenu(),
                                );
                                if (data == null) {
                                  return;
                                }
                                for (final day in data.days) {
                                  final index =
                                      days.indexWhere((e) => e.name == day);
                                  if (index != -1) {
                                    setState(() {
                                      days[index].timeslots.add(data.timeslot);
                                    });
                                    return;
                                  }
                                  setState(() {
                                    days.add(
                                      DayData(
                                        name: day,
                                        timeslots: [data.timeslot],
                                      ),
                                    );
                                  });
                                }
                              },
                              child: const Text(
                                "Add timeslot",
                              ),
                            ),
                          ),
                          FormSubmissionButton(
                            text: "Create",
                            formKey: formKey,
                            onPressed: () {
                              if (days.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: AwesomeSnackbarContent(
                                      title: "Watch out",
                                      message:
                                          "Please add at least one timeslot",
                                      contentType: ContentType.warning,
                                    ),
                                  ),
                                );
                                return;
                              }
                              setState(() => loading = true);
                              widget.onPressed(
                                context: context,
                                categoryName: categoryNameController.text,
                                name: nameController.text,
                                description: descriptionController.text,
                                price: int.parse(priceController.text),
                                days: days,
                              );
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
        ),
        LoadingIndicator(visible: loading),
      ],
    );
  }
}
