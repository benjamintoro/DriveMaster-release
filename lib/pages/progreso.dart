import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:drive_master/pages/home_page.dart';


Future<void> guardarProgreso(String userId, String leccionId, double progreso) async {
  final userProgressRef = FirebaseFirestore.instance.collection('progresos').doc(userId);
  
  await userProgressRef.set({
    leccionId: progreso,
  }, SetOptions(merge: true)); 
}

class ProgresoPage extends StatelessWidget {
  const ProgresoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                const Text(
                  'Mi progreso',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildProgressRow('Lección 1:', 0.8, Colors.green),
                const SizedBox(height: 10),
                _buildProgressRow('Lección 2:', 0.5, Colors.yellow),
                const SizedBox(height: 10),
                _buildProgressRow('Lección 3:', 0.25, Colors.red),
                const SizedBox(height: 10),
                _buildProgressRow('Lección 4:', 0.0, Colors.white),
                const SizedBox(height: 10),
                _buildProgressRow('Lección 5:', 0.4, Colors.white),
                const SizedBox(height: 20), 
                ElevatedButton.icon(
                  onPressed: () {
                    guardarProgreso('userIdEjemplo', 'leccion1', 0.8);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PaginaPrincipal()),
                    );
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  label: const Text('Volver al Menú Principal'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }

  Widget _buildProgressRow(String title, double progress, Color color) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300],
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '${(progress * 100).toInt()}%',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
