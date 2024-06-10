import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:enlight/pages/search/util/result_conatiner.dart';
import 'package:enlight/pages/search/util/search_box.dart';
import 'package:enlight/pages/search/util/teacher_result_container.dart';
import 'package:enlight/util/search_ops.dart';
import 'package:flutter/material.dart';
import 'package:enlight/models/search_data.dart';

class SearchTeachers extends StatefulWidget {
  const SearchTeachers({super.key});

  @override
  State<SearchTeachers> createState() => _SearchTeachersState();
}

class _SearchTeachersState extends State<SearchTeachers> {
  late Future<SearchData> _searchResults;
  final List<String> items = [
    'Teacher',
    'Tags',
  ];
  String? selectedValue = 'Teacher';
  late final TextEditingController _priceController = TextEditingController();
  late final TextEditingController _ratingController = TextEditingController();

  void _performSearch(String query) {
    if (_priceController.text.isEmpty || _ratingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AwesomeSnackbarContent(
            title: "Error",
            message: "Fill the price and rating fields",
            contentType: ContentType.failure,
          ),
        ),
      );
      return;
    }
    if (int.parse(_priceController.text) < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AwesomeSnackbarContent(
            title: "Error",
            message: "Price has to equal or greater than 0",
            contentType: ContentType.failure,
          ),
        ),
      );
      return;
    }
    if ((int.parse(_ratingController.text) < 0 ||
        int.parse(_ratingController.text) > 10)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AwesomeSnackbarContent(
            title: "Error",
            message: "Rating has to be between 0 and 10",
            contentType: ContentType.failure,
          ),
        ),
      );
      return;
    }
    setState(() {
      _searchResults = SearchOps.getSearch(query).catchError((error) {
        return SearchData(
          teacher: [],
          subject: [],
        );
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _searchResults = Future.value(SearchData(
      teacher: [],
      subject: [],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<SearchData>(
        future: _searchResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            return CustomScrollView(
              slivers: [
                const SliverAppBar(
                  title: Text("Search"),
                  centerTitle: true,
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                SearchBox(
                                  hintText: "Search...",
                                  onSubmitted: _performSearch,
                                ),
                                Center(
                                  child: DropdownButtonHideUnderline(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: SizedBox(
                                        width:
                                            (MediaQuery.of(context).size.width -
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        1.7) /
                                                1.5,
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          hint: const Row(
                                            children: [
                                              SizedBox(
                                                width: 4,
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
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Colors.white,
                                              ),
                                              color: const Color.fromARGB(
                                                  255, 43, 57, 68),
                                            ),
                                          ),
                                          iconStyleData: const IconStyleData(
                                            icon: Icon(
                                              Icons.arrow_drop_down,
                                            ),
                                            iconSize: 14,
                                            iconEnabledColor: Colors.white,
                                            iconDisabledColor: Colors.grey,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                            maxHeight: 200,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              color: const Color.fromARGB(
                                                  255, 43, 57, 68),
                                            ),
                                            offset: const Offset(0, 0),
                                            scrollbarTheme: ScrollbarThemeData(
                                              radius: const Radius.circular(40),
                                              thickness: WidgetStateProperty
                                                  .all<double>(6),
                                              thumbVisibility:
                                                  WidgetStateProperty.all<bool>(
                                                      true),
                                            ),
                                          ),
                                          menuItemStyleData:
                                              const MenuItemStyleData(
                                            height: 40,
                                            padding: EdgeInsets.only(
                                                left: 14, right: 14),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _priceController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelText: "Max Price",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller: _ratingController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelText: "Min Rating",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            if (selectedValue == "Teacher")
                              for (var teacher in snapshot.data!.teacher!)
                                if (teacher.rating >=
                                    double.parse(_ratingController.text))
                                  TeacherResultContainer(
                                    name: teacher.name,
                                    description: teacher.description,
                                    picture: teacher.picture,
                                    id: teacher.id,
                                    rating: teacher.rating,
                                  ),
                            if (selectedValue == "Tags")
                              for (var subject in snapshot.data!.subject!)
                                if (subject.price <=
                                    double.parse(_priceController.text))
                                  SubjectResultContainer(
                                    price: subject.price,
                                    subjectId: subject.id,
                                    name: subject.name,
                                    description: subject.description,
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          } else {
            return const Center(
              child: Text("No data found"),
            );
          }
        },
      ),
    );
  }
}
