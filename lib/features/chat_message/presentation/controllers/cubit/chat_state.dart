part of 'chat_cubit.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatUpdated extends ChatState {
  // لإظهار مؤشر أن البوت "يكتب الآن..."

  ChatUpdated({required this.messages, this.isTyping = false});
  final List<ChatMessage> messages;
  final bool isTyping;
}
