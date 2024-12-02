import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Catastrofes extends StatefulWidget {
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
  final String direccion;

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
    required this.direccion,
  });

  @override
  _CatastrofesState createState() => _CatastrofesState();
}

class _CatastrofesState extends State<Catastrofes> {
  late GoogleMapController _mapController;
  LatLng _mapLocation = LatLng(0.0, 0.0); 
  bool _isLocationReady = false; 

  @override
  void initState() {
    super.initState();
    _getCatastrofeLocation(); 
  }

 
  void _getCatastrofeLocation() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('catastrofes') 
        .where('tipo', isEqualTo: widget.tipo) 
        .where('lugar', isEqualTo: widget.zona)
        .limit(1) 
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      var data = querySnapshot.docs.first.data();
      if (data['LatLng'] != null) {
        GeoPoint geoPoint = data['LatLng']; 

        setState(() {
          _mapLocation = LatLng(geoPoint.latitude, geoPoint.longitude);
          _isLocationReady = true; 
        });
      }
    }
  }

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
              'Zona de crisis: ${widget.zona}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Calistoga',
                color: Color.fromARGB(255, 3, 149, 162),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              height: 250,
              child: _isLocationReady
                  ? GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _mapLocation, 
                        zoom: 15.0, 
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId('catastrofe'),
                          position: _mapLocation,
                          infoWindow: const InfoWindow(
                            title: 'Ubicación de la catástrofe',
                          ),
                        ),
                      },
                      onMapCreated: (GoogleMapController controller) {
                        _mapController = controller;
                      },
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
            const Center(
              child: Divider(
                color: Color(0xFFE2CD0E),
                thickness: 3,
                indent: 50,
                endIndent: 50,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${widget.tipo} en ${widget.zona}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cantarell',
                color: Color(0xFFE2CD0E),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(179, 236, 236, 233),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.tipo == 'sismo') _detalleSismo(),
                  if (widget.tipo == 'incendio') _detalleIncendio(),
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
        _detalleFila('Epicentro:', widget.epicentro),
        _detalleFila('Magnitud:', widget.magnitud),
        _detalleFila('Alcance:', widget.alcance),
        _detalleFila('Probabilidad de réplicas:', widget.probabilidadReplica),
        _detalleFila('Probabilidad de tsunami:', widget.probabilidadTsunami),
      ],
    );
  }

  Widget _detalleIncendio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _detalleFila('Foco:', widget.foco),
        _detalleFila('Áreas afectadas: ', widget.areasAfectadas),
        _detalleFila('Tipo de incendio: ', widget.tipoIncendio),
        _detalleFila('Nivel de emergencia: ', widget.nivelEmergencia),
        _detalleFila('Dirección: ', widget.direccion),
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
              color: Color.fromARGB(255, 3, 149, 162),
            ),
          ),
          Expanded(
            child: Text(
              valor,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Cantarell',
                color: Color.fromARGB(255, 3, 149, 162),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



