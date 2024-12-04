import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:enlight/components/loading_indicator.dart';
import 'package:enlight/pages/search/util/subject_result_container.dart';
import 'package:enlight/pages/search/util/search_box.dart';
import 'package:enlight/pages/search/util/teacher_result_container.dart';
import 'package:enlight/services/search_service.dart';
import 'package:flutter/material.dart';
import 'package:enlight/models/search_data.dart';

class SearchTeachers extends StatefulWidget {
  const SearchTeachers({super.key});

  @override
  State<SearchTeachers> createState() => _SearchTeachersState();
}

class _SearchTeachersState extends State<SearchTeachers> {
  SearchData _searchResults = EmptySearchData();
  final List<String> items = [
    'Teacher',
    'Tags',
  ];
  String? selectedValue = 'Teacher';
  late final TextEditingController _priceController;
  late final TextEditingController _ratingController;
  var loading = false;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(text: "${double.infinity}");
    _ratingController = TextEditingController(text: "0.0");
  }

  @override
  void dispose() {
    _priceController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  void _performSearch(String query) async {
    final double maxPrice = _priceController.text.isNotEmpty
        ? double.parse(_priceController.text)
        : double.infinity;

    final double minRating = _ratingController.text.isNotEmpty
        ? double.parse(_ratingController.text)
        : 0.0;

    if (maxPrice < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AwesomeSnackbarContent(
            title: "Error",
            message: "Price has to be equal or greater than 0",
            contentType: ContentType.failure,
          ),
        ),
      );
      return;
    }
    if (minRating < 0 || minRating > 10) {
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
      loading = true;
    });

    final result = await SearchService.search(context, query);
    setState(() {
      _searchResults = result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text("Search"),
                actions: [
                  SegmentedButton(
                    selected: {selectedValue},
                    segments: [
                      ButtonSegment(
                        label: Text("Teacher"),
                        value: "Teacher",
                      ),
                      ButtonSegment(
                        label: Text("Tags"),
                        value: "Tags",
                      )
                    ],
                    onSelectionChanged: (p0) {
                      setState(() {
                        selectedValue = p0.first;
                      });
                    },
                  ),
                  SizedBox(width: 24),
                ],
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 8),
                          SearchBox(
                            hintText: "Search...",
                            onSubmitted: _performSearch,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<double>(
                                  decoration: const InputDecoration(
                                    labelText: "Max Price",
                                    border: OutlineInputBorder(),
                                  ),
                                  value: _priceController.text.isNotEmpty
                                      ? double.parse(_priceController.text)
                                      : double.infinity,
                                  items: [
                                    {"label": "< \$500", "value": 500.0},
                                    {"label": "< \$1000", "value": 1000.0},
                                    {"label": "< \$5000", "value": 5000.0},
                                    {"label": "< \$10000", "value": 10000.0},
                                    {"label": "Any", "value": double.infinity},
                                  ].map((option) {
                                    return DropdownMenuItem<double>(
                                      value: option["value"] as double,
                                      child: Text(option["label"] as String),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _priceController.text =
                                          value == double.infinity
                                              ? 'Any'
                                              : value!.toString();
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DropdownButtonFormField<double>(
                                  decoration: const InputDecoration(
                                    labelText: "Min Rating",
                                    border: OutlineInputBorder(),
                                  ),
                                  value: _ratingController.text.isNotEmpty
                                      ? double.parse(_ratingController.text)
                                      : null,
                                  items: [
                                    {"label": "Any", "value": 0.0},
                                    {"label": "> 2", "value": 2.0},
                                    {"label": "> 4", "value": 4.0},
                                    {"label": "> 6", "value": 6.0},
                                    {"label": "> 8", "value": 8.0},
                                  ].map((option) {
                                    return DropdownMenuItem<double>(
                                      value: option["value"] as double,
                                      child: Text(option["label"] as String),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _ratingController.text = value.toString();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (selectedValue == "Teacher")
                            if (_searchResults.teachers!.isEmpty)
                              const Center(
                                child: Text("No data found"),
                              )
                            else
                              for (var teacher in _searchResults.teachers!)
                                if (teacher.rating >=
                                    (_ratingController.text.isNotEmpty
                                        ? double.parse(_ratingController.text)
                                        : 0.0))
                                  Column(
                                    children: [
                                      TeacherResultContainer(
                                        name: teacher.name,
                                        description: teacher.description,
                                        picture: teacher.picture,
                                        id: teacher.id,
                                        rating: teacher.rating,
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                          if (selectedValue == "Tags")
                            if (_searchResults.subjects!.isEmpty)
                              const Center(
                                child: Text("No data found"),
                              )
                            else
                              for (var subject in _searchResults.subjects!)
                                if (subject.price <=
                                    (_priceController.text.isNotEmpty
                                        ? double.parse(_priceController.text)
                                        : double.infinity))
                                  Column(
                                    children: [
                                      SubjectResultContainer(
                                        price: subject.price,
                                        subjectId: subject.id,
                                        name: subject.name,
                                        description: subject.description,
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        if (loading) const LoadingIndicator(visible: true),
      ],
    );
  }
}
