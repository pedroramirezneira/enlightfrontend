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

  void _performSearch(String query) {
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
                                        width: (MediaQuery.of(context).size.width - MediaQuery.of(context).size.width/1.7)/1.5,
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
                                              thickness: MaterialStateProperty
                                                  .all<double>(6),
                                              thumbVisibility:
                                                  MaterialStateProperty.all<
                                                      bool>(true),
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
                            const SizedBox(height: 20),
                            if (selectedValue == "Teacher")
                              for (var teacher in snapshot.data!.teacher!)
                                TeacherResultContainer(
                                  name: teacher.name,
                                  description: teacher.description,
                                  picture: teacher.picture,
                                  id: teacher.id,
                                  rating: teacher.rating,
                                )
                            else if (selectedValue == "Tags")
                              for (var subject in snapshot.data!.subject!)
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
