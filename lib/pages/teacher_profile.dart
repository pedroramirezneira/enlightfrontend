import 'package:enlight/components/enlight_app_bar.dart';
import 'package:enlight/components/enlight_loading_indicator.dart';
import 'package:enlight/models/profile_data.dart';
import 'package:flutter/material.dart';

class TeacherProfile extends StatefulWidget {
  const TeacherProfile({super.key});

  @override
  State<TeacherProfile> createState() => _TeacherProfileState();
}

class _TeacherProfileState extends State<TeacherProfile> {
  late final Future<ProfileData> data;

  @override
  void initState() {
    super.initState();
    data = ProfileData.getProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const EnlightAppBar(text: "Profile"),
        body: FutureBuilder(
            future: data,
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                                "https://encrypted-tbn1.gstatic.com/licensed-image?q=tbn:ANd9GcREk1Vj4KOP3qRnDWzCesuSe_gD9vcwxfJKRjXJvgSdArSg_r2kfAD89ovRItu3onWPtm8fi_XriXW8QkU"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 34),
                          child: Column(
                            children: <Widget>[
                              Text(
                                snapshot.data!.name,
                                style: const TextStyle(fontSize: 30),
                              ),
                              Text(
                                "${snapshot.data!.rating}/10.0",
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
                    Wrap(
                      children: <Widget>[
                        for (var item in snapshot.data!.tags)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              color: const Color.fromARGB(255, 100, 201, 169),
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                      ],
                    )
                  ],
                );
              }
              if (snapshot.hasError) {}
              return const EnlightLoadingIndicator(visible: true);
            })));
  }
}
