// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/Home/views/main_screen.dart';
import 'package:flutter_application_1/screens/add_transaction/view/add_transaction.dart';
import 'package:flutter_application_1/screens/stats/view/stats_screen.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  final String getuserUrl = 'http://192.168.8.146:5000/user';
  final String gettransactionsUrl = 'http://192.168.8.146:5000/transactions';
  final String getchatUrl = 'http://192.168.8.146:5000/chatHistory';
  late Map<String, dynamic> userData;
  late List<Map<String, dynamic>> transactions;
  late List<Map<String, dynamic>> chatHistory;
  bool isLoading = true;
  Future<void> fetchUserData() async {
    try {
      final userResponse = await http.get(Uri.parse(getuserUrl));
      if (userResponse.statusCode == 200) {
        setState(() {
          userData = jsonDecode(userResponse.body);
        });
      } else {
        print('Failed to load user data: ${userResponse.statusCode}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    try {
      final transactionsResponse =
          await http.get(Uri.parse(gettransactionsUrl));
      if (transactionsResponse.statusCode == 200) {
        setState(() {
          transactions = List<Map<String, dynamic>>.from(
              json.decode(transactionsResponse.body));
        });
      } else {
        print(
            'Failed to load transactions data: ${transactionsResponse.statusCode}');
      }
    } catch (e) {
      print('Error fetching transactions data: $e');
    }
    try {
      final chatHistoryResponse = await http.get(Uri.parse(getchatUrl));
      if (chatHistoryResponse.statusCode == 200) {
        setState(() {
          chatHistory = List<Map<String, dynamic>>.from(
              json.decode(chatHistoryResponse.body));
        });
      } else {
        print('Failed to load chat data: ${chatHistoryResponse.statusCode}');
      }
    } catch (e) {
      print('Error fetching chat data: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  void updateTransaction(data) {
    setState(() {
      transactions.insert(0, data);
    });
  }

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    fetchUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: LoadingAnimationWidget.twistingDots(
              leftDotColor: Theme.of(context).colorScheme.primary,
              rightDotColor: Theme.of(context).colorScheme.secondary,
              size: 50,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              toolbarHeight: 10,
            ),
            bottomNavigationBar: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
              child: BottomNavigationBar(
                onTap: (value) {
                  setState(() {
                    index = value;
                  });
                },
                backgroundColor: Colors.white,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                elevation: 3,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.dashboard_rounded,
                      color: index == 0
                          ? Colors.grey.shade700
                          : Colors.grey.shade400,
                    ),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.graphic_eq_rounded,
                      color: index == 1
                          ? Colors.grey.shade700
                          : Colors.grey.shade400,
                    ),
                    label: "Stats",
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        AddTransaction(onUpdate: updateTransaction),
                  ),
                );
              },
              shape: const CircleBorder(),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.tertiary,
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.primary,
                    ],
                    transform: const GradientRotation(pi / 4),
                  ),
                ),
                child: const Icon(
                  CupertinoIcons.add,
                ),
              ),
            ),
            body: index == 0
                ? MainScreen(
                    userData: userData,
                    transactions: transactions,
                    chatHistory: chatHistory,
                  )
                : const StatsScreen(),
          );
  }
}
