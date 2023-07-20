import 'package:flutter/material.dart';
import 'package:test_app/page-scan.dart';
import 'package:test_app/service/auth_service.dart';
/*This is the page where we calculate the total cost.

It displays the list of food items and allows the user to adjust the amount of each item they want to purchase.

There is also a button to navigate to the page "page-scan" where the user can add a receipt by scanning it.

The widget keeps track of the total price of the items and allows the user to enter a tip amount.

There is a "Calculate & Save" button which takes the total price value,
shows the total value to the user and prompts into the space above the button.
Then saves the date of the process and the total price into Firebase database.*/
class MyPage extends StatefulWidget {
  List<String> food = [];
  List<double> price = [];
  List<int> amount = [];
  MyPage({super.key, required this.food, required this.price, required this.amount});
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  double totalPrice = 0;
  double tip = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.black12,
        title: Text('Calculate Receipt'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(),
        ),
      ),
      backgroundColor: Colors.deepPurple,
      body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.025,
            ),
            Container(
              width: 200,
              height: 30,
              child: const Center(
                child: Text(
                  "Food",
                  style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: 120,
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Amount",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
            ),
          ],
        ),
        SizedBox(
          height: 6,
        ),
        ...List.generate(
    widget.food.length,
        (index) => Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.025,
            ),
            Container(
              width: 200,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white70,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  widget.food[index],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: 120,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      if (widget.amount[index] > 0) {
                        setState(() {
                          widget.amount[index] = widget.amount[index] - 1;
                        });
                      }
                    },
                    icon: Icon(
                      Icons.remove,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.amount[index].toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.amount[index] = widget.amount[index] + 1;
                      });
                    },
                    icon: Icon(
                      Icons.add,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.05,
            ),
          ],
        ),
                  SizedBox(
                    height: 6,
                  ),
                ],
              ),
            ),
          ]
        ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ThirdPage()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt),
                    SizedBox(width: 10),
                    Text(
                      'Add Receipt',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.07,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white70,
                width: 2,
              ),
            ),
            child: Center(
              child: TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter tip amount',
                  contentPadding: EdgeInsets.all(10),
                ),
                onChanged: (value) {
                  setState(() {
                    tip = double.tryParse(value) ?? 0.0;
                  });
                },
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.12,
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
              child: Center(
                child: Text(
                  "Total\n\₺$totalPrice",
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.white,
                  ),
                ),
              ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          ElevatedButton(
            onPressed: () async {
              totalPrice = 0;
              int selectedItemCount = 0;
              for (int i = 0; i < widget.food.length; i++) {
                selectedItemCount += widget.amount[i];
                totalPrice += widget.amount[i] * widget.price[i];
              }
              totalPrice += tip;

              // Firestore'a kaydetmek için AuthService örneğini kullan
              final authService = AuthService();
              await authService.addExpense(totalPrice);

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Payment'),
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('You have selected $selectedItemCount items.'),
                      SizedBox(height: 10),
                      Text('Your fee is: ₺$totalPrice'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
            child: Text(
              'Calculate & Save',
              style: TextStyle(fontSize: 20),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              minimumSize: Size(
                MediaQuery.of(context).size.width * 0.9,
                50,
              ),
              elevation: 10,
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
        ],
      ),
    ),
    );
  }
}




