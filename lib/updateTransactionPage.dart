import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class UpdateTransactionForm extends StatefulWidget {
  const UpdateTransactionForm({super.key});

  @override
  State<UpdateTransactionForm> createState() => _UpdateTransactionFormState();
}

class _UpdateTransactionFormState extends State<UpdateTransactionForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController amountController;
  late TextEditingController categoryController;
  late TextEditingController remarkController;
  late TextEditingController dateController;

  String selectedType = '';
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    amountController = TextEditingController();
    categoryController = TextEditingController();
    remarkController = TextEditingController();
    dateController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    categoryController.dispose();
    remarkController.dispose();
    dateController.dispose();
    super.dispose();
  }

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

  void updateSuccess(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.bottomSlide,
      title: "Update Success",
      desc: "Update Transaction Success",
      btnOkOnPress: () {
        Navigator.pop(context);
      },
      btnOkText: "OK",
      btnOkColor: Colors.green,
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final postData = ModalRoute.of(context)!.settings.arguments as dynamic;

    if (titleController.text.isEmpty) {
      titleController.text = postData['title'];
      amountController.text = postData['amount'].toString();
      categoryController.text = postData['category'];
      remarkController.text = postData['remark'];
      dateController.text = postData['date'];
      selectedType = postData['type'];
      selectedDate = DateFormat('dd MMM, yyyy').parse(postData['date']);
    }

    final CollectionReference transactionsCollection =
        FirebaseFirestore.instance.collection('transactions');

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
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: titleController,
                autofocus: true,
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                      color: Color(0xFF3A2E74), fontWeight: FontWeight.bold),
                  fillColor: Color(0xFFBDB2FF),
                  filled: true,
                  labelText: 'Title',
                  icon: Icon(Icons.title,
                      color: Color.fromARGB(255, 157, 142, 243)),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Title';
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
                  icon: Icon(Icons.attach_money,
                      color: Color.fromARGB(255, 122, 171, 250)),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an Amount';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Type';
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
                    return 'Please enter a Remarks';
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
                  hintText: 'Additional details (if any)',
                  icon: Icon(Icons.note,
                      color: Color.fromARGB(255, 243, 181, 106)),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Remarks';
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
                onTap: () => pickDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB88D5A)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.question,
                        animType: AnimType.bottomSlide,
                        title: "Update Transaction",
                        desc: "Are you sure to Update Transaction ?",
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {
                          transactionsCollection.doc(postData['id']).update({
                            'title': titleController.text,
                            'amount': double.parse(amountController.text),
                            'type': selectedType,
                            'category': categoryController.text,
                            'remark': remarkController.text,
                            'date': DateFormat('dd MMM, yyyy')
                                .format(selectedDate!),
                          }).then((_) {
                            Future.delayed(
                              Duration.zero,
                              () => updateSuccess(context),
                            );
                          });
                        },
                        btnOkText: "Yes, Update",
                        btnCancelText: "Cancel",
                        btnOkColor: Colors.green,
                        btnCancelColor: Colors.red,
                      ).show();
                    }
                  },
                  child: Text(
                    'Update',
                    style: TextStyle(
                        color: const Color(0xFF5A341E),
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
