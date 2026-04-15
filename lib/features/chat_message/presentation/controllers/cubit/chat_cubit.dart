import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // ستحتاج هذه الحزمة لجلب الوقت الحالي
import 'package:smle/features/chat_message/data/models/chat_message_model.dart';
import 'package:smle/features/chat_message/data/repo/chat_repo.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(ChatRepo chatRepo)
    : _chatRepo = chatRepo,
      super(ChatUpdated(messages: []));

  final ChatRepo _chatRepo;
  final List<ChatMessage> _messages = [];

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // 1. إضافة رسالة المستخدم إلى القائمة
    final currentTime = DateFormat('hh:mm a').format(DateTime.now());
    _messages.add(ChatMessage(text: text, time: currentTime, isUser: true));

    // تحديث الشاشة وإظهار أن البوت "يكتب..."
    emit(ChatUpdated(messages: List.from(_messages), isTyping: true));

    // 2. الاتصال الفعلي بالـ API من خلال الـ Repository
    // افترضت هنا أن الدالة في الـ Repo تأخذ نص الرسالة كـ Parameter
    final result = await _chatRepo.sendMessage(text);

    // 3. التعامل مع النتيجة (Success or Failure)
    result.when(
      success: (response) {
        // response هنا يمثل الـ Model العائد من الـ Repo (مثلاً ChatMessage)
        _messages.add(response);

        // إخفاء مؤشر الكتابة وتحديث القائمة
        emit(ChatUpdated(messages: List.from(_messages), isTyping: false));
      },
      failure: (failure) {
        // في حالة حدوث خطأ من السيرفر (مثل انقطاع الإنترنت أو خطأ 500)
        _messages.add(
          ChatMessage(
            text: failure.errMessage,
            time: DateFormat('hh:mm a').format(DateTime.now()),
            isUser: false,
          ),
        );

        emit(ChatUpdated(messages: List.from(_messages), isTyping: false));
      },
    );
  }
}
