import 'package:enlight/pages/search/util/search_box.dart';
import 'package:enlight/util/student_navigation_bar.dart';
import 'package:flutter/material.dart';

class SearchTeachers extends StatefulWidget {
  const SearchTeachers({super.key});

  @override
  State<SearchTeachers> createState() => _SearchTeachersState();
}

class _SearchTeachersState extends State<SearchTeachers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Search",
        ),
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SearchBox(hintText: "Search..."),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Name"),
              SizedBox(width: 50),
              Text(
                "Tags",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          )
        ],
      ),
      bottomNavigationBar: const StudentNavigationBar(
        index: 0,
      ),
    );
  }
}
