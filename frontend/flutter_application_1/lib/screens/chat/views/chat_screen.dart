// ignore_for_file: prefer_final_fields, avoid_print, unused_local_variable

import 'dart:convert';
import 'dart:math';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/chat/views/key.dart';
import 'package:groq_sdk/groq_sdk.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  final List<Map<String, dynamic>> chatHistory;
  const ChatScreen({super.key, required this.chatHistory});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final String postchatUrl = 'https://alexo.pythonanywhere.com/chatHistory';
  final customChat = Groq(APIKEY).startNewChat(GroqModels.llama3_70b,
      settings: GroqChatSettings(
        temperature: 0.8,
        maxTokens: 512,
      ));

  final ChatUser _user = ChatUser(
    id: '1',
    firstName: 'Alexo',
    lastName: 'Elmer',
  );

  final ChatUser _gptChatUser = ChatUser(
    id: '2',
    firstName: 'Alexo\'s',
    lastName: 'GPT',
  );
  List<ChatMessage> _messages = <ChatMessage>[];
  List<ChatUser> _typingUsers = <ChatUser>[];
  bool _isAnswering = false;

  @override
  void initState() {
    customChat.addMessageWithoutSending(
        'You are a chatbot for a financial assistant.',
        role: GroqMessageRole.assistant);
    for (var message in widget.chatHistory) {
      _messages.insert(
        0,
        ChatMessage(
            user: message['role'] == "user" ? _user : _gptChatUser,
            createdAt: DateTime.parse(message['date']),
            text: message['text']),
      );

      customChat.addMessageWithoutSending(message['text'],
          role: message['role'] == "assistant"
              ? GroqMessageRole.assistant
              : GroqMessageRole.user);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: AppBar(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/gptlogo.png',
                        width: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "Alexo's Gpt",
                        style: TextStyle(
                          color: Color.fromARGB(255, 20, 37, 63),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.transparent,
                  leadingWidth: 60,
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.grey.shade700,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        Expanded(
          child: Scaffold(
            body: DashChat(
              currentUser: _user,
              inputOptions: InputOptions(
                inputDisabled: _isAnswering,
                alwaysShowSend: true,
                sendOnEnter: true,
                inputDecoration: InputDecoration(
                  hintText: "Write a message ...",
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, // Vertical padding inside the TextField
                    horizontal: 10.0, // Horizontal padding inside the TextField
                  ),
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                sendButtonBuilder: (send) {
                  return Row(
                    children: [
                      const SizedBox(
                        width: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                              Theme.of(context).colorScheme.tertiary,
                            ],
                            transform: const GradientRotation(pi / 4),
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                              color: Colors.grey.shade300,
                              offset: const Offset(5, 5),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {
                            send();
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              messageOptions: MessageOptions(
                showOtherUsersAvatar: false,
                currentUserContainerColor: Colors.grey,
                textColor: Colors.white,
                messageDecorationBuilder: (ChatMessage message,
                    ChatMessage? message1, ChatMessage? message2) {
                  return BoxDecoration(
                    gradient: message.user == _user
                        ? LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                              Theme.of(context).colorScheme.tertiary,
                            ],
                            transform: const GradientRotation(pi / 4),
                          )
                        : LinearGradient(
                            colors: [
                              Colors.grey.shade500,
                              Colors.grey.shade500,
                            ],
                          ),
                    borderRadius: BorderRadius.circular(15),
                  );
                },
              ),
              onSend: (ChatMessage m) async {
                setState(() {
                  _messages.insert(0, m);
                  _typingUsers.add(_gptChatUser);
                  _isAnswering = true;
                });
                try {
                  var data = {
                    'role': "user",
                    'date': DateTime.now().toString(),
                    'text': m.text
                  };
                  final chatResponse = await http.post(
                    Uri.parse(postchatUrl),
                    headers: {'Content-Type': 'application/json'},
                    body: json.encode(data),
                  );
                  setState(() {
                    widget.chatHistory.add(data);
                  });
                } catch (e) {
                  print('Error fetching user data: $e');
                }

                final (response, usage) = await customChat.sendMessage(m.text,
                    role: GroqMessageRole.user);
                for (var element in response.choices) {
                  if (element.message != '') {
                    setState(() {
                      _messages.insert(
                          0,
                          ChatMessage(
                              user: _gptChatUser,
                              createdAt: DateTime.now(),
                              text: element.message));
                    });

                    try {
                      var data = {
                        'role': "assitant",
                        'date': DateTime.now().toString(),
                        'text': element.message
                      };
                      final chatResponse = await http.post(
                        Uri.parse(postchatUrl),
                        headers: {'Content-Type': 'application/json'},
                        body: json.encode(data),
                      );
                      setState(() {
                        widget.chatHistory.add(data);
                      });
                    } catch (e) {
                      print('Error fetching user data: $e');
                    }
                  }
                }
                setState(() {
                  _typingUsers.remove(_gptChatUser);
                  _isAnswering = false;
                });
              },
              messages: _messages,
              typingUsers: _typingUsers,
            ),
          ),
        ),
      ],
    );
  }
}
