import 'package:enlight/pages/search/util/result_conatiner.dart';
import 'package:enlight/pages/search/util/search_box.dart';
import 'package:enlight/pages/search/util/teacher_result_container.dart';
import 'package:enlight/util/search_ops.dart';
import 'package:enlight/util/student_navigation_bar.dart';
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
      appBar: AppBar(
        title: const Text("Search"),
      ),
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
                SliverList(
                  delegate: SliverChildListDelegate([
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
                              const SizedBox(width: 10),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SizedBox(
                                  width: 200,
                                  child: DropdownButton<String>(
                                    borderRadius: BorderRadius.circular(10),
                                    items: items.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    value: selectedValue,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedValue = newValue;
                                      });
                                    },
                                  ),
                                ),
                              )
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
                              )
                          else if (selectedValue == "Tags")
                            for (var subject in snapshot.data!.subject!)
                              ResultContainer(
                                  name: subject.name,
                                  description: subject.description,
                                  picture: "")
                        ],
                      ),
                    ),
                  ]),
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
      bottomNavigationBar: const StudentNavigationBar(
        index: 0,
      ),
    );
  }
}
