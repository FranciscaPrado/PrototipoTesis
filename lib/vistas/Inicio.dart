import 'package:crisisconnect/vistas/CrearUsuario.dart';
import 'package:crisisconnect/vistas/InicioUsuario.dart';
import 'package:flutter/material.dart';


class Inicio extends StatelessWidget {
  const Inicio({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo-inicio.png'),
            const SizedBox(height: 30), 
            const FilledButtons(), 
          ],
        ),
      ),
    );
  }
}

class FilledButtons extends StatelessWidget {
  const FilledButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilledButton(
          onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InicioUsuario()),
          );
          },
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF2D2D2D),  
          ),
          child: const Text('Iniciar con usuario', 
              style: TextStyle(
              fontFamily: 'Calistoga',  
              fontSize: 30,             
              color: Color(0xFFABC4C6), 
            ),
          ),
        ),
        const SizedBox(height: 10),  
        const SizedBox(
          width: 95, 
          child: Divider(
            color: Color(0xFFE2CD0E),  
            thickness: 3,  
          ),
        ),
        const SizedBox(height: 10),  
        FilledButton(
          onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CrearUsuario()),
            );
          },
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF2D2D2D), 
          ),
          child: const Text('    Crear Usuario    ',
              style: TextStyle(
              fontFamily: 'Calistoga',  
              fontSize: 30,             
              color: Color(0xFFABC4C6), 
            ),
          ),
        ),
      ],
    );
  }
}