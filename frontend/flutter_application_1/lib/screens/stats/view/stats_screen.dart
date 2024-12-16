import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/iconsgetter.dart';
import 'package:flutter_application_1/screens/settings/views/settings_screen.dart';
import 'package:flutter_application_1/screens/stats/view/chart.dart';
import 'package:flutter_application_1/screens/transactions/views/transactions_screen.dart';

class StatsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> transactions;
  final Map<String, dynamic> userData;
  final List<dynamic> incomeStats;
  final List<dynamic> expenseStats;
  const StatsScreen(
      {super.key,
      required this.transactions,
      required this.userData,
      required this.incomeStats,
      required this.expenseStats});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen>
    with SingleTickerProviderStateMixin {
  void updateuser(data) {
    setState(() {});
  }

  final _tabs = [
    Tab(
      child: Container(
        alignment: Alignment.center,
        child: const Text("Income"),
      ),
    ),
    Tab(
      child: Container(
        alignment: Alignment.center,
        child: const Text("Expeneses"),
      ),
    ),
  ];
  List<Map<String, dynamic>> incomeTransactions = [];
  List<Map<String, dynamic>> expenseTransactions = [];

  @override
  void initState() {
    incomeTransactions = widget.transactions
        .where((transaction) => transaction['type'] == "INCOME")
        .toList();
    expenseTransactions = widget.transactions
        .where((transaction) => transaction['type'] == "EXPENSE")
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Text(
                      "Transactions",
                      style: TextStyle(
                          color: Color.fromARGB(255, 20, 37, 63),
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => SettingsScreen(
                            userData: widget.userData,
                            onUpdate: updateuser,
                          ),
                        ),
                      );
                    },
                    icon: Icon(CupertinoIcons.settings,
                        color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            DefaultTabController(
              length: 2,
              child: Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Colors.transparent),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: TabBar(
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary,
                                Theme.of(context).colorScheme.tertiary,
                              ],
                              transform: const GradientRotation(pi / 4),
                            ),
                          ),
                          labelColor: Colors.white,
                          labelStyle: const TextStyle(
                            fontSize: 16,
                          ),
                          unselectedLabelColor: Colors.grey.shade700,
                          tabs: _tabs,
                          dividerColor: Colors.transparent,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 330,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        12, 20, 12, 12),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Total Incomes",
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "\$ ${widget.incomeStats[7].toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 20, 37, 63),
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        SizedBox(
                                          height: 200,
                                          child: MyChart(
                                            stats: widget.incomeStats,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Income",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute<void>(
                                            builder: (BuildContext context) =>
                                                TransactionsScreen(
                                              transactions: widget.transactions,
                                              type: "Income",
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "View all",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: incomeTransactions.length,
                                  itemBuilder: (context, int i) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12.0,
                                            horizontal: 20,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width: 50,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Iconsgetter.getColor(
                                                              incomeTransactions[
                                                                  i]['id']),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Iconsgetter.getIcon(
                                                        incomeTransactions[i]
                                                            ['id']),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    Iconsgetter.getName(
                                                        incomeTransactions[i]
                                                            ['id']),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    incomeTransactions[i]
                                                                ['type'] ==
                                                            "INCOME"
                                                        ? "${incomeTransactions[i]['amount'].toStringAsFixed(2)}\$"
                                                        : "- ${incomeTransactions[i]['amount'].toStringAsFixed(2)}\$",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  Text(
                                                    widget.transactions[i]
                                                        ['date'],
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 330,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        12, 20, 12, 12),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Total Expenses",
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          "\$ ${widget.expenseStats[7].toStringAsFixed(2)}",
                                          style: TextStyle(
                                            color: Colors.grey.shade900,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        SizedBox(
                                          height:
                                              200, // Constrain the height of the chart
                                          child: MyChart(
                                            stats: widget.expenseStats,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Expenses",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute<void>(
                                            builder: (BuildContext context) =>
                                                TransactionsScreen(
                                              transactions: widget.transactions,
                                              type: "Expenses",
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "View all",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                ListView.builder(
                                  physics:
                                      const NeverScrollableScrollPhysics(), // Disable inner scrolling
                                  shrinkWrap:
                                      true, // Let ListView fit its content
                                  itemCount: expenseTransactions.length,
                                  itemBuilder: (context, int i) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12.0,
                                            horizontal: 20,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width: 50,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: Iconsgetter.getColor(
                                                          expenseTransactions[i]
                                                              ['id']),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Iconsgetter.getIcon(
                                                        expenseTransactions[i]
                                                            ['id']),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    Iconsgetter.getName(
                                                        expenseTransactions[i]
                                                            ['id']),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    expenseTransactions[i]
                                                                ['type'] ==
                                                            "INCOME"
                                                        ? "${expenseTransactions[i]['amount'].toStringAsFixed(2)}\$"
                                                        : "- ${expenseTransactions[i]['amount'].toStringAsFixed(2)}\$",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  Text(
                                                    widget.transactions[i]
                                                        ['date'],
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
