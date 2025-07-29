class QuestionActionModel {
  QuestionActionModel({
    required this.status,
    required this.message,
  });

  factory QuestionActionModel.fromJson(Map<String, dynamic> json) {
    return QuestionActionModel(
      status: json['status'],
      message: json['message'],
    );
  }
  final int status;
  final String message;
}
