// ignore_for_file: prefer_final_fields

import 'dart:math';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/messages.dart';
import 'package:groq_sdk/groq_sdk.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final customChat =
      Groq('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')
          .startNewChat(GroqModels.llama3_70b,
              settings: GroqChatSettings(
                temperature: 0.8, //More creative responses
                maxTokens: 512, //shorter responses
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
    super.initState();
    for (var message in messages) {
      _messages.insert(
        0,
        ChatMessage(
            user: message['role'] == "user" ? _user : _gptChatUser,
            createdAt: message['date'],
            text: message['text']),
      );
    }
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
                customChat.addMessageWithoutSending(
                    'You are a chatbot for a financial assistant.',
                    role: GroqMessageRole.assistant);
                for (var message in messages) {
                  customChat.addMessageWithoutSending(message['text'],
                      role: message['role'] == "assistant"
                          ? GroqMessageRole.assistant
                          : GroqMessageRole.user);
                }

                setState(() {
                  _messages.insert(0, m);
                  _typingUsers.add(_gptChatUser);
                  _isAnswering = true;
                });

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
