import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crisisconnect/vistas/user_provider.dart';
import 'package:crisisconnect/vistas/Menu.dart';
import 'package:provider/provider.dart';


class InicioUsuario extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController credencialController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  InicioUsuario({super.key});

  Future<bool> verificarUsuario(String username) async {
    try {
      QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: username)
          .get();

      return userSnapshot.docs.isNotEmpty;
    } catch (e) {
      debugPrint('Error al verificar usuario: $e');
      return false;
    }
  }

  Future<void> iniciarSesion(String username, BuildContext context) async {

    Provider.of<UserProvider>(context, listen: false).setUsername(username);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Menu(),
      ),
    );
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      title: const Text(
        'Iniciar Sesión',
        style: TextStyle(
          fontFamily: 'Calistoga',
          fontSize: 30,
          color: Color(0xFFEBEBEB),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 3, 149, 162),
    ),
    body: SingleChildScrollView( // Agregado aquí
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Image.asset(
              'assets/logo-inicio.png',
              width: 320,
              height: 320,
            ),
            const SizedBox(height: 50),
            TextFormField(
              controller: credencialController,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(255, 235, 235, 235),
                labelText: 'Usuario',
                labelStyle: const TextStyle(
                  color: Color.fromARGB(255, 3, 149, 162),
                ),
                hintText: 'Ingrese su nombre de usuario',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 3, 149, 162),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 3, 149, 162),
                    width: 2.0,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Colors.red,
                  ),
                ),
              ),
              style: const TextStyle(
                color: Color.fromARGB(255, 3, 149, 162),
                fontSize: 16,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingresa tu nombre de usuario';
                } else if (RegExp(r'[0-9]').hasMatch(value)) {
                  return 'Ingrese un nombre de usuario valido';
                }
                return null;
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String username = credencialController.text.trim();

                  bool usuarioExiste = await verificarUsuario(username);

                  if (usuarioExiste) {
                    await iniciarSesion(username, context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'El usuario no existe. Por favor, verifica tus credenciales.',
                        ),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D2D2D),
              ),
              child: const Text(
                'Iniciar sesión',
                style: TextStyle(
                  fontFamily: 'Calistoga',
                  fontSize: 30,
                  color: Color(0xFFABC4C6),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}