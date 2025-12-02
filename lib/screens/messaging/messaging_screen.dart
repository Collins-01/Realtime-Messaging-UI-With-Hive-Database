import 'package:flutter/material.dart';
import '../../widgets/chat_input.dart';
import 'components/chat_app_bar.dart';
import 'components/message_list.dart';
import 'components/emoji_picker_panel.dart';
import 'messaging_viewmodel.dart';
import '../dashboard_screen.dart';

class MessagingScreen extends StatefulWidget {
  const MessagingScreen({super.key});

  @override
  State<MessagingScreen> createState() => _MessagingScreenState();
}

class _MessagingScreenState extends State<MessagingScreen> {
  late final MessagingViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = MessagingViewModel();
    _viewModel.initialize();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _openDashboard() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          appBar: ChatAppBar(
            title: 'Support Chat',
            agentName: 'Agent Sarah',
            isAgentOnline: true,
            unreadCount: _viewModel.unreadCount,
            onMenuPressed: _openDashboard,
            onSearchPressed: () {
              // Search functionality can be added here
            },
            onNotificationPressed: _viewModel.markAllAsRead,
          ),
          body: _viewModel.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(
                      child: MessageList(
                        messages: _viewModel.messages,
                        scrollController: _viewModel.scrollController,
                      ),
                    ),
                    EmojiPickerPanel(
                      isVisible: _viewModel.showEmojiPicker,
                      onEmojiSelected: _viewModel.handleEmojiSelected,
                    ),
                    ChatInput(
                      onSendMessage: _viewModel.sendMessage,
                      onEmojiTap: _viewModel.toggleEmojiPicker,
                    ),
                  ],
                ),
        );
      },
    );
  }
}
