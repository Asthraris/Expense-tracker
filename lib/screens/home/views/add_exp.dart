import 'package:expense_repository/expense_repository.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poorometer/screens/home/views/blocs/create_tran_BLOC/create_transaction_bloc.dart';
import 'package:poorometer/screens/home/views/blocs/get_tran_BLOC/get_tran_bloc.dart';

import 'package:uuid/uuid.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

//Agar DateTime DB me slow hoga toh String save karunga
class _AddExpenseState extends State<AddExpense> {
  int localTransactionType = 1;
  // If you're sure that a variable is set before it's used, but Dart disagrees, you can fix the error by marking the variable as late:

  List<String> options = [
    "Food",
    "EMI",
    "Rent",
    "Transport",
    "Clothes",
    "Others",
    "Debt",
    "Bills",
    "Education",
    "Shoping",
    "luxury",
  ];
  TextEditingController labelControll = TextEditingController();
  TextEditingController costControll = TextEditingController();
  TextEditingController dateControll = TextEditingController();
  late Transaction transac;
  bool isloading = false;

  Widget dropBoxSelector() {
    return StatefulBuilder(
      builder: (context, setState) {
        return DropdownMenu<String>(
          //idhar problem aa sakta if this func gets called before getting transaction instance
          initialSelection: "Food",
          width: 1200,
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            fillColor: const Color.fromARGB(15, 0, 0, 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide.none,
            ),
          ),
          menuStyle: const MenuStyle(
            maximumSize: WidgetStatePropertyAll<Size>(Size(335, 300)),
            backgroundColor: WidgetStatePropertyAll(
              Color.fromARGB(255, 57, 57, 57),
            ),
            surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
          ),
          textStyle: const TextStyle(color: Colors.white, fontSize: 20),
          trailingIcon: const Icon(Icons.arrow_drop_up, color: Colors.white),
          dropdownMenuEntries: options
              .map(
                (item) => DropdownMenuEntry<String>(value: item, label: item),
              )
              .toList(),
          onSelected: (String? newValue) {
            if (newValue != null) {
              setState(() => transac.category = newValue);
            }
          },
        );
      },
    );
  }

  Widget creditDebitSlider() {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;
        if (details.primaryVelocity! < 0 && localTransactionType == 1) {
          setState(() => localTransactionType = 0);
        } else if (details.primaryVelocity! > 0 && localTransactionType == 0) {
          setState(() => localTransactionType = 1);
        }
      },
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: localTransactionType == 0
              ? const Color.fromARGB(80, 102, 187, 106)
              : const Color.fromARGB(80, 239, 83, 80),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: localTransactionType == 0
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.42,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: localTransactionType == 0
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
        onTap: () => setState(() => localTransactionType = index),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: localTransactionType == index
                  ? Colors.white
                  : Colors.white70,
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
    transac = Transaction.empty;
    dateControll.text = DateFormat("dd/MM/yy").format(transac.date);
    //start your transaction as defualt calegory , i am not HARDcoding it in backend
    transac.trans_id = Uuid().v1();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateTransactionBloc, CreateTransactionState>(
      listener: (context, state) {
        if (state is CreateTransactionLoading) {
          setState(() {
            isloading = true;
          });
        } else if (state is CreateTransactionSuccess) {
          setState(() {
            isloading = false;
          });
          context.read<GetTranBloc>().add(GetTransactions());
          Navigator.of(context).pop();
        } else if (state is CreateTransactionSuccess) {
          setState(() {
            isloading = false;
          });
          context.read<GetTranBloc>().add(GetTransactions());
          Navigator.of(context).pop();
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          height: 750,
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
                      firstDate: transac.date,
                      lastDate: transac.date.add(const Duration(days: 31)),
                    );

                    if (newDate != null) {
                      setState(() {
                        dateControll.text = DateFormat(
                          "dd/MM/yy",
                        ).format(newDate);
                      });
                      transac.date = newDate;
                    }
                  },
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "Today",
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
                child: isloading
                    ? const Center(child: CircularProgressIndicator())
                    : TextButton(
                        onPressed: () {
                          //YAHA par SetState use kiya hai no idea why
                          transac.amount = int.parse(costControll.text);
                          if (localTransactionType == 1) {
                            transac.amount *= -1;
                          }
                          transac.name = labelControll.text;

                          //try one
                          context.read<CreateTransactionBloc>().add(
                            CreateTransaction(transaction: transac),
                          );
                          Navigator.pop(context, true);
                        },

                        style: TextButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            255,
                            255,
                            255,
                          ),
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
      ),
    );
  }
}
