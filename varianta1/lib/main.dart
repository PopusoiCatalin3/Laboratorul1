import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoanCalculator(),
    ));

class LoanCalculator extends StatefulWidget {
  const LoanCalculator({super.key});

  @override
  State<LoanCalculator> createState() => _LoanCalculatorState();
}

class _LoanCalculatorState extends State<LoanCalculator> {
  double _sliderValue = 6;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _percentageController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();

  String _monthlyPayment = '';

  void _calculateMonthlyPayment() {
    final double? principal = double.tryParse(_amountController.text);
    final double? annualInterestRate =
        double.tryParse(_percentageController.text);
    final int months = _sliderValue.toInt();

    if (principal != null &&
        annualInterestRate != null &&
        principal > 0 &&
        annualInterestRate > 0) {
      double monthlyInterestRate = (annualInterestRate / 100) / 12;

      double monthlyPayment = (principal *
              monthlyInterestRate *
              pow(1 + monthlyInterestRate, months)) /
          (pow(1 + monthlyInterestRate, months) - 1);

      setState(() {
        _monthlyPayment =
            'Approximate Payment: \$${monthlyPayment.toStringAsFixed(2)}';
      });
    } else {
      setState(() {
        _monthlyPayment = 'Please enter valid values';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Calculator'),
        backgroundColor: const Color(0xFF2980B9),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6DD5FA), Color(0xFF2980B9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildInputField(
                  controller: _amountController,
                  label: 'Enter Loan Amount',
                  icon: Icons.attach_money,
                  inputFormatters: [
                    FilteringTextInputFormatter
                        .digitsOnly, // Permite doar cifre
                  ],
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  controller: _percentageController,
                  label: 'Enter Interest Rate (%)',
                  icon: Icons.percent,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(
                        r'^\d+\.?\d{0,2}')), // Permite doar numere cu maximum două zecimale
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  "Choose number of months",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _monthsController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly, // Permite doar cifre
                        ],
                        decoration: InputDecoration(
                          labelText: "Enter Months",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          final int? newMonths = int.tryParse(value);
                          if (newMonths != null &&
                              newMonths >= 1 &&
                              newMonths <= 60) {
                            setState(() {
                              _sliderValue = newMonths.toDouble();
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${_sliderValue.toInt()} months',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.white,
                    inactiveTrackColor: Colors.white38,
                    thumbColor: Colors.white,
                    overlayColor: Colors.white24,
                    thumbShape:
                        const RoundSliderThumbShape(enabledThumbRadius: 12),
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 24),
                  ),
                  child: Slider(
                    value: _sliderValue,
                    min: 1,
                    max: 60,
                    divisions: 59,
                    label: '${_sliderValue.toInt()} months',
                    onChanged: (value) {
                      setState(() {
                        _sliderValue = value;
                        _monthsController.text =
                            _sliderValue.toInt().toString();
                      });
                    },
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    onPressed: _calculateMonthlyPayment,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Calculate Payment',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF2980B9),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: Text(
                    _monthlyPayment,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF2980B9)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
