import 'package:drive_master/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ResultadoSimulacionPage extends StatelessWidget {
  final int correctAnswers;
  final int totalQuestions;

  const ResultadoSimulacionPage({
    super.key,
    required this.correctAnswers,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    double percentage = correctAnswers / totalQuestions;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Has conseguido:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.yellow[100]?.withOpacity(0.9),
                  border: Border.all(color: Colors.yellow[700]!, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${correctAnswers}/${totalQuestions} PREGUNTAS',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CircularPercentIndicator(
                radius: 100.0,
                lineWidth: 15.0,
                percent: percentage,
                center: Text(
                  '${(percentage * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                progressColor: Colors.green[700],
                backgroundColor: Colors.grey[300]!.withOpacity(0.7),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaginaPrincipal(),
                    ),
                  );
                },
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                label: const Text(
                  'Volver al Menú Principal',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
