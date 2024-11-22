import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'resultado_cuestionario.dart';

class CuestionarioPage extends StatefulWidget {
  final String lessonId; 

  const CuestionarioPage({super.key, required this.lessonId});

  @override
  _CuestionarioPageState createState() => _CuestionarioPageState();
}

class _CuestionarioPageState extends State<CuestionarioPage> {
  int _currentQuestionIndex = 0;
  List<Map<String, dynamic>> _questions = [];
  String _selectedAnswer = '';
  int _correctAnswers = 0;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

void _loadQuestions() async {
  try {
    final lessonDoc = await FirebaseFirestore.instance
        .collection('leccion')
        .doc(widget.lessonId)
        .get();

    if (lessonDoc.exists) {
      final lessonData = lessonDoc.data();
      if (lessonData != null && lessonData['preguntas'] != null) {
        final quizData = List<Map<String, dynamic>>.from(lessonData['preguntas']);

        setState(() {
          _questions = quizData.map((question) {
            return {
              'question': question['pregunta'] ?? 'Pregunta no disponible',
              'answers': List<String>.from(question['respuestas'] ?? []),
              'correctAnswer': question['correcta'] ?? '',
            };
          }).toList();
        });
      } else {
        print('No hay preguntas disponibles para esta lección.');
      }
    } else {
      print('El documento de la lección no existe.');
    }
  } catch (e) {
    print('Error al cargar preguntas: $e');
  }
}


  void _nextQuestion() {
    if (_selectedAnswer ==
        _questions[_currentQuestionIndex]['correctAnswer']) {
      _correctAnswers++;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('¡Correcto!')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Incorrecto.')));
    }

    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _selectedAnswer = '';
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultadoCuestionarioPage(
              correctAnswers: _correctAnswers,
              totalQuestions: _questions.length,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(title: const Text('Cuestionario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_questions.isEmpty)
              const CircularProgressIndicator()
            else
              Text(
                _questions[_currentQuestionIndex]['question'] as String,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 20),
            if (_questions.isNotEmpty)
              ...(_questions[_currentQuestionIndex]['answers']
                      as List<String>)
                  .map((answer) {
                return RadioListTile<String>(
                  title: Text(answer),
                  value: answer,
                  groupValue: _selectedAnswer,
                  onChanged: (value) {
                    setState(() {
                      _selectedAnswer = value!;
                    });
                  },
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
    );
  }
}
