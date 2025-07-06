import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poorometer/screens/home/auth_service.dart';
import 'package:poorometer/screens/home/views/components/changepass_dia.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});
  Future<void> deleteCardTransactions(
    BuildContext context,
    String userId,
    int cardId,
  ) async {
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('Transactions');

    try {
      final snapshot = await collection
          .where('userId', isEqualTo: userId)
          .where('card', isEqualTo: cardId)
          .get();

      if (snapshot.docs.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("No transactions found for this card."),
            ),
          );
        }
        return;
      }

      final batch = firestore.batch();

      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      print("Error deleting card transactions: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to delete card transactions.")),
        );
      }
    }
  }

  Future<void> deleteUserTransactions(
    BuildContext context,
    String userId,
  ) async {
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('Transactions');

    try {
      final snapshot = await collection
          .where('userId', isEqualTo: userId)
          .get();

      if (snapshot.docs.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No transactions found to delete.")),
          );
        }
        return;
      }

      final batch = firestore.batch();

      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      print("Error deleting transactions: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to delete transactions.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          ListTile(
            title: const Text("Reset One Card Transactions"),
            leading: const Icon(Icons.credit_card),
            onTap: () async {
              showDialog(
                context: context,
                builder: (context) {
                  int? selectedCard;
                  final List<int> cardIds = [0, 1, 2];
                  String getCardName(int cardId) {
                    switch (cardId) {
                      case 0:
                        return "Personal";
                      case 1:
                        return "Savings";
                      case 2:
                        return "Business";
                      default:
                        return "Unknown";
                    }
                  }

                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        title: const Text("Clear Card Transactions!"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 200,
                              child: DropdownButton<int>(
                                hint: const Text("Select Card"),
                                value: selectedCard,
                                onChanged: (int? newValue) {
                                  setState(() {
                                    selectedCard = newValue;
                                  });
                                },
                                items: cardIds.map((int cardId) {
                                  return DropdownMenuItem<int>(
                                    value: cardId,
                                    child: Text(getCardName(cardId)),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: selectedCard == null
                                ? null // Disable if no card selected
                                : () async {
                                    try {
                                      await deleteCardTransactions(
                                        context,
                                        FirebaseAuth.instance.currentUser!.uid,
                                        selectedCard!,
                                      );
                                      if (context.mounted) {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Card $selectedCard cleared Successfully.",
                                            ),
                                          ),
                                        );
                                      }
                                    } on FirebaseAuthException catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              e.message ??
                                                  "Failed to Delete Transactions",
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                            child: const Text("Clear"),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),

          ListTile(
            title: Text("Clear Data"),
            leading: Icon(Icons.delete_forever),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Delete all your Transactions!"),
                    content: Column(mainAxisSize: MainAxisSize.min),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          try {
                            await deleteUserTransactions(
                              context,
                              FirebaseAuth.instance.currentUser!.uid,
                            );
                            if (context.mounted) {
                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Data deleted Successfully."),
                                ),
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    e.message ??
                                        "Failed to Delete Transactions",
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text("Delete"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          ListTile(
            title: Text("Change Currency"),
            leading: Icon(Icons.currency_exchange),
            onTap: () {
              // TODO: Show currency picker
            },
          ),

          ListTile(
            title: Text("Notification Settings"),
            leading: Icon(Icons.notifications),
            onTap: () {
              // TODO: Push notification config screen
            },
          ),

          ListTile(
            title: Text("Export Data to CSV"),
            leading: Icon(Icons.download),
            onTap: () {
              // TODO: Export to CSV logic
            },
          ),

          ListTile(
            title: Text("App Info / Version"),
            leading: Icon(Icons.info_outline),
            onTap: () {
              //TODO
            },
          ),
          ListTile(
            title: Text("Change Password"),
            textColor: Colors.yellowAccent,
            leading: Icon(Icons.password, color: Colors.yellowAccent),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => const ChangePasswordDialog(),
              );
            },
          ),
          ListTile(
            title: Text("Log Out"),
            textColor: Colors.orangeAccent,
            leading: Icon(Icons.person_outline, color: Colors.orangeAccent),
            onTap: () async {
              try {
                authService.value.signOut();
                Navigator.pop(context);
              } on FirebaseAuthException catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.message ?? "Failed of Logout")),
                );
              }
            },
          ),
          ListTile(
            title: const Text("Delete Account"),
            textColor: Colors.red,
            leading: const Icon(
              Icons.person_remove_alt_1_rounded,
              color: Colors.red,
            ),
            onTap: () async {
              showDialog(
                context: context,
                builder: (context) {
                  final TextEditingController emailController =
                      TextEditingController();
                  final TextEditingController passwordController =
                      TextEditingController();

                  return AlertDialog(
                    title: const Text("Confirm Account Deletion"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(labelText: "Email"),
                        ),
                        TextField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                            labelText: "Password",
                          ),
                          obscureText: true,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();
                          Navigator.of(
                            context,
                          ).pop(); // Close the dialog before deletion

                          try {
                            await deleteUserTransactions(
                              context,
                              FirebaseAuth.instance.currentUser!.uid,
                            );

                            await authService.value.deleteAccount(
                              email: email,
                              password: password,
                            );

                            if (context.mounted) {
                              Navigator.pop(context);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Account Deleted Successfully.",
                                  ),
                                ),
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    e.message ?? "Failed to Delete Account",
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text("Confirm"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
