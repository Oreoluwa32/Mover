import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../core/app_export.dart';
import '../../data/services/account_api_service.dart';
import '../../data/services/mobility_api_service.dart';
import '../../widgets/movr_loading_indicator.dart';

class TaskChatScreen extends StatefulWidget {
  const TaskChatScreen({Key? key}) : super(key: key);

  @override
  State<TaskChatScreen> createState() => _TaskChatScreenState();
}

class _TaskChatScreenState extends State<TaskChatScreen> {
  final MobilityApiService _mobilityApiService = MobilityApiService();
  final AccountApiService _accountApiService = AccountApiService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _pollTimer;
  bool _isLoading = true;
  bool _isSending = false;
  String _errorMessage = '';
  String _currentUserId = '';
  List<Map<String, dynamic>> _messages = const <Map<String, dynamic>>[];

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await _loadMessages();
      _pollTimer = Timer.periodic(
        const Duration(seconds: 5),
        (_) => _loadMessages(silent: true),
      );
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            const <String, dynamic>{};
    final participantName = args['participantName']?.toString() ?? 'Task chat';

    return Scaffold(
      backgroundColor: theme.colorScheme.onPrimary,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.onPrimary,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: NavigatorService.goBack,
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(
          participantName,
          style: CustomTextStyles.titleMediumGray80001,
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _buildBody()),
          _buildComposer(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: MovrLoadingIndicator(
          size: 42.h,
          label: 'Loading messages...',
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.h),
          child: Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    if (_messages.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.h),
          child: Text(
            'No messages yet. Start the conversation here.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    return ListView.separated(
      controller: _scrollController,
      padding: EdgeInsets.fromLTRB(16.h, 16.h, 16.h, 20.h),
      itemCount: _messages.length,
      separatorBuilder: (_, __) => SizedBox(height: 10.h),
      itemBuilder: (context, index) {
        final message = _messages[index];
        final sender = Map<String, dynamic>.from(
          message['sender'] as Map? ?? const <String, dynamic>{},
        );
        final senderId = sender['id']?.toString() ?? '';
        final isMine = senderId.isNotEmpty && senderId == _currentUserId;
        final body = message['body']?.toString() ?? '';
        final createdAt =
            DateTime.tryParse(message['created_at']?.toString() ?? '')
                ?.toLocal();

        return Align(
          alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 260.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 12.h),
              decoration: BoxDecoration(
                color: isMine
                    ? theme.colorScheme.primary
                    : const Color(0xFFF5F5F7),
                borderRadius: BorderRadius.circular(16.h),
              ),
              child: Column(
                crossAxisAlignment:
                    isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    body,
                    style: TextStyle(
                      fontSize: 14.fSize,
                      height: 1.45,
                      color: isMine ? Colors.white : const Color(0xFF1D1D1F),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    _formatTime(createdAt),
                    style: TextStyle(
                      fontSize: 11.fSize,
                      color: isMine
                          ? Colors.white.withValues(alpha: 0.8)
                          : const Color(0xFF7C7C80),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildComposer() {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.h, 12.h, 16.h, 16.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.onPrimary,
          border: Border(
            top: BorderSide(
              color: appTheme.gray20001,
              width: 1.h,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                minLines: 1,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.h,
                    vertical: 14.h,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.h),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.h),
            SizedBox(
              width: 52.h,
              height: 52.h,
              child: ElevatedButton(
                onPressed: _isSending ? null : _sendMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.h),
                  ),
                ),
                child: _isSending
                    ? MovrLoadingIndicator(
                        size: 16.h,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      )
                    : Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 22.h,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadMessages({bool silent = false}) async {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            const <String, dynamic>{};
    final matchId = args['matchId']?.toString() ?? '';
    if (matchId.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Task information is missing.';
        });
      }
      return;
    }

    if (!silent && mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
    }

    try {
      if (_currentUserId.isEmpty) {
        final me = await _accountApiService.getMe();
        final user = Map<String, dynamic>.from(me['user'] as Map? ?? const {});
        _currentUserId = user['id']?.toString() ?? '';
      }

      final messages =
          await _mobilityApiService.getMatchMessages(matchId: matchId);
      if (!mounted) {
        return;
      }

      setState(() {
        _messages = messages;
        _isLoading = false;
        _errorMessage = '';
      });
      _scrollToBottom();
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _errorMessage = _mobilityApiService.extractErrorMessage(error);
      });
    }
  }

  Future<void> _sendMessage() async {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
            const <String, dynamic>{};
    final matchId = args['matchId']?.toString() ?? '';
    final body = _messageController.text.trim();

    if (matchId.isEmpty) {
      Fluttertoast.showToast(msg: 'Task information is missing.');
      return;
    }
    if (body.isEmpty) {
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      await _mobilityApiService.sendMatchMessage(
        matchId: matchId,
        body: body,
      );
      _messageController.clear();
      if (!mounted) {
        return;
      }
      setState(() {
        _isSending = false;
      });
      await _loadMessages(silent: true);
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSending = false;
      });
      Fluttertoast.showToast(
        msg: _mobilityApiService.extractErrorMessage(error),
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  String _formatTime(DateTime? value) {
    if (value == null) {
      return '';
    }
    final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
    final minute = value.minute.toString().padLeft(2, '0');
    final period = value.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
