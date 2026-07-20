import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import '../core/theme.dart';
import '../core/connectivity.dart';
import '../services/rag_service.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final Map<String, dynamic>? ref;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.ref,
  });
}

class ChatView extends ConsumerStatefulWidget {
  final Function(int, int) onJumpToManual;
  const ChatView({super.key, required this.onJumpToManual});

  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Hello! I am SAJNA, your offline Safety Assistant. I have cached the entire Cabin Safety Procedure Manual (Rev 18).\n\n"
          "You can ask me questions like:\n"
          "• \"How do we arm the cabin doors?\"\n"
          "• \"What is the drill for a lithium battery fire?\"\n"
          "• \"What is the exit row seating policy?\"",
      isUser: false,
    ),
  ];

  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  
  // Speech Recognition variables
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _voiceText = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final query = _textController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: query, isUser: true));
      _textController.clear();
    });
    
    _scrollToBottom();

    // Query RAG Service after delay
    Future.delayed(const Duration(milliseconds: 600), () {
      final isOnline = ref.read(connectivityProvider);
      final aiMode = ref.read(syncProvider); // watch preferences

      final result = RAGService.query(query, forceOnline: isOnline);
      
      setState(() {
        _messages.add(ChatMessage(
          text: result['answer'],
          isUser: false,
          ref: result['found'] == true ? result : null,
        ));
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _toggleSpeechInput() async {
    // 1. Request microphone permissions natively
    final permission = await Permission.microphone.request();
    if (!permission.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Microphone permission is required for voice dictation."),
          backgroundColor: SajnaTheme.primaryRed,
        ),
      );
      return;
    }

    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val == 'done' || val == 'notListening') {
            setState(() => _isListening = false);
          }
        },
        onError: (val) => setState(() => _isListening = false),
      );

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              _voiceText = val.recognizedWords;
              if (_voiceText.isNotEmpty) {
                _textController.text = _voiceText;
              }
            });
          },
        );
      } else {
        // Fallback simulation for emulators/non-supported hardware
        setState(() => _isListening = true);
        _simulateSpeechDictation();
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      if (_textController.text.isNotEmpty) {
        _sendMessage();
      }
    }
  }

  void _simulateSpeechDictation() {
    // Mock simulation
    Future.delayed(const Duration(seconds: 2), () {
      if (_isListening) {
        setState(() {
          _textController.text = "How do we arm the cabin doors?";
          _isListening = false;
        });
        _sendMessage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = ref.watch(connectivityProvider);

    return Column(
      children: [
        // Chat Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Theme.of(context).cardColor,
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isOnline ? Colors.green : SajnaTheme.primaryRed,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("SAJNA Safety AI", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                  Text(
                    isOnline ? "Connected - Grounded API mode active" : "Offline - Local Safety Database active",
                    style: const TextStyle(fontSize: 10.5, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: SajnaTheme.borderDark),

        // Chat logs
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[index];
              return _buildMessageBubble(msg);
            },
          ),
        ),

        // Input composer bar
        Container(
          padding: const EdgeInsets.all(12),
          color: Theme.of(context).cardColor,
          child: Row(
            children: [
              GestureDetector(
                onTap: _toggleSpeechInput,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _isListening ? Colors.orange : SajnaTheme.surfaceDarkVar,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isListening ? Icons.stop : Icons.mic,
                    color: _isListening ? Colors.white : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: _isListening ? "Listening... speak now" : "Type safety query (e.g. 'door arming')...",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    fillColor: SajnaTheme.surfaceDarkVar,
                    filled: true,
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _sendMessage,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: SajnaTheme.primaryRed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    final align = msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bubbleColor = msg.isUser ? SajnaTheme.primaryRed : SajnaTheme.surfaceDarkVar;
    final textColor = msg.isUser ? Colors.white : Colors.white;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: align,
        children: [
          Container(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(msg.isUser ? 16 : 4),
                bottomRight: Radius.circular(msg.isUser ? 4 : 16),
              ),
            ),
            child: Text(
              msg.text,
              style: TextStyle(color: textColor, fontSize: 13, height: 1.45),
            ),
          ),
          if (msg.ref != null) ...[
            const SizedBox(height: 6),
            _buildReferenceBadge(msg.ref!),
          ],
        ],
      ),
    );
  }

  Widget _buildReferenceBadge(Map<String, dynamic> ref) {
    final page = ref['page'] as int;
    final chapter = ref['chapter'] as String;
    final confidence = ref['confidence'] as String;
    final score = ref['score'] as double;

    Color confColor = Colors.grey;
    if (confidence == 'High') {
      confColor = Colors.green;
    } else if (confidence == 'Medium') {
      confColor = Colors.orange;
    } else if (confidence == 'Low') {
      confColor = SajnaTheme.primaryRed;
    }

    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: SajnaTheme.primaryRed.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SajnaTheme.primaryRed.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.find_in_page, color: SajnaTheme.primaryRed, size: 16),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => widget.onJumpToManual(page, page),
                child: Text(
                  "CSPM Page $page (Section ${ref['section']})",
                  style: const TextStyle(
                    color: SajnaTheme.primaryRed,
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: confColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "Confidence: $confidence",
                  style: TextStyle(color: confColor, fontSize: 9.5, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Match Score: ${score.toStringAsFixed(1)}",
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
