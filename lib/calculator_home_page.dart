import 'package:calculator/buttons.dart';
import 'package:flutter/material.dart';

class CalculatorHomePage extends StatefulWidget {
  const CalculatorHomePage({super.key});

  @override
  State<CalculatorHomePage> createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String num1 = ""; //
  String operand = "";
  String num2 = "";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    num1.isEmpty && operand.isEmpty && num2.isEmpty
                        ? "0"
                        : "$num1$operand$num2",
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),

            //buttn
            Wrap(
              children: Button.btnValues
                  .map(
                    (value) => SizedBox(
                        width: value == Button.zero
                            ? screenSize.width / 2
                            : (screenSize.width / 4),
                        height: screenSize.width / 5,
                        child: buildButton(value)),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
          color: getBtnColor(value),
          clipBehavior: Clip.hardEdge,
          shape: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white24),
            borderRadius: BorderRadius.circular(100),
          ),
          child: InkWell(
              onTap: () => onBtnTap(value),
              child: Center(
                  child: Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 27,
                ),
              )))),
    );
  }

  void onBtnTap(String value) {
    if (value == Button.clear) {
      clearAll();
      return;
    }

    if (value == Button.percent) {
      convertPercentage();
      return;
    }
    if (value == Button.delete) {
      delete();
      return;
    }

    if (value == Button.calculate) {
      calculate();
      return;
    }
    appendValue(value);
  }

  void calculate() {
    if (num1.isEmpty) return;
    if (operand.isEmpty) return;
    if (num2.isEmpty) return;

    num1 = num1.trim();
    num2 = num2.trim();

    try {
      double number1 = double.parse(num1.trim());
      double number2 = double.parse(num2.trim());

      double result = 0.0;
      switch (operand) {
        case Button.add:
          result = number1 + number2;
          break;
        case Button.subtract:
          result = number1 - number2;
          break;

        case Button.divide:
          if (number2 == 0) {
            setState(() {
              num1 = "Error";
              operand = "";
              num2 = "";
            });
            return;
          }
          result = number1 / number2;
          break;
        case Button.multiply:
          result = number1 * number2;
          break;
        default:
          result = number1;
      }

      setState(() {
        num1 = result.toStringAsFixed(3);
        if (num1.endsWith(".000")) {
          num1 = num1.substring(0, num1.length - 4);
        }

        operand = "";
        num2 = "";
      });
    } catch (e) {
      setState(() {
        num1 = "Error";
        operand = "";
        num2 = "";
      });
    }
  }

  void convertPercentage() {
    if (num1.isNotEmpty && operand.isNotEmpty && num2.isNotEmpty) {
      calculate();
    }

    if (operand.isNotEmpty) {
      return;
    }

    final number = double.parse(num1);
    setState(() {
      num1 = "${(number / 100)}";
      operand = "";
      num2 = "";
    });
  }

  void clearAll() {
    setState(() {
      num1 = "";
      operand = "";
      num2 = "";
    });
  }

  void delete() {
    if (num2.isNotEmpty) {
      num2 = num2.substring(0, num2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (num1.isNotEmpty) {
      num1 = num1.substring(0, num1.length - 1);
    }
    setState(() {});
  }

  void appendValue(String value) {
    if (value == Button.subtract && num1.isEmpty && operand.isEmpty) {
      num1 = "-";
      setState(() {});
      return;
    }

    if (value == Button.subtract && operand.isNotEmpty && num2.isEmpty) {
      num2 = "-";
      setState(() {});
      return;
    }

    if (value != Button.dot && int.tryParse(value) == null) {
      if (operand.isNotEmpty && num2.isNotEmpty) {
        calculate();
      }
      operand = value;
    } else if (num1.isEmpty || operand.isEmpty) {
      if (value == Button.dot && num1.contains(Button.dot)) return;
      if (value == Button.dot && (num1.isEmpty || num1 == Button.dot)) {
        value = "0.";
      }
      num1 += value;
    } else if (num2.isEmpty || operand.isNotEmpty) {
      if (value == Button.dot && num2.contains(Button.dot)) return;
      if (value == Button.dot && (num2.isEmpty || num2 == Button.dot)) {
        value = "0.";
      }
      num2 += value;
    }
    setState(() {});
  }

  Color getBtnColor(value) {
    return [Button.delete, Button.clear].contains(value)
        ? const Color.fromARGB(255, 102, 137, 155)
        : [
            Button.percent,
            Button.multiply,
            Button.add,
            Button.subtract,
            Button.divide,
            Button.calculate,
          ].contains(value)
            ? Colors.grey
            : Colors.black;
  }
}
