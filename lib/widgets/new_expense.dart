import 'package:course_adv_2_main/models/expensemodel.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime? selectedDate;
  Category selectedCategory = Category.food;

  final firstdate = DateTime(
      DateTime.now().year - 1, DateTime.now().month, DateTime.now().day);

  void presentdatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: firstdate,
      lastDate: DateTime.now(),
    );
    setState(() {
      selectedDate = pickedDate;
    });
  }

  void sumbitExpenseData() {
    final enteredAmount = double.tryParse(amountController.text);

    // try parse gives null if cant convert string to double value , therefore

    final isamountInvalid = enteredAmount == null || enteredAmount <= 0;

    if (titleController.text.trim().isEmpty ||
        isamountInvalid ||
        selectedDate == null)
    // trim function removes blank spaces at start or end
    {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text(
              'Please make sure you put a valid title , amount and date'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Understood'),
            ),
          ],
        ),
      );
    } else {
      widget.onAddExpense(
        Expense(
          title: titleController.text.trim(),
          amount: enteredAmount,
          date: selectedDate!,
          category: selectedCategory,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: titleController,
            maxLength: 50,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              label: Text('Title'),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: '\$ ',
                    label: Text('Amount'),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    selectedDate == null
                        ? 'No Date Selected'
                        : formatter.format(selectedDate!), // ! means never null
                  ),
                  IconButton(
                    onPressed: presentdatePicker,
                    icon: const Icon(Icons.calendar_month),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              DropdownButton(
                value: selectedCategory,
                items: Category.values
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(
                          category.name.toUpperCase(),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    if (value == null) {
                      return;
                    }
                    selectedCategory = value;
                  });
                  print(value);
                },
              ),
              const Spacer(),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  )
                ],
              ),
              ElevatedButton(
                onPressed: sumbitExpenseData,
                child: const Text('Save Expense'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
