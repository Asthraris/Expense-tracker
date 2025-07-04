import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:poorometer/screens/home/views/blocs/get_tran_BLOC/get_tran_bloc.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  Future<void> deleteAllTransactions(BuildContext context) async {
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('Transactions');

    try {
      final snapshot = await collection.get();
      final batch = firestore.batch();

      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(" All transactions deleted.")));
      }
    } catch (e) {
      print(" Error deleting transactions: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(" Failed to delete data.")));
      }
    }
  }

  Future<void> addSingleCard() async {
    final cardsRef = FirebaseFirestore.instance.collection('cards');

    // Get the current highest _card index
    final snapshot = await cardsRef
        .orderBy('_card', descending: true)
        .limit(1)
        .get();

    int maxCard = 0;
    if (snapshot.docs.isNotEmpty) {
      maxCard = snapshot.docs.first.data()['_card'] ?? 0;
      maxCard += 1;
    }

    // Add a new card
    await cardsRef.add({
      'name': 'Card $maxCard',
      'colorValue': Colors.primaries[maxCard % Colors.primaries.length].value,
      '_card': maxCard,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          ListTile(
            title: Text("Sign In / Sign Up"),
            leading: Icon(Icons.person_outline),
            onTap: () {
              // TODO: Trigger auth screen
            },
          ),

          ListTile(
            title: Text("Link Bank / Card"),
            leading: Icon(Icons.credit_card),
            onTap: () async {
              await addSingleCard();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Card Added")));
            },
          ),

          ListTile(
            title: Text("Delete Linked Card"),
            leading: Icon(Icons.delete_forever),
            onTap: () {
              // TODO: Confirm and remove card
            },
          ),

          ListTile(
            title: Text("Reset All Transactions"),
            leading: Icon(Icons.delete_sweep),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text("Confirm Reset"),
                  content: Text(
                    "This will delete all transactions permanently. Continue?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text("Delete"),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await deleteAllTransactions(context);
              }
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
        ],
      ),
    );
  }
}
