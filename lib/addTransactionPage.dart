import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class AddTransactionForm extends StatefulWidget {
  const AddTransactionForm({super.key});

  @override
  State<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  DateTime? selectedDate;

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final typeController = TextEditingController();
  final categoryController = TextEditingController();
  final remarkController = TextEditingController();

  final dateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final CollectionReference transactionsCollection =
      FirebaseFirestore.instance.collection('transactions');

  Future<void> pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text = DateFormat('dd MMM, yyyy').format(pickedDate);
      });
    }
  }

  void addTransaction() async {
    if (_formKey.currentState?.validate() ?? false) {
      final user = FirebaseAuth.instance.currentUser;

      await transactionsCollection.add({
        'userId': user?.uid,
        'title': titleController.text,
        'amount': double.parse(amountController.text),
        'type': typeController.text,
        'category': categoryController.text,
        'remark': remarkController.text,
        'date': dateController.text
      });

      titleController.clear();
      amountController.clear();
      typeController.clear();
      categoryController.clear();
      remarkController.clear();
      dateController.clear();
    }
  }

  void addTransactionDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.bottomSlide,
      title: "Add Transaction",
      desc: "Are you sure to Add Transaction ?",
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        addTransaction();
        addSuccess(context);
      },
      btnOkText: "Yes, Save",
      btnCancelText: "Cancel",
      btnOkColor: Colors.green,
      btnCancelColor: Colors.red,
    ).show();
  }

  void addSuccess(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      title: "Add Success",
      desc: "Add Transaction Success",
      btnOkOnPress: () {},
      btnOkText: "Save",
      btnOkColor: Colors.green,
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Transaction',
          style: GoogleFonts.oswald(
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(255, 126, 126, 126)),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                      color: Color(0xFF3A2E74), fontWeight: FontWeight.bold),
                  fillColor: Color(0xFFBDB2FF),
                  filled: true,
                  labelText: 'Title',
                  icon: Icon(
                    Icons.title,
                    color: Color.fromARGB(255, 157, 142, 243),
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d+\.?\d{0,2}'),
                  ),
                ],
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                      color: Color(0xFF1E3A5F), fontWeight: FontWeight.bold),
                  fillColor: Color(0xFFA0C4FF),
                  filled: true,
                  labelText: 'Amount',
                  icon: Icon(
                    Icons.attach_money,
                    color: Color.fromARGB(255, 122, 171, 250),
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: null,
                onChanged: (value) {
                  typeController.text = value ?? '';
                },
                items: ['Income', 'Expense'].map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                      color: Color(0xFF2E5832), fontWeight: FontWeight.bold),
                  fillColor: Color(0xFFCAFFBF),
                  filled: true,
                  labelText: 'Type',
                  icon: Icon(Icons.category,
                      color: Color.fromARGB(255, 154, 243, 136)),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a type';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: categoryController,
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                      color: Color(0xFF665C00), fontWeight: FontWeight.bold),
                  fillColor: Color(0xFFFDFFB6),
                  filled: true,
                  labelText: 'Category',
                  icon: Icon(Icons.list, color: Colors.amber),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: remarkController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                      color: Color(0xFF5A341E), fontWeight: FontWeight.bold),
                  labelStyle: TextStyle(
                      color: Color(0xFF5A341E), fontWeight: FontWeight.bold),
                  fillColor: Color(0xFFFFD6A5),
                  filled: true,
                  labelText: 'Remarks',
                  hintText: 'Additional details (if not use -)',
                  icon: Icon(
                    Icons.note,
                    color: Color.fromARGB(255, 243, 181, 106),
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter remarks';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: dateController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                      color: Color(0xFF5A1F1F), fontWeight: FontWeight.bold),
                  labelStyle: TextStyle(
                      color: Color(0xFF5A1F1F), fontWeight: FontWeight.bold),
                  fillColor: Color(0xFFFFADAD),
                  filled: true,
                  labelText: 'Date',
                  icon: Icon(
                    Icons.date_range,
                    color: Color.fromARGB(255, 228, 141, 141),
                  ),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
                onTap: () => pickDate(context),
              ),
              SizedBox(height: 10),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 199, 153, 84)),
                  onPressed: () {
                    addTransactionDialog(context);
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 252, 228, 228),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
