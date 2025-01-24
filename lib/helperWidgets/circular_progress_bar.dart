import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CreditCardWidget extends StatefulWidget {
  final double minRange;
  final double maxRange;
  final String header;
  final String description;
  final String footer;
  final Function(double progress, int finalValue) onChanged; // Callback

  CreditCardWidget({
    required this.minRange,
    required this.maxRange,
    required this.header,
    required this.description,
    required this.footer,
    required this.onChanged, // Initialize callback function
  });

  @override
  _CreditCardWidgetState createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget> {
  late double currentValue;

  @override
  void initState() {
    super.initState();
    currentValue =
        widget.minRange; // Initialize currentValue with the minRange value
  }

  // Method to update the current value and trigger the callback
  void updateCurrentValue(double value) {
    setState(() {
      currentValue = value;
    });
    widget.onChanged(value, value.toInt()); // Trigger callback with both values
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header Text
            SizedBox(height: 10),
            // Description Text
            SizedBox(height: 20),
            // Radial Gauge
            SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                  minimum: widget.minRange,
                  maximum: widget.maxRange,
                  startAngle: 270,
                  endAngle: 270,
                  showLabels: false,
                  showTicks: false,
                  axisLineStyle: AxisLineStyle(
                    cornerStyle: CornerStyle.bothFlat,
                    color: Colors.black12,
                    thickness: 15,
                  ),
                  pointers: <GaugePointer>[
                    RangePointer(
                      value: currentValue,
                      cornerStyle: CornerStyle.bothFlat,
                      width: 15,
                      sizeUnit: GaugeSizeUnit.logicalPixel,
                      color: Colors.orange,
                    ),
                    NeedlePointer(
                      value: currentValue,
                      needleColor: Colors.black,
                      knobStyle: KnobStyle(
                        color: Colors.white,
                        borderColor: Colors.orange,
                        borderWidth: 3,
                      ),
                    ),
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                      angle: 90,
                      positionFactor: 0.1,
                      widget: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.header,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '₹${currentValue.toInt()}',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            widget.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            // Footer Text
            Text(
              widget.footer,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
            SizedBox(height: 20),
            // Slider to change currentValue dynamically
            Slider(
              value: currentValue,
              min: widget.minRange,
              max: widget.maxRange,
              onChanged: (value) {
                updateCurrentValue(value);
              },
              activeColor: Colors.orange,
              inactiveColor: Colors.black12,
            ),
          ],
        ),
      ),
    );
  }
}
