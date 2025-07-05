import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:intl/intl.dart';
import 'package:poorometer/screens/blocs/get_tran_BLOC/get_tran_bloc.dart';
import 'package:poorometer/screens/home/views/settings.dart';

class MainScreen extends StatelessWidget {
  final int selectedCard;
  final Function(int) onCardChange;
  final List<Transaction> transactions;

  const MainScreen(
    this.transactions,
    this.selectedCard,
    this.onCardChange, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, List<dynamic>> categoriesIcon = {
      "Food": [Icons.fastfood, Colors.orangeAccent],
      "EMI": [Icons.account_balance, Colors.blueAccent],
      "Rent": [Icons.home, Colors.lightGreenAccent],
      "Transport": [Icons.directions_bus, Colors.blueGrey],
      "Clothes": [Icons.checkroom, Colors.pinkAccent],
      "Others": [Icons.more_horiz, Colors.grey],
      "Debt": [Icons.real_estate_agent, Colors.redAccent],
      "Bills": [Icons.receipt_long, Colors.purpleAccent],
      "Education": [Icons.book, Colors.deepPurpleAccent],
      "Shoping": [Icons.shopping_cart, Colors.lightBlueAccent],
      "luxury": [Icons.auto_awesome, const Color.fromARGB(255, 150, 3, 45)],
    };

    List<Map<String, dynamic>> userCards = [
      {
        "color": Colors.deepPurple,
        "name": "Personal",
        "cardId": 0,
        "netBalance": 0,
        "netCredit": 0,
        "netDebit": 0,
      },
      {
        "color": Colors.teal,
        "name": "Savings",
        "cardId": 1,
        "netBalance": 0,
        "netCredit": 0,
        "netDebit": 0,
      },
      {
        "color": Colors.orange,
        "name": "Business",
        "cardId": 2,
        "netBalance": 0,
        "netCredit": 0,
        "netDebit": 0,
      },
    ];
    List<Transaction> cardTransactions = transactions
        .where((t) => t.card == selectedCard)
        .toList();

    int netBalance = 0;
    int netCredit = 0;
    int netDebit = 0;
    for (final t in cardTransactions) {
      netBalance += t.amount;
      if (t.amount > 0) {
        netCredit += t.amount;
      } else {
        netDebit += t.amount.abs();
      }
    }
    userCards[selectedCard]["netBalance"] = netBalance;
    userCards[selectedCard]["netCredit"] = netCredit;
    userCards[selectedCard]["netDebit"] = netDebit;

    final double cardHeight = MediaQuery.of(context).size.width / 2;
    final double cardOffsetY = 10.0;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Column(
          children: [
            // Top Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 210, 227, 160),
                          ),
                        ),
                        Icon(
                          Icons.person,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        Text(
                          "Aman Gupta",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,

                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => Settings()),
                    );
                  },
                  icon: const Icon(Icons.settings),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Card Stack with Stats
            SizedBox(
              height: cardHeight + (cardOffsetY * (userCards.length - 1)) + 20,
              child: GestureDetector(
                onVerticalDragEnd: (details) {
                  if (details.primaryVelocity! < 0) {
                    onCardChange((selectedCard + 1) % userCards.length);
                  }
                },
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: List.generate(userCards.length, (i) {
                    // Shift cards based on selectedCard, so top card always at i == 0

                    return Positioned(
                      top: cardOffsetY * i,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 30,
                        height: cardHeight,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(
                                255,
                                113,
                                113,
                                113,
                              ), // Light silver-gray
                              Color.fromARGB(255, 164, 164, 164), // Mid silver
                              Color.fromARGB(
                                255,
                                56,
                                56,
                                56,
                              ), // Soft silver highlight
                            ],
                            begin: Alignment.bottomCenter, // 45-degree start
                            end: Alignment.topCenter, // 45-degree end
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 12,
                              offset: Offset(0, 10),
                              color: Colors.black26,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              userCards[selectedCard]["name"],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (2 - i == 0) // Show stats only on topmost card
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "₹${userCards[selectedCard]["netBalance"]}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _amountWidget(
                                        label: "Income",
                                        amount:
                                            userCards[selectedCard]["netCredit"]!,
                                        icon: Icons.arrow_downward,
                                        color: Colors.green[300]!,
                                      ),
                                      _amountWidget(
                                        label: "Expenses",
                                        amount:
                                            userCards[selectedCard]["netDebit"]!,
                                        icon: Icons.arrow_upward,
                                        color: Colors.red[300]!,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Transaction Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Transactions",
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "View all",
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Transaction List
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<GetTranBloc>().add(GetTransactions());
                  await Future.delayed(const Duration(milliseconds: 500));
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: cardTransactions.length,
                  itemBuilder: (context, i) {
                    final t = cardTransactions[i];
                    final isCredit = t.amount > 0;
                    final displayAmount = t.amount.abs();

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(38),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor:
                                        categoriesIcon[t.category]?[1] ??
                                        Colors.grey,
                                    child: Icon(
                                      categoriesIcon[t.category]?[0] ??
                                          Icons.help_outline,
                                      size: 30,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        t.category,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        t.name,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "₹ $displayAmount",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: isCredit
                                          ? Colors.green[400]
                                          : Colors.red[400],
                                    ),
                                  ),
                                  Text(
                                    DateFormat('dd MMMM yy').format(t.date),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _amountWidget({
    required String label,
    required int amount,
    required IconData icon,
    required Color color,
  }) {
    log("amount : " + amount.toString());
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.black26,
          radius: 12,
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 14, color: Colors.black)),
            Text(
              "₹$amount",
              style: TextStyle(
                fontSize: 20,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
