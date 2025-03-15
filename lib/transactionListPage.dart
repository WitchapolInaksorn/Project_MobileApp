import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/updateTransactionPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({super.key});

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  final user = FirebaseAuth.instance.currentUser;
  final CollectionReference transactions =
      FirebaseFirestore.instance.collection('transactions');

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

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No Transaction",
                style: GoogleFonts.oswald(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(255, 243, 101, 101),
                ),
              ),
            );
          }

          final List<Color> rainbowColors = [
            Color(0xFFBDB2FF),
            Color(0xFFA0C4FF),
            Color(0xFF85C1E9),
            Color(0xFFCAFFBF),
            Color(0xFFFDFFB6),
            Color(0xFFFFD6A5),
            Color(0xFFFFADAD),
          ];

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var postIndex = snapshot.data!.docs[index];

              Color cardColor = (snapshot.data!.docs.length >= 7)
                  ? rainbowColors[index % 7]
                  : rainbowColors[index % 7];

              return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 800),
                  child: SlideAnimation(
                    verticalOffset: 50,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 6,
                      color: cardColor,
                      shadowColor: Colors.grey.withOpacity(1),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: ListTile(
                        title: Text(
                          'Title : ${postIndex['title']}',
                          style: GoogleFonts.lora(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Color.fromARGB(255, 80, 80, 80)),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Amount : ${postIndex['amount']}',
                              style: GoogleFonts.lora(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 80, 80, 80)),
                            ),
                            Text(
                              'Type : ${postIndex['type']}',
                              style: GoogleFonts.lora(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 80, 80, 80)),
                            ),
                            Text(
                              'Category : ${postIndex['category']}',
                              style: GoogleFonts.lora(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 80, 80, 80)),
                            ),
                            Text(
                              'Remark : ${postIndex['remark']}',
                              style: GoogleFonts.lora(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 80, 80, 80)),
                            ),
                            Text(
                              'Date : ${postIndex['date']}',
                              style: GoogleFonts.lora(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 80, 80, 80)),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Color(0xFF1976D2)),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateTransactionForm(),
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
                              icon: const Icon(Icons.delete,
                                  color: Color(0xFFE57373)),
                              onPressed: () {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.question,
                                  animType: AnimType.bottomSlide,
                                  title: "Delete",
                                  desc: "Are you sure to Delete ?",
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () {
                                    transactions.doc(postIndex.id).delete();
                                  },
                                  btnOkText: "Yes, Delete",
                                  btnCancelText: "Cancel",
                                  btnOkColor: Colors.green,
                                  btnCancelColor: Colors.red,
                                ).show();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ));
            },
          );
        },
      ),
    );
  }
}
