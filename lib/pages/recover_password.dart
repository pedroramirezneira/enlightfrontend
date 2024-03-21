import 'package:flutter/material.dart';

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
    // Aquí deberías agregar la lógica para enviar el correo electrónico de recuperación
    // Puedes utilizar servicios como Firebase para manejar la autenticación y el envío de correos electrónicos.

    // Por ejemplo, con Firebase Authentication, puedes usar:
    // FirebaseAuth.instance.sendPasswordResetEmail(email: email);

    // Una vez que se envíe el correo electrónico de recuperación, puedes mostrar un mensaje al usuario.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Correo electrónico enviado'),
          content: Text('Se ha enviado un correo electrónico de recuperación a $email.'),
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
