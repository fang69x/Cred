import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class CreditSliderPage extends StatefulWidget {
  final double maxAmount;
  final double minAmount;
  final String monthlyRate;

  const CreditSliderPage({
    Key? key,
    required this.maxAmount,
    required this.minAmount,
    required this.monthlyRate,
  }) : super(key: key);

  @override
  State<CreditSliderPage> createState() => _CreditSliderPageState();
}

class _CreditSliderPageState extends State<CreditSliderPage> {
  double _currentAmount = 0;

  @override
  void initState() {
    super.initState();
    _currentAmount = widget.minAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'nikunj, how much do you need?',
              ),
              const SizedBox(height: 8),
              Text(
                'move the dial and set any amount you need upto ₹${widget.maxAmount.toStringAsFixed(0)}',
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Center(
                  child: SleekCircularSlider(
                    min: widget.minAmount,
                    max: widget.maxAmount,
                    initialValue: _currentAmount,
                    onChange: (double value) {
                      setState(() {
                        _currentAmount = value;
                      });
                    },
                    appearance: CircularSliderAppearance(
                      size: 300,
                      startAngle: 180,
                      angleRange: 360,
                      customWidths: CustomSliderWidths(progressBarWidth: 10),
                      customColors: CustomSliderColors(
                          progressBarColors: [Colors.blue, Colors.green]),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'stash is instant. money will be credited within seconds',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
