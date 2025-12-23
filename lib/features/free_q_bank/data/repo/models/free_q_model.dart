class QuestionModel {
  QuestionModel({
    this.id,
    this.question,
    this.answer,
    this.explanation,
    required this.options,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final List<QuestionOption> tempOptions = [];
    if (json['a'] != null) {
      tempOptions.add(QuestionOption(key: 'a', value: json['a']));
    }
    if (json['b'] != null) {
      tempOptions.add(QuestionOption(key: 'b', value: json['b']));
    }
    if (json['c'] != null) {
      tempOptions.add(QuestionOption(key: 'c', value: json['c']));
    }
    if (json['d'] != null) {
      tempOptions.add(QuestionOption(key: 'd', value: json['d']));
    }

    return QuestionModel(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
      explanation: json['explanation'],
      options: tempOptions,
    );
  }
  final int? id;
  final String? question;
  final String? answer;
  final String? explanation;
  final List<QuestionOption> options;
  String? selectedAnswer;
}

class QuestionOption {
  QuestionOption({this.key, this.value});
  final String? key;
  final String? value;
}
