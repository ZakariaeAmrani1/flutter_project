import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final ChatUser _user = ChatUser(
  id: '1',
  firstName: 'Charles',
  lastName: 'Leclerc',
);

final ChatUser _gptChatUser = ChatUser(
  id: '2',
  firstName: 'Alexo\'s',
  lastName: 'GPT',
);
List<Map<String, dynamic>> messages = [
  {
    'role': "user",
    'date': DateTime.now(),
    'text': "Hi i am alexo",
  },
  {
    'role': "assistant",
    'date': DateTime.now(),
    'text':
        "Hi Alexo! I'm your financial assistant. How can I help you today? Do you have any questions about your finances, or would you like me to provide you with some personalized recommendations?",
  },
];
