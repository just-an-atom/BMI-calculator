import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMI Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'BMI Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController ftInput = TextEditingController();
  TextEditingController inInput = TextEditingController();
  TextEditingController lbsInput = TextEditingController();

  bool canCalc = false;

  double inches = 0;
  double feet = 0;
  double lbs = 0;
  double bmi = 0;

  double totalInches = 0;

  @override
  Widget build(BuildContext context) {
    calcFt(String val) async {
      if (val.isNotEmpty) {
        if (val.contains(RegExp(r'[-\s,]')) == false) {
          setState(() {
            double _feet = double.parse(val);

            feet = _feet;
          });
        } else {
          ftInput.clear();
          print(val + " not allowed");
        }
      } else {
        feet = 0;
      }
    }

    calcIn(String val) async {
      if (val.isNotEmpty) {
        if (val.contains(RegExp(r'[-\s,]')) == false) {
          setState(() {
            double _inches = double.tryParse(val)!;

            inches = _inches;
          });
        } else {
          inInput.clear();
          print(val + " not allowed");
        }
      } else {
        inches = 0;
      }
    }

    calcLbs(String val) async {
      if (val.isNotEmpty) {
        if (val.contains(RegExp(r'[-\s,]')) == false) {
          setState(() {
            double _lbs = double.tryParse(val)!;

            lbs = _lbs;
          });
        } else {
          lbsInput.clear();
          print(val + " not allowed");
        }
      } else {
        lbs = 0;
      }
    }

    calcBMI() {
      if (feet > 0 && inches > 0 && lbs > 0) {
        setState(() {
          canCalc = true;

          totalInches = (feet * 12) + inches;

          bmi = (lbs / totalInches / totalInches) * 703;

          print(bmi.toStringAsFixed(1));
        });
      } else {
        setState(() {
          bmi = 0;
        });
      }
    }

    String calcBMIGrouping(double bmi) {
      if (bmi >= 30) {
        // Obeses
        return "Obeses";
      } else if (bmi >= 25) {
        // Overweight
        return "Overweight";
      } else if (bmi >= 18.5) {
        // Normal weight
        return "Normal weight";
      } else if (bmi <= 18.5) {
        // Underweight
        return "Underweight";
      } else if (bmi <= 0) {
        return "";
      } else {
        return "";
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: TextField(
                      keyboardType: const TextInputType.numberWithOptions(
                        signed: false,
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.next,
                      controller: ftInput,
                      onChanged: (val) {
                        calcFt(val);
                      },
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Feet',
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    flex: 1,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: inInput,
                      onChanged: (val) {
                        calcIn(val);
                      },
                      enableSuggestions: false,
                      autocorrect: false,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Inches',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.number,
                controller: lbsInput,
                onChanged: (val) {
                  calcLbs(val);
                },
                enableSuggestions: false,
                autocorrect: false,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Weight (lbs)',
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => calcBMI(),
                  child: const Text("Calculate"),
                ),
              ),
              const SizedBox(height: 20),
              Text(bmi == 0
                  ? "Please fill out the form to see BMI score"
                  : "BMI Score: " + bmi.toStringAsFixed(1)),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      canCalc == false ? "" : calcBMIGrouping(bmi),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
