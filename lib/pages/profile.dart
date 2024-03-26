import 'package:enlight/components/enlight_app_bar.dart';
import 'package:enlight/components/enlight_loading_indicator.dart';
import 'package:enlight/models/profile_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
      body: FutureBuilder(future: data, builder: ((context, snapshot) {
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
                      backgroundImage: NetworkImage("https://encrypted-tbn1.gstatic.com/licensed-image?q=tbn:ANd9GcREk1Vj4KOP3qRnDWzCesuSe_gD9vcwxfJKRjXJvgSdArSg_r2kfAD89ovRItu3onWPtm8fi_XriXW8QkU"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 34),
                    child: Column(
                      children: <Widget>[
                        Text(
                          snapshot.data!.name,
                          style: const TextStyle(
                            fontSize: 30
                          ),
                          ),
                        Text(
                          "${snapshot.data!.rating}/10.0",
                          style: const TextStyle(
                            fontSize: 18
                          ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                child: Text(
                  snapshot.data!.description,
                  style: const TextStyle(
                    fontSize: 18
                    ),
                  ),
              ),
              for (var item in snapshot.data!.tags) 
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 20
                    ),
                  ),
                )
            ],
          );  
        }
        if (snapshot.hasError) {

        }
        return const EnlightLoadingIndicator(visible: true);
      }))
    );
  }
}