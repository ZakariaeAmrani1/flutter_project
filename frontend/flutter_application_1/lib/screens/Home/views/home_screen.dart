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
import 'package:alert_info/alert_info.dart';

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
  final String getincomeStatsUrl = 'http://192.168.8.146:5000/incomeStats';
  final String getexpenseStatsUrl = 'http://192.168.8.146:5000/expenseStats';
  late Map<String, dynamic> userData;
  late List<Map<String, dynamic>> transactions;
  late List<Map<String, dynamic>> chatHistory;
  late List<dynamic> incomeStats;
  late List<dynamic> expenseStats;
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

  Future<void> fetchStatsData() async {
    try {
      final incomeStatsResponse = await http.get(Uri.parse(getincomeStatsUrl));
      if (incomeStatsResponse.statusCode == 200) {
        setState(() {
          incomeStats = jsonDecode(incomeStatsResponse.body);
        });
      } else {
        print(
            'Failed to load income stats data: ${incomeStatsResponse.statusCode}');
      }
    } catch (e) {
      print('Error fetching income stats data: $e');
    }
    try {
      final expenseStatsResponse =
          await http.get(Uri.parse(getexpenseStatsUrl));
      if (expenseStatsResponse.statusCode == 200) {
        setState(() {
          expenseStats = jsonDecode(expenseStatsResponse.body);
        });
      } else {
        print(
            'Failed to load expense stats data: ${expenseStatsResponse.statusCode}');
      }
    } catch (e) {
      print('Error fetching expense stats data: $e');
    }
  }

  Future<void> updateTransaction(data) async {
    AlertInfo.show(
      context: context,
      text: 'Transaction added successfelly.',
      typeInfo: TypeInfo.success,
      backgroundColor: Colors.white,
      textColor: Colors.grey.shade800,
    );
    setState(() {
      transactions.insert(0, data);
      userData['balance'] = data['type'] == "INCOME"
          ? userData['balance'] + data['amount']
          : userData['balance'] - data['amount'];
      if (data['type'] == "INCOME") {
        userData['income'] = userData['income'] + data['amount'];
      } else {
        userData['expense'] = userData['expense'] + data['amount'];
      }
    });
    fetchStatsData();
  }

  void updateUser(data) {
    setState(() {
      userData = data;
    });
  }

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    fetchUserData();
    fetchStatsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            child: Center(
              child: LoadingAnimationWidget.twistingDots(
                leftDotColor: Theme.of(context).colorScheme.primary,
                rightDotColor: Theme.of(context).colorScheme.secondary,
                size: 50,
              ),
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
                    onUpdate: updateUser,
                  )
                : StatsScreen(
                    transactions: transactions,
                    userData: userData,
                    incomeStats: incomeStats,
                    expenseStats: expenseStats,
                  ),
          );
  }
}
