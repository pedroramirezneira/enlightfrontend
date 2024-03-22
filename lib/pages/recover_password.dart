import 'dart:convert';

import 'package:enlight/components/enlight_loading_indicator.dart';
import 'package:enlight/env.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PasswordRecoveryPage extends StatefulWidget {
  const PasswordRecoveryPage({super.key});

  @override
  State<PasswordRecoveryPage> createState() => _PasswordRecoveryPageState();
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage> {
  var loading = false;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: const Text('Recuperar contraseña'),
          ),
          body: PasswordRecoveryForm(
            onPressed: _sendPasswordResetEmail,
            emailController: _emailController,
          ),
        ),
        EnlightLoadingIndicator(visible: loading)
      ],
    );
  }

  void Function()? _sendPasswordResetEmail() {
    String email = _emailController.text;
    setState(() {
      loading = true;
    });
    http
        .post(
      Uri.http(
        server,
        '/password-reset/request',
      ),
      headers: Map.from({"Content-Type": "application/json"}),
      body: json.encode(
        {
          "email": _emailController.text,
        },
      ),
    )
        .then((response) {
      setState(() {
        loading = false;
      });
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Correo electrónico enviado'),
              content: Text(
                  'Se ha enviado un correo electrónico de recuperación a $email.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      }
      if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email does not exist. Please try again."),
          ),
        );
        return;
      } else if (response.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Internal Server Error. Please try again."),
          ),
        );
        return;
      }
    });
    return null;
  }
}

class PasswordRecoveryForm extends StatefulWidget {
  final void Function()? onPressed;
  final TextEditingController emailController;

  const PasswordRecoveryForm({
    super.key,
    required this.onPressed,
    required this.emailController,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PasswordRecoveryFormState createState() => _PasswordRecoveryFormState();
}

class _PasswordRecoveryFormState extends State<PasswordRecoveryForm> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: widget.emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: widget.onPressed,
                child: const Text('Enviar correo de recuperación'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
