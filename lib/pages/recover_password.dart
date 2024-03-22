import 'dart:convert';

import 'package:enlight/env.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PasswordRecoveryPage extends StatelessWidget {
  const PasswordRecoveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar contraseña'),
      ),
      body: const PasswordRecoveryForm(),
    );
  }
}

class PasswordRecoveryForm extends StatefulWidget {
  const PasswordRecoveryForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PasswordRecoveryFormState createState() => _PasswordRecoveryFormState();
}

class _PasswordRecoveryFormState extends State<PasswordRecoveryForm> {
  final TextEditingController _emailController = TextEditingController();

  void _sendPasswordResetEmail() {
    String email = _emailController.text;
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
      if (response.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Wrong email. Please try again."),
          ),
        );
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Correo electrónico',
            ),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: _sendPasswordResetEmail,
            child: const Text('Enviar correo de recuperación'),
          ),
        ],
      ),
    );
  }
}
