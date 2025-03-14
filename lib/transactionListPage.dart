import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/updateTransactionPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({super.key});

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  final user = FirebaseAuth.instance.currentUser;
  final CollectionReference transactions =
      FirebaseFirestore.instance.collection('transactions');

  void _deleteTransaction(String id) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("คุณต้องการลบรายการนี้ใช่หรือไม่?"),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      transactions.doc(id).delete();
                      Navigator.pop(context);
                    },
                    child: const Text("ลบ"),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("ยกเลิก"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Show Transaction',
          style: GoogleFonts.oswald(
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(255, 126, 126, 126)),
        ),
      ),
      body: StreamBuilder(
        stream: transactions.where('userId', isEqualTo: user?.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var postIndex = snapshot.data!.docs[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(postIndex['title']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Amount: ${postIndex['amount']}'),
                      Text('Type: ${postIndex['type']}'),
                      Text('Category: ${postIndex['category']}'),
                      Text('Remark: ${postIndex['remark']}'),
                      Text('Date: ${postIndex['date']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateTransactionForm(),
                              settings: RouteSettings(arguments: {
                                'id': postIndex.id,
                                'title': postIndex['title'],
                                'amount': postIndex['amount'],
                                'type': postIndex['type'],
                                'category': postIndex['category'],
                                'remark': postIndex['remark'],
                                'date': postIndex['date'],
                              }),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteTransaction(postIndex.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
