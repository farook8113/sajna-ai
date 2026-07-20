import 'rag_service.dart';

class RAGEvaluationResult {
  final int totalQuestions;
  final int correctRetrievals;
  final double accuracy;
  final List<EvaluationLog> logs;

  RAGEvaluationResult({
    required this.totalQuestions,
    required this.correctRetrievals,
    required this.accuracy,
    required this.logs,
  });
}

class EvaluationLog {
  final String question;
  final int expectedPage;
  final int? retrievedPage;
  final bool isCorrect;
  final String confidence;
  final double score;

  EvaluationLog({
    required this.question,
    required this.expectedPage,
    required this.retrievedPage,
    required this.isCorrect,
    required this.confidence,
    required this.score,
  });
}

class RAGEvaluator {
  static final List<Map<String, dynamic>> _testSuite = [
    {
      'question': 'How do we arm the cabin doors on departure?',
      'expectedPage': 268,
    },
    {
      'question': 'Tell me the procedure for door disarming and cross check.',
      'expectedPage': 269,
    },
    {
      'question': 'What should I do if a passenger refuses to fasten their seat belt?',
      'expectedPage': 270,
    },
    {
      'question': 'What are the rules for infant car seats and certified chairs?',
      'expectedPage': 253,
    },
    {
      'question': 'Where should passenger wheelchairs and PRMs be seated?',
      'expectedPage': 252,
    },
    {
      'question': 'Who is allowed to sit in emergency exit rows?',
      'expectedPage': 255,
    },
    {
      'question': 'What are the medical principles of ABC patient care?',
      'expectedPage': 635,
    },
    {
      'question': 'What is the basic fire fighting drill using Halon?',
      'expectedPage': 580,
    },
    {
      'question': 'What is the evacuation drill for sea ditching survival?',
      'expectedPage': 601,
    },
    {
      'question': 'A321 Neo ACF overwing exit rows seating restrictions.',
      'expectedPage': 951,
    },
    {
      'question': 'What are the guidelines for logging defects and IQSMS safety reports?',
      'expectedPage': 1181,
    },
    {
      'question': 'Can pregnant women fly after 36 weeks without MEDIF?',
      'expectedPage': 259,
    },
  ];

  static RAGEvaluationResult runEvaluation() {
    int correctCount = 0;
    final List<EvaluationLog> logs = [];

    for (var test in _testSuite) {
      final question = test['question'] as String;
      final expectedPage = test['expectedPage'] as int;

      // Query the local TF-IDF synonym ranker
      final result = RAGService.query(question);
      final retrievedPage = result['page'] as int?;
      final isCorrect = retrievedPage == expectedPage;
      
      if (isCorrect) {
        correctCount++;
      }

      logs.add(EvaluationLog(
        question: question,
        expectedPage: expectedPage,
        retrievedPage: retrievedPage,
        isCorrect: isCorrect,
        confidence: result['confidence'] as String,
        score: result['score'] as double,
      ));
    }

    final accuracy = (correctCount / _testSuite.length) * 100;

    return RAGEvaluationResult(
      totalQuestions: _testSuite.length,
      correctRetrievals: correctCount,
      accuracy: accuracy,
      logs: logs,
    );
  }
}
