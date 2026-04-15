import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smle/core/functions/responsive_config.dart';
import 'package:smle/core/shared_widgets/custom_app_bar.dart';
import 'package:smle/core/theme/colors.dart';
import 'package:smle/core/theme/text_styles.dart';
import 'package:smle/features/chat_message/data/models/chat_message_model.dart';
import 'package:smle/features/chat_message/presentation/controllers/cubit/chat_cubit.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 300), () {
          _scrollToBottom();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'SMLE Gate AI'),
      body: Container(
        decoration: BoxDecoration(gradient: appGradientHelper),
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<ChatCubit, ChatState>(
                listener: (context, state) {
                  if (state is ChatUpdated) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToBottom();
                    });
                  }
                },
                builder: (context, state) {
                  if (state is ChatUpdated) {
                    final messages = state.messages;

                    return ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(16.r),
                      itemCount: messages.length + (state.isTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == messages.length && state.isTyping) {
                          return Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: Padding(
                              padding: EdgeInsets.all(8.r),
                              child: Text(
                                'SMLE Gate AI is typing...',
                                style: AppTextStyle.style12W500.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          );
                        }

                        final message = messages[index];
                        return _buildChatBubble(message);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            _buildMessageInput(context),
          ],
        ),
      ),
    );
  }

  bool _isArabic(String text) {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) return false;

    final int charCode = trimmedText.codeUnitAt(0);
    return charCode >= 0x0600 && charCode <= 0x06FF;
  }

  Widget _buildChatBubble(ChatMessage message) {
    final isUser = message.isUser;

    final isArabicText = _isArabic(message.text);

    return Align(
      alignment: isUser
          ? AlignmentDirectional.centerStart
          : AlignmentDirectional.centerEnd,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primaryColor : AppColors.darkGreyColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isUser
                ? const Radius.circular(0)
                : Radius.circular(12.r),
            bottomRight: isUser
                ? Radius.circular(12.r)
                : const Radius.circular(0),
          ),
          border: Border.all(color: Colors.grey.shade300, width: 0.5),
        ),

        child: Directionality(
          textDirection: isArabicText ? TextDirection.rtl : TextDirection.ltr,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.text,
                style: AppTextStyle.style14W500.copyWith(height: 1.4),
              ),
              4.verticalSpace,
              Text(
                message.time,
                style: AppTextStyle.style9W500.copyWith(
                  color: AppColors.offwhiteColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.iconColorBlack,
            AppColors.iconColorGray,
            AppColors.primaryDColor,
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Type your message here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200.withAlpha(100),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                onSubmitted: (value) {
                  context.read<ChatCubit>().sendMessage(value);
                  _controller.clear();
                },
              ),
            ),

            8.horizontalSpace,

            CircleAvatar(
              backgroundColor: AppColors.secondaryColor,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () {
                  context.read<ChatCubit>().sendMessage(_controller.text);
                  _controller.clear();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
