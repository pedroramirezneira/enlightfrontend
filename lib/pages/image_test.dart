import 'dart:convert';
import 'package:enlight/components/enlight_app_bar.dart';
import 'package:enlight/components/enlight_loading_indicator.dart';
import 'package:enlight/models/teacher_profile_data.dart';
import 'package:enlight/util/account_ops.dart';
import 'package:enlight/util/token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ImageTest extends StatefulWidget {
  const ImageTest({super.key});

  @override
  State<ImageTest> createState() => _ImageTestState();
}

class _ImageTestState extends State<ImageTest> {
  late final Future<TeacherProfileData> data;

  @override
  void initState() {
    super.initState();
    data = AccountOps.getTeacherProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const EnlightAppBar(text: "Si"),
      body: FutureBuilder(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: SizedBox(
                  width: 500,
                  child: Column(
                    children: [
                      Image.memory(
                        base64.decode(snapshot.data!.picture),
                        width: 200,
                        height: 200,
                      ),
                      ElevatedButton(
                        onPressed: onPressed,
                        child: const Text("Si"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }
          return const EnlightLoadingIndicator(visible: true);
        },
      ),
    );
  }

  void onPressed() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    final bytes = await image.readAsBytes();
    final encoded = base64.encode(bytes);
    final token = await Token.getAccessToken();
    final response = await http.put(
      Uri.https(
        dotenv.env["SERVER"]!,
        "teacher",
      ),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: json.encode({
        "description": "si",
        "profile_picture": encoded,
      }),
    );
    response.statusCode == 200 ? null : null;
  }
}
