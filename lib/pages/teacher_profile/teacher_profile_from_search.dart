import 'dart:convert';

import 'package:enlight/components/fixed_scaffold.dart';
import 'package:enlight/models/teacher/search_teacher_data.dart';
import 'package:enlight/pages/teacher_profile/util/tags_container_from_search.dart';
import 'package:enlight/services/teacher_service.dart';
import 'package:flutter/material.dart';

class TeacherProfileFromSearch extends StatefulWidget {
  final int id;

  const TeacherProfileFromSearch({super.key, required this.id});

  @override
  State<TeacherProfileFromSearch> createState() =>
      _TeacherProfileFromSearchState();
}

class _TeacherProfileFromSearchState extends State<TeacherProfileFromSearch> {
  SearchTeacherData data = EmptySearchTeacherData();
  var loading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  String stars(int rating) {
    var stars = "";
    for (var i = 0; i < rating; i+=2) {
      stars += "⭐";
    }
    return stars;
  }

  Future<void> _fetchData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final data = await TeacherService.getTeacherFromSearch(
        context,
        widget.id,
      );
      setState(() {
        this.data = data;
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = data.picture != null;
    if (loading) {
      return const FixedScaffold(
          title: "Teacher", body: CircularProgressIndicator.adaptive());
    }
    if (data is EmptySearchTeacherData) {
      return const FixedScaffold(
        title: "Teacher",
        body: Text("An error occurred while loading the teacher."),
      );
    }
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text("Teacher"),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .surface
                                .withOpacity(0.5),
                            radius: 50,
                            backgroundImage: hasImage
                                ? MemoryImage(base64.decode(data.picture!))
                                : null,
                            child: !hasImage
                                ? Text(
                                    data.name[0].toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 50,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(
                            width: 24,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                data.name,
                                style: const TextStyle(fontSize: 20),
                              ),
                              Text(
                                stars(data.rating.toInt()),
                                style: const TextStyle(fontSize: 18),
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Description:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        data.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Tags:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      for (var tag in data.subjects)
                        Column(
                          children: [
                            TagContainerFromSearch(
                              subjectId: tag.id,
                              name: tag.name,
                              price: tag.price,
                              description: tag.description,
                            ),
                            SizedBox(height: 24),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
