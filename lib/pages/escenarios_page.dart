import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'simulacion_page.dart';

class EscenariosPage extends StatelessWidget {
  const EscenariosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Bienvenido a Drive Master\nSelecciona un escenario',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance.collection('simulacion').get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error al cargar los escenarios'),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No hay escenarios disponibles'),
                    );
                  }

                  final escenarios = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: escenarios.length,
                    itemBuilder: (context, index) {
                      final escenario = escenarios[index];
                      final nombre = escenario['nombre'] ?? 'Escenario sin nombre';
                      final id = escenario.id;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 168, 7, 28),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SimulacionPage(
                                simulacionId: id,
                                simulacionNombre: nombre,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          nombre,
                          style: const TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context); 
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                label: const Text(
                  'Volver al Menú Principal',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[900],
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
