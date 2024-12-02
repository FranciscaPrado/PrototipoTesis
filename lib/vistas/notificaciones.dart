import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_provider.dart';

class NotificationPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String username = Provider.of<UserProvider>(context).username;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('catastrofes').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AlertDialog(
            content: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Error al cargar datos: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const AlertDialog(
            title: Text('Sin datos'),
            content: Text('No hay catástrofes registradas.'),
          );
        }


        List<DocumentSnapshot> catastrofes = snapshot.data!.docs;

        String notificationMessage = '';
        String additionalInfo = '';


        if (username == 'matias') {
          notificationMessage = '¡Incendio cerca de tu zona! Prepárate a evacuar.';
          additionalInfo = 'Dirección del incendio: ${catastrofes.isNotEmpty ? catastrofes[0]['direccion'] : 'Desconocida'}\n' +
                           'Evacuar por: ${catastrofes.isNotEmpty ? catastrofes[0]['ruta'] : 'Desconocido' } hacia ${catastrofes.isNotEmpty ? catastrofes[0]['ruta2'] : 'Desconocido' }';
        } else if (username == 'loreto') {
          notificationMessage = '¡Sismo detectado en tu área!';
          additionalInfo = 'Magnitud: ${catastrofes.isNotEmpty ? catastrofes[0]['magnitud'] : 'Desconocida'}\n' +
                           'Epicentro: ${catastrofes.isNotEmpty ? catastrofes[0]['foco'] : 'Desconocido'}';
        } else {

          notificationMessage = '¡Alerta de catástrofes nuevas!';
        }

        if (notificationMessage.isEmpty) {
          return const SizedBox.shrink(); 
        }

        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 211, 47, 47),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Alerta!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image.asset(
                'assets/alerta.png',
                width: 60,
                height: 60,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notificationMessage,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                additionalInfo,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 128, 29, 29),
              ),
              child: const Text(
                'Cerrar',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}





