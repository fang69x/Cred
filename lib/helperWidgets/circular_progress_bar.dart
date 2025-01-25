import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CreditCardWidget extends StatefulWidget {
  final double minRange;
  final double maxRange;
  final String header;
  final String description;
  final String footer;
  final Function(double progress, int finalValue) onChanged;

  const CreditCardWidget({
    Key? key,
    required this.minRange,
    required this.maxRange,
    required this.header,
    required this.description,
    required this.footer,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CreditCardWidgetState createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget> {
  late double currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.minRange;
  }

  void updateCurrentValue(double value) {
    setState(() {
      currentValue = value;
    });
    widget.onChanged(value, value.toInt());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: screenHeight * 0.5,
        width: screenWidth * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: SfRadialGauge(
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
                          color: const Color.fromARGB(255, 144, 101, 36),
                        ),
                        NeedlePointer(
                          value: currentValue,
                          needleColor: Colors.black,
                          knobStyle: KnobStyle(
                            color: Colors.white,
                            borderColor:
                                const Color.fromARGB(255, 255, 255, 255),
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
                              Flexible(
                                child: Text(
                                  widget.header,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.005),
                              Text(
                                '₹${currentValue.toInt()}',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.055,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Flexible(
                                child: Text(
                                  widget.description,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                widget.footer,
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
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
      ),
    );
  }
}
