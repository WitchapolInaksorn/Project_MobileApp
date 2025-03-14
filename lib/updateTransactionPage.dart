import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class UpdateTransactionForm extends StatefulWidget {
  const UpdateTransactionForm({super.key});

  @override
  State<UpdateTransactionForm> createState() => _UpdateTransactionFormState();
}

class _UpdateTransactionFormState extends State<UpdateTransactionForm> {
  String selectedType = '';
  DateTime? selectedDate;
  final dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final postData = ModalRoute.of(context)!.settings.arguments as dynamic;

    final titleController = TextEditingController(text: postData['title']);
    final amountController =
        TextEditingController(text: postData['amount'].toString());
    final categoryController =
        TextEditingController(text: postData['category']);
    final remarkController = TextEditingController(text: postData['remark']);
    dateController.text = postData['date'];

    if (selectedType.isEmpty) {
      selectedType = postData['type'];
    }

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

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Text(
          'Update Transaction',
          style: GoogleFonts.oswald(
              fontWeight: FontWeight.w600,
              color: const Color.fromARGB(255, 126, 126, 126)),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              TextFormField(
                controller: titleController,
                autofocus: true,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                      color: Color(0xFF3A2E74), fontWeight: FontWeight.bold),
                  labelStyle: TextStyle(
                      color: Color(0xFF3A2E74), fontWeight: FontWeight.bold),
                  fillColor: Color(0xFFBDB2FF),
                  filled: true,
                  labelText: 'Title',
                  hintText: 'e.g., Food, Gasoline',
                  icon: Icon(Icons.title,
                      color: Color.fromARGB(255, 157, 142, 243)),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),

              // Amount Field
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                      color: Color(0xFF1E3A5F), fontWeight: FontWeight.bold),
                  labelStyle: TextStyle(
                      color: Color(0xFF1E3A5F), fontWeight: FontWeight.bold),
                  fillColor: Color(0xFFA0C4FF),
                  filled: true,
                  labelText: 'Amount',
                  hintText: 'e.g., 100.00',
                  icon: Icon(Icons.attach_money,
                      color: Color.fromARGB(255, 122, 171, 250)),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),

              // Type Dropdown Field
              DropdownButtonFormField<String>(
                value: selectedType.isNotEmpty ? selectedType : null,
                onChanged: (value) {
                  setState(() {
                    selectedType = value ?? '';
                  });
                },
                items: ['Income', 'Expense'].map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                      color: Color(0xFF2E5832), fontWeight: FontWeight.bold),
                  labelStyle: TextStyle(
                      color: Color(0xFF2E5832), fontWeight: FontWeight.bold),
                  fillColor: Color(0xFFCAFFBF),
                  filled: true,
                  labelText: 'Type',
                  icon: Icon(Icons.category,
                      color: Color.fromARGB(255, 154, 243, 136)),
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 10),

              // Category Field
              TextFormField(
                controller: categoryController,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                      color: Color(0xFF665C00), fontWeight: FontWeight.bold),
                  labelStyle: TextStyle(
                      color: Color(0xFF665C00), fontWeight: FontWeight.bold),
                  fillColor: Color(0xFFFDFFB6),
                  filled: true,
                  labelText: 'Category',
                  hintText: 'e.g., Food, Travel, Entertainment',
                  icon: Icon(Icons.list, color: Colors.amber),
                  border: OutlineInputBorder(),
                ),
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
                  hintText: 'Additional details (if any)',
                  icon: Icon(Icons.note,
                      color: Color.fromARGB(255, 243, 181, 106)),
                  border: OutlineInputBorder(),
                ),
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
                onTap: () => pickDate(context),
              ),
              SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFADAD)),
                  onPressed: () {
                    transactionsCollection.doc(postData['id']).update({
                      'title': titleController.text,
                      'amount': double.parse(amountController.text),
                      'type': selectedType,
                      'category': categoryController.text,
                      'remark': remarkController.text,
                      'date': DateFormat('dd MMM, yyyy').format(selectedDate!),
                    });

                    Navigator.pop(context);
                  },
                  child: Text(
                    'Update',
                    style: TextStyle(
                        color: const Color(0xFF5A1F1F),
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
