import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/components/autocomplete_field.dart';
import 'package:enlight/components/form_submission_button.dart';
import 'package:enlight/components/enlight_text_field.dart';
import 'package:enlight/components/loading_indicator.dart';
import 'package:enlight/models/category_data.dart';
import 'package:flutter/material.dart';
import 'package:day_picker/day_picker.dart';

class SubjectMenu extends StatefulWidget {
  final List<CategoryData> categories;
  final void Function({
    required BuildContext context,
    required String categoryName,
    required String name,
    required String description,
    required int price,
    required List<String> days,
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
  late final List<DayInWeek> _days;
  late List<String> _selectedDays;
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
    _selectedDays = [];
    _days = [
      DayInWeek("Mon", dayKey: "Monday"),
      DayInWeek("Tue", dayKey: "Tuesday"),
      DayInWeek("Wed", dayKey: "Wednesday"),
      DayInWeek("Thu", dayKey: "Thursday"),
      DayInWeek("Fri", dayKey: "Friday"),
      DayInWeek("Sat", dayKey: "Saturday"),
      DayInWeek("Sun", dayKey: "Sunday"),
    ];
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
                            padding: const EdgeInsets.all(10),
                            child: SelectWeekDays(
                              padding: 8,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              days: _days,
                              border: false,
                              daysFillColor:
                                  const Color.fromARGB(255, 100, 201, 169),
                              boxDecoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(10.0),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  colors: [
                                    Color.fromARGB(255, 43, 57, 68),
                                    Color.fromARGB(255, 43, 57, 68)
                                  ],
                                  tileMode: TileMode.repeated,
                                ),
                              ),
                              onSelect: (values) {
                                _selectedDays = values;
                              },
                            ),
                          ),
                          FormSubmissionButton(
                            text: "Create",
                            formKey: formKey,
                            onPressed: () {
                              if (_selectedDays.isEmpty) {
                                messengerKey.currentState!.showSnackBar(
                                  SnackBar(
                                    content: AwesomeSnackbarContent(
                                      title: "Watch out",
                                      message:
                                          "Please select at least one day.",
                                      contentType: ContentType.help,
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
                                days: _selectedDays,
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
