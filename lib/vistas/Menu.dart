import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crisisconnect/vistas/Catastrofes.dart';

class Menu extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Menu({super.key});

  Future<List<Map<String, dynamic>>> obtenerCatastrofes() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('catastrofes').get();

      if (querySnapshot.docs.isEmpty) {
        print("No se encontraron catástrofes");
        return [];
      }

      return querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    } catch (e) {
      print('Error al obtener catástrofes: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Catástrofes ahora',
          style: TextStyle(
            fontFamily: 'Calistoga',
            fontSize: 30,
            color: Color(0xFFEBEBEB),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 3, 149, 162),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(  
        future: obtenerCatastrofes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar las catástrofes: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay catástrofes disponibles'));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: snapshot.data!.map((catastrofe) {
                  String tipo = catastrofe['tipo'] ?? 'desconocido';
                  String titulo = '';
                  Widget contenido = const SizedBox();

                  if (tipo == 'sismo') {
                    titulo = 'Sismo en ${catastrofe['lugar']}';
                    contenido = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Epicentro: ${catastrofe['epicentro']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Cantarell',
                            color: Color.fromARGB(255, 45, 45, 45),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Magnitud: ${catastrofe['magnitud']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Cantarell',
                            color: Color.fromARGB(255, 45, 45, 45),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Alcance: ${catastrofe['alcance']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Cantarell',
                            color: Color.fromARGB(255, 45, 45, 45),
                          ),
                        ),
                      ],
                    );
                  } else if (tipo == 'incendio') {
                    titulo = 'Incendio en ${catastrofe['lugar']}';
                    contenido = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Foco: ${catastrofe['foco']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Cantarell',
                            color: Color.fromARGB(255, 45, 45, 45),
                          ),
                        ),
                        Text(
                          'Áreas afectadas: ${catastrofe['areas_afectadas']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Cantarell',
                            color: Color.fromARGB(255, 45, 45, 45),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tipo de incendio: ${catastrofe['tipo_incendio']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Cantarell',
                            color: Color.fromARGB(255, 45, 45, 45),
                          ),
                        ),
                      ],
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        titulo,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Calistoga',
                          color: Color.fromARGB(255, 3, 149, 162),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 235, 235, 235),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            contenido,
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Catastrofes(
                                      tipo: tipo,
                                      zona: catastrofe['lugar'],
                                      epicentro: catastrofe['epicentro'] ?? '',
                                      magnitud: catastrofe['magnitud'] ?? '',
                                      alcance: catastrofe['alcance'] ?? '',
                                      probabilidadReplica: catastrofe['Probabilidad_replica'] ?? '',
                                      probabilidadTsunami: catastrofe['Probabilidad_tsunami'] ?? '',
                                      foco: catastrofe['foco'] ?? '',
                                      areasAfectadas: catastrofe['areas_afectadas'] ?? '',
                                      tipoIncendio: catastrofe['tipo_incendio'] ?? '',
                                      nivelEmergencia: catastrofe['nivel_emergencia'] ?? '',
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 245, 245, 200).withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Ver más',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xFFE2CD0E),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xFFE2CD0E),
                                      size: 24,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Center(
                        child: Divider(
                          color: Color(0xFFE2CD0E),
                          thickness: 3,
                          indent: 50,
                          endIndent: 50,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}







