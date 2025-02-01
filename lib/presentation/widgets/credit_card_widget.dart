import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'dart:ui';
import '../../core/constants/media_query.dart';

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
      end: 1.015, // Reduced scale for subtler animation
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic, // Smoother animation curve
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
    MediaQueryUtil.init(context);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: Material(
          elevation: MediaQueryUtil.getValueInPixel(100),
          shadowColor: Colors.black.withOpacity(0.3),
          borderRadius:
              BorderRadius.circular(MediaQueryUtil.getValueInPixel(120)),
          child: Container(
            height: MediaQueryUtil.getDefaultHeightDim(500),
            width: MediaQueryUtil.getDefaultWidthDim(1300),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(MediaQueryUtil.getValueInPixel(120)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF141428).withOpacity(0.92),
                  const Color(0xFF0A243D).withOpacity(0.95),
                ],
                stops: const [0.2, 0.8],
              ),
              // Combined shadow layers for a refined elevation look
              boxShadow: [
                // Deep, soft shadow for overall depth
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  offset: Offset(0, MediaQueryUtil.getValueInPixel(12)),
                  blurRadius: MediaQueryUtil.getValueInPixel(30),
                  spreadRadius: MediaQueryUtil.getValueInPixel(2),
                ),
                // Lighter shadow on top for a subtle highlight
                BoxShadow(
                  color: Colors.white.withOpacity(0.05),
                  offset: Offset(0, MediaQueryUtil.getValueInPixel(-4)),
                  blurRadius: MediaQueryUtil.getValueInPixel(20),
                  spreadRadius: MediaQueryUtil.getValueInPixel(-2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(MediaQueryUtil.getValueInPixel(30)),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: MediaQueryUtil.getValueInPixel(8),
                  sigmaY: MediaQueryUtil.getValueInPixel(8),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white.withOpacity(0.05),
                      width: MediaQueryUtil.getValueInPixel(0.5),
                    ),
                    borderRadius: BorderRadius.circular(
                        MediaQueryUtil.getValueInPixel(30)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(MediaQueryUtil.getValueInPixel(30)),
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
                                  color: Colors.white.withOpacity(0.08),
                                  thickness: MediaQueryUtil.getValueInPixel(15),
                                ),
                                pointers: <GaugePointer>[
                                  RangePointer(
                                    value: currentValue,
                                    cornerStyle: CornerStyle.bothFlat,
                                    width: MediaQueryUtil.getValueInPixel(40),
                                    sizeUnit: GaugeSizeUnit.logicalPixel,
                                    gradient: const SweepGradient(
                                      colors: [
                                        Color(0xFFD4AF37),
                                        Color(0xFF926F34),
                                      ],
                                      stops: [0.3, 0.7],
                                    ),
                                  ),
                                  NeedlePointer(
                                    value: currentValue,
                                    needleColor: Colors.white,
                                    needleLength: 0.8,
                                    knobStyle: KnobStyle(
                                      color: Colors.white,
                                      borderColor: const Color(0xFF947D4E),
                                      borderWidth:
                                          MediaQueryUtil.getValueInPixel(4),
                                      knobRadius: 0.09,
                                    ),
                                    tailStyle: TailStyle(
                                      color: const Color(0xFFD4AF37),
                                      width: MediaQueryUtil.getValueInPixel(3),
                                      length: 0.18,
                                    ),
                                  ),
                                ],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(
                                    angle: 90,
                                    positionFactor: 0.05,
                                    widget: _buildGaugeContent(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        _buildFooterSection(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGaugeContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.header,
          style: TextStyle(
            fontSize: MediaQueryUtil.getFontSize(60),
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        SizedBox(height: MediaQueryUtil.getDefaultHeightDim(10)),
        Text(
          '₹${currentValue.toInt().toString().replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (Match m) => '${m[1]},',
              )}',
          style: TextStyle(
            fontSize: MediaQueryUtil.getFontSize(60),
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.95),
          ),
        ),
        SizedBox(height: MediaQueryUtil.getDefaultHeightDim(15)),
        Text(
          widget.description,
          style: TextStyle(
            fontSize: MediaQueryUtil.getFontSize(50),
            color: Colors.white.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFooterSection() {
    return Column(
      children: [
        Text(
          widget.footer,
          style: TextStyle(
            fontSize: MediaQueryUtil.getFontSize(60),
            color: Colors.white.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: MediaQueryUtil.getDefaultHeightDim(20)),
        _buildCustomSlider(),
      ],
    );
  }

  Widget _buildCustomSlider() {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: MediaQueryUtil.getValueInPixel(8),
        activeTrackColor: const Color(0xFF6C591D),
        inactiveTrackColor: Colors.white.withOpacity(0.08),
        thumbColor: Colors.white,
        overlayColor: Colors.white.withOpacity(0.05),
        thumbShape: RoundSliderThumbShape(
          enabledThumbRadius: MediaQueryUtil.getValueInPixel(25),
        ),
        overlayShape: RoundSliderOverlayShape(
          overlayRadius: MediaQueryUtil.getValueInPixel(40),
        ),
      ),
      child: Slider(
        value: currentValue,
        min: widget.minRange,
        max: widget.maxRange,
        onChanged: updateCurrentValue,
      ),
    );
  }
}
