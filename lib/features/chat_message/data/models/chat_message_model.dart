// chat_message_model.dart

class ChatMessage {
  // لتحديد ما إذا كانت الرسالة من المستخدم أم من البوت

  ChatMessage({required this.text, required this.time, this.isUser = false});

  // دالة لتحويل الـ JSON القادم من السيرفر (البوت) إلى موديل
  factory ChatMessage.fromBotJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['reply'] ?? '',
      time: json['time'] ?? '',
      isUser: false, // الرسالة القادمة من السيرفر دائمًا تكون من البوت
    );
  }
  final String text;
  final String time;
  final bool isUser;
}
