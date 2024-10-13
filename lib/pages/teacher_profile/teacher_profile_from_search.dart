import 'dart:convert';
import 'dart:typed_data';
import 'package:enlight/components/loading_indicator.dart';
import 'package:enlight/models/search_teacher_data.dart';
import 'package:enlight/pages/teacher_profile/util/tags_container_from_search.dart';
import 'package:enlight/services/teacher_service.dart';
import 'package:flutter/foundation.dart';
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
  var loading = false;
  Uint8List? decoded;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final data =
          await TeacherService.getTeacherFromSearch(context, widget.id);

      setState(() {
        this.data = data;
        if (data.picture != null) {
          decoded = base64Decode(data.picture!);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = data.picture != null;
    return Stack(
      children: [
        Scaffold(
          body: data is EmptySearchTeacherData
              ? const LoadingIndicator(visible: true)
              : CustomScrollView(
                  slivers: [
                    const SliverAppBar(
                      title: Text("Profile"),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: CircleAvatar(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .surface
                                          .withOpacity(0.5),
                                      radius: 50,
                                      backgroundImage: hasImage
                                          ? MemoryImage(decoded!)
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
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 26),
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          data.name,
                                          style: const TextStyle(fontSize: 30),
                                        ),
                                        Text(
                                          "${data.rating}/10",
                                          style: const TextStyle(fontSize: 18),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Description:",
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      data.description,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    const Text(
                                      "Tags:",
                                      style: TextStyle(
                                        fontSize: 20,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  for (var tag in data.subjects)
                                    Column(
                                      children: [
                                        TagContainerFromSearch(
                                            subjectId: tag.id,
                                            name: tag.name,
                                            price: tag.price,
                                            description: tag.description),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
        if (loading) const LoadingIndicator(visible: true),
      ],
    );
  }
}
