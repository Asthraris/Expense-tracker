import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  String _trans_category = "Food";
  List<String> options = [
    "Food",
    "EMI",
    "Rent",
    "Clothes",
    "Others",
    "Debt",
    "Owe",
    "Bill",
    "Education",
  ];
  int _transactionType = 1;
  TextEditingController labelControll = TextEditingController();
  TextEditingController costControll = TextEditingController();
  TextEditingController dateControll = TextEditingController();

  Widget dropBoxSelector() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 180),
          decoration: BoxDecoration(
            color: const Color.fromARGB(15, 0, 0, 0),
            borderRadius: BorderRadius.circular(30),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _trans_category,
              borderRadius: BorderRadius.circular(16),
              dropdownColor: Colors.grey[850],
              iconEnabledColor: Colors.white,
              style: const TextStyle(color: Colors.white),
              items: options.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() => _trans_category = newValue);
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget creditDebitSlider() {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;
        if (details.primaryVelocity! < 0 && _transactionType == 0) {
          setState(() => _transactionType = 1);
        } else if (details.primaryVelocity! > 0 && _transactionType == 1) {
          setState(() => _transactionType = 0);
        }
      },
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: _transactionType == 0
              ? const Color.fromARGB(80, 102, 187, 106)
              : const Color.fromARGB(80, 239, 83, 80),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: _transactionType == 0
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: _transactionType == 0
                      ? Colors.green.shade400
                      : Colors.red.shade400,
                ),
              ),
            ),
            Row(
              children: [_buildOption("Credit", 0), _buildOption("Debit", 1)],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String label, int index) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () => setState(() => _transactionType = index),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: _transactionType == index ? Colors.white : Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    dateControll.text = DateFormat("dd/MM/yy").format(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        height: 550,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Add Transaction",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 25),

            creditDebitSlider(),

            //for name
            Container(
              height: 70,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: labelControll,
                keyboardType: TextInputType.name,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Label",
                  filled: true,
                  fillColor: const Color.fromARGB(50, 0, 0, 0),
                  prefixIcon: Icon(Icons.label),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            //for Price
            Container(
              height: 70,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: costControll,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Cost",
                  filled: true,
                  fillColor: const Color.fromARGB(50, 0, 0, 0),
                  prefixIcon: Icon(Icons.currency_rupee),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            //for date <Option not type>
            Container(
              height: 70,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                controller: dateControll,
                readOnly: true,
                onTap: () async {
                  DateTime? newDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 31)),
                  );

                  if (newDate != null) {
                    setState(() {
                      dateControll.text = DateFormat(
                        "dd/MM/yy",
                      ).format(newDate);
                    });
                  }
                },
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Date",
                  filled: true,
                  fillColor: const Color.fromARGB(15, 0, 0, 0),
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Container(
              height: 70,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: dropBoxSelector(),
            ),
            SizedBox(
              width: 180,
              child: TextButton(
                onPressed: () {},

                style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                ),
                child: Text(
                  "Add",
                  style: TextStyle(
                    color: Colors.blue[300],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
