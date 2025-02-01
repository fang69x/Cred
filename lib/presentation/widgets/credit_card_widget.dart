import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'dart:ui';

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
    required double cardHeight,
  }) : super(key: key);

  @override
  _CreditCardWidgetState createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget>
    with SingleTickerProviderStateMixin {
  late double currentValue;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    currentValue = widget.minRange;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: Container(
          height: screenHeight * 0.5,
          width: screenWidth * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF141428).withOpacity(0.95),
                const Color(0xFF0A243D).withOpacity(0.90),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 50),
              ),
              BoxShadow(
                color: Colors.blue.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(-10, -30),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
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
                                color: Colors.white.withOpacity(0.1),
                                thickness: 15,
                              ),
                              pointers: <GaugePointer>[
                                RangePointer(
                                  value: currentValue,
                                  cornerStyle: CornerStyle.bothFlat,
                                  width: 15,
                                  sizeUnit: GaugeSizeUnit.logicalPixel,
                                  gradient: const SweepGradient(colors: [
                                    Color(0xFFD4AF37),
                                    Color(0xFF926F34)
                                  ]),
                                ),
                                NeedlePointer(
                                  value: currentValue,
                                  needleColor: Colors.white,
                                  needleLength: 0.6,
                                  knobStyle: KnobStyle(
                                    color: Colors.white,
                                    borderColor: const Color(0xFF947D4E),
                                    borderWidth: 2,
                                    knobRadius: 0.08,
                                  ),
                                  tailStyle: const TailStyle(
                                    color: Color(0xFFD4AF37),
                                    width: 4,
                                    length: 0.2,
                                  ),
                                ),
                              ],
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                  angle: 90,
                                  positionFactor: 0.05,
                                  widget: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        widget.header,
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.045,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromARGB(
                                                  132, 9, 32, 54)
                                              .withOpacity(0.9),
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.01),
                                      Text(
                                        '₹${currentValue.toInt().toString().replaceAllMapped(
                                              RegExp(
                                                  r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                              (Match m) => '${m[1]},',
                                            )}',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.06,
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromARGB(
                                                  132, 9, 32, 54)
                                              .withOpacity(0.9),
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.015),
                                      Text(
                                        widget.description,
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.03,
                                          color: const Color.fromARGB(
                                                  193, 12, 0, 92)
                                              .withOpacity(0.8),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Text(
                        widget.footer,
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 4,
                          activeTrackColor:
                              const Color.fromARGB(255, 108, 89, 29),
                          inactiveTrackColor: Colors.white.withOpacity(0.1),
                          thumbColor: Colors.white,
                          overlayColor: const Color.fromARGB(255, 0, 0, 0)
                              .withOpacity(0.2),
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 8,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 16,
                          ),
                        ),
                        child: Slider(
                          value: currentValue,
                          min: widget.minRange,
                          max: widget.maxRange,
                          onChanged: updateCurrentValue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
