import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:enlight/components/form_submission_button.dart';
import 'package:enlight/components/loading_indicator.dart';
import 'package:enlight/components/enlight_text_field.dart';
import 'package:enlight/models/account/create_account_data.dart';
import 'package:enlight/services/unauthorized_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController nameController;
  late final TextEditingController birthdayController;
  late final TextEditingController addressController;
  var loading = false;
  final List<String> items = [
    'Teacher',
    'Student',
  ];
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    birthdayController = TextEditingController();
    addressController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          body: CustomScrollView(
            slivers: [
              const SliverAppBar(),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 5, 0, 0),
                            child: SizedBox(
                              width: 308,
                              height: 100,
                              child: Align(
                                alignment: const AlignmentDirectional(0, 0),
                                child: Text(
                                  'ENLIGHT',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.getFont(
                                    'Montserrat',
                                    color: const Color.fromARGB(
                                        255, 100, 201, 169),
                                    fontSize: 50,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Form(
                            key: formKey,
                            child: SizedBox(
                              width: 500,
                              child: Column(
                                children: <Widget>[
                                  EnlightTextField(
                                    text: "Email",
                                    controller: emailController,
                                    email: true,
                                  ),
                                  EnlightTextField(
                                    text: "Password",
                                    controller: passwordController,
                                    password: true,
                                  ),
                                  EnlightTextField(
                                    text: "Name",
                                    controller: nameController,
                                  ),
                                  EnlightTextField(
                                    text: "Birthday",
                                    controller: birthdayController,
                                    date: true,
                                  ),
                                  EnlightTextField(
                                    text: "Address",
                                    controller: addressController,
                                  ),
                                  Center(
                                    child: DropdownButtonHideUnderline(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          hint: const Row(
                                            children: [
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'Select Role',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
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
                                              Icons.arrow_forward_ios_outlined,
                                            ),
                                            iconSize: 14,
                                            iconEnabledColor: Colors.white,
                                            iconDisabledColor: Colors.grey,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                            maxHeight: 200,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              color: const Color.fromARGB(
                                                  255, 43, 57, 68),
                                            ),
                                            offset: const Offset(150, 0),
                                            scrollbarTheme:
                                                const ScrollbarThemeData(
                                              radius: Radius.circular(40),
                                              thickness: WidgetStatePropertyAll<
                                                  double>(6),
                                              thumbVisibility:
                                                  WidgetStatePropertyAll<bool>(
                                                      true),
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
                                  FormSubmissionButton(
                                    text: "Sign up",
                                    formKey: formKey,
                                    onPressed: () async {
                                      setState(() => loading = true);
                                      if (selectedValue == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: AwesomeSnackbarContent(
                                              title: "Watch out",
                                              message: "Role cannot be empty.",
                                              contentType: ContentType.help,
                                            ),
                                          ),
                                        );
                                        setState(() => loading = false);
                                        return;
                                      }
                                      final data = CreateAccountData(
                                        email: emailController.text,
                                        password: passwordController.text,
                                        name: nameController.text,
                                        birthday: birthdayController.text,
                                        address: addressController.text,
                                        role: selectedValue!.toLowerCase(),
                                      );
                                      final response =
                                          await UnauthorizedService.register(
                                        context,
                                        data,
                                      );
                                      setState(() => loading = false);
                                      if (!context.mounted) return;
                                      if (response.statusCode == 200) {
                                        Navigator.of(context).pop();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        LoadingIndicator(visible: loading),
      ],
    );
  }
}
