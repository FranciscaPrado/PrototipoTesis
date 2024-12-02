import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:crisisconnect/vistas/Menu.dart';

class CrearUsuario extends StatefulWidget {
  const CrearUsuario({super.key});

  @override
  _CrearUsuarioState createState() => _CrearUsuarioState();
}

class _CrearUsuarioState extends State<CrearUsuario> {
  final _formKey = GlobalKey<FormState>();
  String? selectedRegion;
  String? selectedCity;
  final TextEditingController phoneController = TextEditingController(text: '+569');
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  Set<Marker> _markers = {};
  LatLng _initialLocation = const LatLng(-33.4489, -70.6693); // Santiago
  LatLng? _selectedLocation;

  late GoogleMapController _mapController;

  final Map<String, List<String>> regionCities =  {
    'Arica y Parinacota': ['Arica', 'Putre', 'Camarones', 'General Lagos'],
    'Tarapacá': ['Iquique', 'Alto Hospicio', 'Pozo Almonte', 'Pica', 'Huara', 'Camiña', 'Colchane'],
    'Antofagasta': ['Antofagasta', 'Calama', 'Tocopilla', 'Mejillones', 'San Pedro de Atacama', 'Taltal'],
    'Atacama': ['Copiapó', 'Caldera', 'Vallenar', 'Chañaral', 'Tierra Amarilla', 'Freirina', 'Huasco'],
    'Coquimbo': ['La Serena', 'Coquimbo', 'Ovalle', 'Illapel', 'Vicuña', 'Monte Patria', 'Combarbalá', 'Los Vilos'],
    'Valparaíso': ['Valparaíso', 'Viña del Mar', 'Quilpué', 'Villa Alemana', 'San Antonio', 'Quillota', 'San Felipe', 'Los Andes'],
    'Metropolitana de Santiago': ['Santiago', 'Puente Alto', 'Maipú', 'La Florida', 'Las Condes', 'San Bernardo', 'Pudahuel', 'Ñuñoa', 'Lo Prado'],
    'O’Higgins': ['Rancagua', 'San Fernando', 'Pichilemu', 'Santa Cruz', 'Rengo', 'Machalí', 'Graneros', 'Chimbarongo'],
    'Maule': ['Talca', 'Curicó', 'Linares', 'Cauquenes', 'Constitución', 'Molina', 'Parral', 'San Javier'],
    'Ñuble': ['Chillán', 'San Carlos', 'Coihueco', 'Quirihue', 'Bulnes', 'Yungay', 'El Carmen', 'Cobquecura'],
    'Biobío': ['Concepción', 'Los Ángeles', 'Talcahuano', 'Coronel', 'Chiguayante', 'San Pedro de la Paz', 'Hualpén', 'Lota'],
    'La Araucanía': ['Temuco', 'Villarrica', 'Pucón', 'Angol', 'Victoria', 'Nueva Imperial', 'Collipulli', 'Carahue'],
    'Los Ríos': ['Valdivia', 'La Unión', 'Río Bueno', 'Panguipulli', 'Futrono', 'Paillaco', 'Lanco', 'Máfil'],
    'Los Lagos': ['Puerto Montt', 'Osorno', 'Castro', 'Ancud', 'Quellón', 'Puerto Varas', 'Frutillar', 'Calbuco'],
    'Aysén': ['Coyhaique', 'Puerto Aysén', 'Chile Chico', 'Puerto Cisnes', 'Cochrane', 'Tortel', 'Villa O’Higgins'],
    'Magallanes y de la Antártica Chilena': ['Punta Arenas', 'Puerto Natales', 'Porvenir', 'Puerto Williams', 'Cabo de Hornos', 'Laguna Blanca', 'San Gregorio'],
  };

  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> saveUserData() async {
    try {
      final userData = {
        'username': usernameController.text,
        'phone': phoneController.text,
        'region': selectedRegion,
        'city': selectedCity,
        'address': addressController.text,
        'latitude': _selectedLocation?.latitude,
        'longitude': _selectedLocation?.longitude,
        'created_at': FieldValue.serverTimestamp(),
      };

      await db.collection('users').add(userData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario guardado con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar usuario: $e')),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

void _searchAndSelectAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        LatLng selectedLatLng = LatLng(locations.first.latitude, locations.first.longitude);
        setState(() {
          _selectedLocation = selectedLatLng;
          _markers.clear();
          _markers.add(Marker(
            markerId: const MarkerId('selected_location'),
            position: selectedLatLng,
            infoWindow: const InfoWindow(title: 'Ubicación seleccionada'),
          ));
        });

        // Mueve la cámara hacia la ubicación seleccionada
        _mapController.animateCamera(
          CameraUpdate.newLatLngZoom(selectedLatLng, 15), // Nivel de zoom ajustable
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al buscar la dirección: $e')),
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Crear usuario',
          style: TextStyle(
            fontFamily: 'Calistoga',
            fontSize: 30,
            color: Color(0xFFEBEBEB),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 3, 149, 162),
      ),
       body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de usuario',
                        labelStyle: TextStyle(color: Color.fromARGB(255, 3, 149, 162)),
                        filled: true,
                        fillColor: Color.fromARGB(255, 171, 196, 198),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 235, 235, 235),
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
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Número telefónico',
                        labelStyle: TextStyle(color: Color.fromARGB(255, 3, 149, 162)),
                        filled: true,
                        fillColor: Color.fromARGB(255, 171, 196, 198),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 235, 235, 235),
                        fontSize: 16, 
                      ),
                      inputFormatters: [LengthLimitingTextInputFormatter(12)],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingresa tu número telefónico';
                        }
                        if (!RegExp(r'^\+569\d{8}$').hasMatch(value)) {
                          return 'Formato inválido: +569XXXXXXXX';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: DropdownButtonFormField<String>(
                      iconEnabledColor: Colors.white,
                      value: selectedRegion,
                      decoration: const InputDecoration(
                        labelText: 'Selecciona una región',
                        labelStyle: TextStyle(color: Color.fromARGB(255, 3, 149, 162)),
                        filled: true,
                        fillColor: Color.fromARGB(255, 171, 196, 198),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 235, 235, 235),
                        fontSize: 16, 
                      ),
                      items: regionCities.keys.map((String region) {
                        return DropdownMenuItem<String>(
                          value: region,
                          child: Text(region),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedRegion = value;
                          selectedCity = null; 
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor selecciona una región';
                        }
                        return null;
                      },
                      dropdownColor: const Color.fromARGB(255, 171, 196, 198),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: DropdownButtonFormField<String>(
                      iconEnabledColor: Colors.white,
                      value: selectedCity,
                      decoration: const InputDecoration(
                        labelText: 'Selecciona una ciudad',
                        labelStyle: TextStyle(color: Color.fromARGB(255, 3, 149, 162)),
                        filled: true,
                        fillColor: Color.fromARGB(255, 171, 196, 198),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 235, 235, 235),
                        fontSize: 16, 
                      ),
                      items: (selectedRegion == null)
                          ? []
                          : regionCities[selectedRegion]!.map((String city) {
                              return DropdownMenuItem<String>(
                                value: city,
                                child: Text(city),
                              );
                            }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCity = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor selecciona una ciudad';
                        }
                        return null;
                      },
                      dropdownColor: const Color.fromARGB(255, 171, 196, 198),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        labelText: 'Dirección',
                        labelStyle: TextStyle(color: Color.fromARGB(255, 3, 149, 162)),
                        filled: true,
                        fillColor: Color.fromARGB(255, 171, 196, 198),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 235, 235, 235),
                        fontSize: 16, 
                      ),
                      onFieldSubmitted: (value) => _searchAndSelectAddress(value),
                      ),
                    ),
                    const SizedBox(height: 20), 
                    SizedBox(
                      height: 300,
                      child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        markers: _markers,
                        onTap: (LatLng position) {
                          setState(() {
                            _selectedLocation = position;
                            _markers.clear();
                            _markers.add(Marker(
                              markerId: const MarkerId('selected_location'),
                              position: position,
                              infoWindow: const InfoWindow(title: 'Ubicación seleccionada'),
                            ));
                          });
                        },
                        initialCameraPosition: CameraPosition(
                          target: _initialLocation,
                          zoom: 10,
                        ),
                      ),
                    ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        saveUserData();
                        MaterialPageRoute(builder: (context) => Menu());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D2D2D),
                    ),
                    child: const Text(
                      'Crear usuario',
                      style: TextStyle(
                        fontFamily: 'Calistoga',
                        fontSize: 20,
                        color: Color(0xFFABC4C6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

