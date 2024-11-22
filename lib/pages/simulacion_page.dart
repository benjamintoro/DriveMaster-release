import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_master/pages/resultados_simulacion.dart';

class SimulacionPage extends StatefulWidget {
  final String simulacionId;
  final String simulacionNombre;

  const SimulacionPage({
    super.key,
    required this.simulacionId,
    required this.simulacionNombre,
  });

  @override
  _SimulacionPageState createState() => _SimulacionPageState();
}

class _SimulacionPageState extends State<SimulacionPage> {
  int _currentQuestionIndex = 0;
  List<Map<String, dynamic>> _questions = [];
  String _selectedAnswer = '';
  int _correctAnswers = 0;
  late Timer _timer;
  double _progress = 1.0;
  static const int _timerDuration = 10; 

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _loadQuestions() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('simulacion')
          .doc(widget.simulacionId)
          .get();

      if (doc.exists) {
        final data = doc.data();
        if (data != null && data['preguntas'] != null) {
          final List<dynamic> preguntasRaw = data['preguntas'];
          final List<Map<String, dynamic>> quizData = preguntasRaw.map((pregunta) {
            return {
              'question': pregunta['pregunta'] ?? 'Pregunta no disponible',
              'answers': List<String>.from(pregunta['respuestas']),
              'correctAnswer': pregunta['correcta'] ?? '',
            };
          }).toList();

          setState(() {
            _questions = quizData;
            _startTimer();
          });
        }
      }
    } catch (e) {
      print('Error al cargar las preguntas: $e');
    }
  }

  void _startTimer() {
    _progress = 1.0;
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        if (_progress > 0) {
          _progress -= 0.01 / _timerDuration;
        } else {
          _timer.cancel();
          _nextQuestion();
        }
      });
    });
  }

  void _nextQuestion() {
    if (_selectedAnswer == _questions[_currentQuestionIndex]['correctAnswer']) {
      _correctAnswers++;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Correcto!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incorrecto.')),
      );
    }

    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _selectedAnswer = '';
        _startTimer();
      } else {
        _timer.cancel();
        _navigateToResults();
      }
    });
  }

  void _navigateToResults() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultadoSimulacionPage(
          correctAnswers: _correctAnswers,
          totalQuestions: _questions.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/scenes/${widget.simulacionId}.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/scenes/default.png',
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _questions.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LinearProgressIndicator(
                          value: _progress,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation(Colors.green),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _questions[_currentQuestionIndex]['question'] as String,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ...(_questions[_currentQuestionIndex]['answers']
                                as List<String>)
                            .map((answer) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: RadioListTile<String>(
                              title: Text(
                                answer,
                                style: const TextStyle(color: Colors.black),
                              ),
                              value: answer,
                              groupValue: _selectedAnswer,
                              onChanged: (value) {
                                setState(() {
                                  _selectedAnswer = value!;
                                });
                              },
                            ),
                          );
                        }),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _selectedAnswer.isEmpty ? null : _nextQuestion,
                          child: const Text('Siguiente'),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
