import 'package:drive_master/pages/cuestionario_page.dart';
import 'package:drive_master/pages/escenarios_page.dart';
import 'package:drive_master/pages/progreso.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_master/pages/profile_page.dart'; 

void main() {
  runApp(const PaginaPrincipal());
}

class PaginaPrincipal extends StatelessWidget {
  const PaginaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drive Master',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;


  final List<Widget> _pages = [
    const LessonsPage(), 
    const ProfilePage1(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      body: _pages[_currentIndex], 
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black54,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Lecciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class LessonsPage extends StatelessWidget {
  const LessonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Bienvenido a Drive Master',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Selecciona una Lección',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            _buildLessonButton(
              context, 
              'Lección 1: Señales de Tránsito', 
              'DLa1iEnLvmWe4PXlOyF3', 
              const Color.fromARGB(255, 235, 206, 121), 
              Colors.black,
            ),
            const SizedBox(height: 20),
            _buildLessonButton(
              context, 
              'Lección 2: Reglas de Prioridad', 
              'pdX6tQaH5bjwrg9S2CDg', 
              const Color.fromARGB(255, 242, 188, 88), 
              Colors.black,
            ),
            const SizedBox(height: 20),
            _buildLessonButton(
              context, 
              'Lección 3: Seguridad en el Vehículo', 
              'hIQ1CNz2QCBVpMMm6H01', 
              const Color.fromARGB(255, 221, 150, 60), 
              Colors.black,
            ),
            const SizedBox(height: 20),
            _buildLessonButton(
              context, 
              'Lección 4: Conocimiento del Vehículo', 
              'hXbzgZQKmIy7t5CsNNw6', 
              const Color.fromARGB(255, 188, 120, 40), 
              Colors.white,
            ),
            const SizedBox(height: 20),
            _buildLessonButton(
              context, 
              'Lección 5: Conducción Responsable', 
              'fL8KJV0i2YgIu6FKZ24V', 
              const Color.fromARGB(255, 150, 90, 30), 
              Colors.white,
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EscenariosPage()),
                );
              },
                icon: const Icon(Icons.terrain, color: Colors.white, size: 16), 
                label: const Text(
                  'Sección de Escenarios',
                  style: TextStyle(color: Colors.white, fontSize: 14), 
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20), 
                ),
              ),
              const SizedBox(height: 10), 
              ElevatedButton.icon(
                onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProgresoPage()),
                );
                },
                icon: const Icon(Icons.bar_chart, color: Colors.white, size: 16), 
                label: const Text(
                  'Ver Estadísticas',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20), 
                ),
              ),
          ],
        ),
      ),
    );
  }


  ElevatedButton _buildLessonButton(
      BuildContext context, String lessonTitle, String lessonId, Color backgroundColor, Color textColor) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor, 
        foregroundColor: textColor,       
      ),
      onPressed: () {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LeccionPage(lessonId: lessonId, lessonTitle: lessonTitle),
          ),
        );
      },
      child: Text(lessonTitle),
    );
  }
}

class LeccionPage extends StatelessWidget {
  final String lessonId;
  final String lessonTitle;

  const LeccionPage({super.key, required this.lessonId, required this.lessonTitle});

  Future<Map<String, dynamic>?> _fetchLessonContent() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('leccion')
          .doc(lessonId) 
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
    } catch (e) {
      print("Error al obtener la lección: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[200],
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>?>( 
          future: _fetchLessonContent(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error al cargar la lección."));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text("No se encontró la lección."));
            }

            final lessonData = snapshot.data!;
            final title = lessonData['titulo'] ?? 'Título no disponible';
            final content = lessonData['contenido'] ?? 'Contenido no disponible';

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      content,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CuestionarioPage(
                                lessonId: lessonId, 
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.quiz, color: Colors.white), 
                        label: const Text(
                          'Comenzar el Cuestionario',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 1, 65, 15), 
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), 
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
