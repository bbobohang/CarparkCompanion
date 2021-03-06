import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

/// Class of LotRememberer which contains the carpark address for autofilling 
/// 
/// Autofill the address of carpark for convenience. If user does not click on any carpark, starts off blank
class LotsRememberer extends StatefulWidget {

  String carparkName;
  
  LotsRememberer(this.carparkName, {Key? key}) : super(key: key);


  @override
  _LotsRemembererState createState() => _LotsRemembererState();
}


class _LotsRemembererState extends State<LotsRememberer> {

  TextEditingController _textFieldController = TextEditingController();

  //Firebase linking
  FirebaseDatabase database = FirebaseDatabase.instance;

  //Lot remember details
  String codeDialog = "";
  String codeDialog2 = "";
  int codeDialog3 = 0;
  late String valueText = widget.carparkName;
  String numText = "";
  int timeText = 0;
  bool remembered = false;
  late Timer _timer;

  /// Display the prompting questions for users to enter responses
  Future<void> displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter carpark details'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextField(
                    controller: TextEditingController(text: valueText),
                    onChanged: (value) {
                      setState(() {
                        valueText = value;
                      });
                    },
                    decoration: InputDecoration(hintText: "Carpark Name"),
                  ),
                  TextField(
                    maxLength: 10,
                    decoration: InputDecoration(
                      labelText: 'Carpark Lot No.',
                    ),
                    textInputAction: TextInputAction.next,
                    onChanged: (num) {
                      setState(() {
                        numText = num;
                      });
                    },
                  ),
                  TextField(
                    maxLength: 4,
                    decoration: InputDecoration(
                      labelText: 'Duration(mins)',
                    ),
                    textInputAction: TextInputAction.next,
                    onChanged: (time) {
                      setState(() {
                        timeText = int.parse(time);
                      });
                    },
                  )
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  _startTimer();
                  remembered = true;
                  setState(() {
                    codeDialog = valueText;
                    codeDialog2 = numText;
                    codeDialog3 = timeText;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  /// Starts timer based on user input and decreases
  void _startTimer() {
    codeDialog3 = timeText;
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        if (codeDialog3 > 0) {
          codeDialog3--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("LotsRememberer"),
          backgroundColor: Color.fromARGB(255, 20, 27, 66),
        ),
        body: Center(
          child: remembered
              ? Center(
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.car_rental),
                          title: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text("CarPark Name: " + codeDialog),
                              Text("Lot Number: " + codeDialog2),
                              (codeDialog3 > 0)
                                  ? Text(
                                      'Count Down: $codeDialog3 mins',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28,
                                      ),
                                    )
                                  : Text("Time Up",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 48,
                                      )),
                            ],
                          ),
                          tileColor: Colors.white,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextButton(
                              child: const Text(
                                "Remove",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                remembered = false;
                                setState(() {});
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                    color: Color.fromARGB(255, 52, 53, 61),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage('assets/LR_pic.jpg'),
                      height: 250,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        onPressed: () async {
                          displayTextInputDialog(context);
                          // carparkDetail().x_cordinate_call();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 6, 35, 58),
                        ),
                        child: Text('Lot Rememberer'),
                      ),
                    ),
                  ],
                ),
        ),
        backgroundColor: Color.fromARGB(255, 52, 53, 61));
  }
}
