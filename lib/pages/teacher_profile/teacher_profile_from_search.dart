import 'dart:convert';
import 'package:enlight/components/loading_indicator.dart';
import 'package:enlight/models/searched_teacher_data.dart';
import 'package:enlight/pages/teacher_profile/util/tags_container_from_search.dart';
import 'package:enlight/util/teacher_ops.dart';
import 'package:flutter/material.dart';

class TeacherProfileFromSearch extends StatefulWidget {
  final int id; 

  const TeacherProfileFromSearch({super.key, required this.id});

  @override
  State<TeacherProfileFromSearch> createState() =>
      _TeacherProfileFromSearchState();
}

class _TeacherProfileFromSearchState extends State<TeacherProfileFromSearch> {
  late Future<SearchTeacherData> data;
  var loading = true;
  var initialLoaded = false;

  @override
  void initState() {
    super.initState();
    data = TeacherOps.getTeacherFromSearch(widget.id); 
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: FutureBuilder(
            future: data,
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                if (!initialLoaded) {
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    setState(() {
                      loading = false;
                      initialLoaded = true;
                    });
                  });
                }
                final hasImage = snapshot.data!.picture != null;
                final decoded = base64.decode(snapshot.data!.picture ?? "");
                return CustomScrollView(
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
                                          ? MemoryImage(decoded)
                                          : null,
                                      child: !hasImage
                                          ? Text(
                                              snapshot.data!.name[0]
                                                  .toUpperCase(),
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
                                          snapshot.data!.name,
                                          style: const TextStyle(fontSize: 30),
                                        ),
                                        Text(
                                          "${snapshot.data!.rating}/10",
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
                                      snapshot.data!.description,
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
                                  for (var tag
                                      in snapshot.data!.subjects)
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
                );
              }
              if (snapshot.hasError) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  setState(() {
                    loading = false;
                  });
                });
              }
              return const LoadingIndicator(visible: false);
            }),
          ),
        ),
        LoadingIndicator(visible: loading),
      ],
    );
  }
}
