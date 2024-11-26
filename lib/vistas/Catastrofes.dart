import 'package:flutter/material.dart';

class Catastrofes extends StatelessWidget {
  final String tipo;
  final String zona;
  final String epicentro;
  final String magnitud;
  final String alcance;
  final String probabilidadReplica;
  final String probabilidadTsunami;
  final String foco;
  final String areasAfectadas;
  final String tipoIncendio;
  final String nivelEmergencia;

  const Catastrofes({
    super.key,
    required this.tipo,
    required this.zona,
    required this.epicentro,
    required this.magnitud,
    required this.alcance,
    required this.probabilidadReplica,
    required this.probabilidadTsunami,
    required this.foco,
    required this.areasAfectadas,
    required this.tipoIncendio,
    required this.nivelEmergencia,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Alerta de catástrofe',
          style: TextStyle(
            fontFamily: 'Calistoga',
            fontSize: 30,
            color: Color(0xFFEBEBEB),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 3, 149, 162),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Zona de crisis: $zona',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Calistoga',
                color: Color.fromARGB(255, 3, 149, 162),
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            const Center(
              child: Divider(
                color: Color(0xFFE2CD0E),
                thickness: 3,
                indent: 50,
                endIndent: 50,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(232, 161, 184, 185),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (tipo == 'sismo') _detalleSismo(),
                  if (tipo == 'incendio') _detalleIncendio(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detalleSismo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _detalleFila('Epicentro:', epicentro),
        _detalleFila('Magnitud:', magnitud.toString()),
        _detalleFila('Alcance:', alcance),
        _detalleFila('Probabilidad de réplicas:', probabilidadReplica),
        _detalleFila('Probabilidad de tsunami:', probabilidadTsunami),
      ],
    );
  }

  Widget _detalleIncendio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _detalleFila('Foco:', foco),
        _detalleFila('Áreas afectadas:', areasAfectadas),
        _detalleFila('Tipo de incendio:', tipoIncendio),
        _detalleFila('Nivel de incendio:', nivelEmergencia),
      ],
    );
  }

  Widget _detalleFila(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$etiqueta ',
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Cantarell',
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 235, 235, 235),
            ),
          ),
          Expanded(
            child: Text(
              valor,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Cantarell',
                color: Color.fromARGB(255, 235, 235, 235),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


