import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:enlight/components/autocomplete_field.dart';
import 'package:enlight/components/form_submission_button.dart';
import 'package:enlight/components/enlight_text_field.dart';
import 'package:enlight/components/loading_indicator.dart';
import 'package:enlight/components/timeslot.dart';
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
    required int group,
    required String modality,
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
  late final TextEditingController groupController;
  final List<DayData> days = [];
  var loading = false;
  final List<String> items = ['Face-to-face', 'Online', 'Both'];
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    messengerKey = GlobalKey<ScaffoldMessengerState>();
    categoryNameController = TextEditingController();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    priceController = TextEditingController();
    groupController = TextEditingController();
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
                            text: "Group Size",
                            controller: groupController,
                            number: true,
                          ),
                          EnlightTextField(
                            text: "Description",
                            controller: descriptionController,
                            description: true,
                          ),
                          Center(
                            child: DropdownButtonHideUnderline(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: DropdownButton2<String>(
                                  isExpanded: true,
                                  hint: const Row(
                                    children: [
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Select Modality',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  items: items
                                      .map((String item) =>
                                          DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                      .toList(),
                                  value: selectedValue,
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedValue = value!;
                                    });
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: 55,
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.white,
                                      ),
                                      color:
                                          const Color.fromARGB(255, 43, 57, 68),
                                    ),
                                  ),
                                  iconStyleData: const IconStyleData(
                                    icon: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                    ),
                                    iconSize: 14,
                                    iconEnabledColor: Colors.white,
                                    iconDisabledColor: Colors.grey,
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    maxHeight: 200,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      color:
                                          const Color.fromARGB(255, 43, 57, 68),
                                    ),
                                    offset: const Offset(150, 0),
                                    scrollbarTheme: ScrollbarThemeData(
                                      radius: const Radius.circular(40),
                                      thickness:
                                          MaterialStateProperty.all<double>(6),
                                      thumbVisibility:
                                          MaterialStateProperty.all<bool>(true),
                                    ),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                    padding:
                                        EdgeInsets.only(left: 14, right: 14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                for (final day in days)
                                  SizedBox(
                                    width: double.maxFinite,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text(day.name),
                                        ),
                                        Wrap(
                                          children: <Widget>[
                                            for (final timeslot
                                                in day.timeslots)
                                              Timeslot(
                                                text:
                                                    "${timeslot.startTime} - ${timeslot.endTime}",
                                                onPressed: () {
                                                  setState(() {
                                                    day.timeslots
                                                        .remove(timeslot);
                                                    if (day.timeslots.isEmpty) {
                                                      days.remove(day);
                                                    }
                                                  });
                                                },
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
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
                                  useSafeArea: true,
                                  isScrollControlled: true,
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
                                messengerKey.currentState!.showSnackBar(
                                  SnackBar(
                                    content: AwesomeSnackbarContent(
                                      title: "Watch out",
                                      message:
                                          "Please add at least one timeslot",
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
                                group: int.parse(groupController.text),
                                modality: selectedValue!,
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
