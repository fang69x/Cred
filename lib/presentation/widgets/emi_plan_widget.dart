import 'package:flutter/material.dart';
import '../../data/models/emi_plan_model.dart';
import 'common_widgets.dart';
import '../../core/constants/media_query.dart';
import '../../data/models/api.model.dart';

class EMIPlan extends StatefulWidget {
  final Function onEMIChange;
  final List<BodyItem> emiPlanItems;
  final String footer;

  const EMIPlan({
    super.key,
    required this.onEMIChange,
    required this.emiPlanItems,
    required this.footer,
  });

  @override
  _EMIPlanState createState() => _EMIPlanState();
}

class _EMIPlanState extends State<EMIPlan> {
  int selectedPlanIndex = 0;

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQueryUtil.getDefaultHeightDim(800),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.emiPlanItems.length,
            itemBuilder: (context, index) {
              final plan = widget.emiPlanItems[index];
              final isSelected = selectedPlanIndex == index;

              return AnimatedScale(
                duration: const Duration(milliseconds: 300),
                scale: isSelected ? 1.05 : 1.0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPlanIndex = index;
                      widget.onEMIChange(EMIPlanModel(
                        label: plan.tag ?? '',
                        amount: plan.emi ?? '',
                        duration: plan.duration ?? '',
                      ));
                    });
                  },
                  child: Container(
                    width: MediaQueryUtil.getDefaultWidthDim(720),
                    margin: EdgeInsets.symmetric(
                      horizontal: MediaQueryUtil.getDefaultWidthDim(50),
                      vertical: MediaQueryUtil.getDefaultHeightDim(50),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: isSelected
                            ? [const Color(0xFFFDB631), const Color(0xFF947D4E)]
                            : [
                                const Color(0xFF2A2A4A),
                                const Color(0xFF1A1A2E)
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: isSelected
                          ? null
                          : Border.all(
                              color: Colors.white.withOpacity(0.1), width: 1),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (plan.tag != null && plan.tag!.isNotEmpty)
                                _buildTag(plan.tag!),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonWidgets.FontWidget(
                                    plan.title ?? 'N/A',
                                    Colors.white,
                                    FontWeight.w800,
                                    "Inter",
                                    FontStyle.normal,
                                    MediaQueryUtil.getFontSize(240),
                                    TextAlign.left,
                                  ),
                                  CommonWidgets.FontWidget(
                                    plan.subtitle ?? 'N/A',
                                    Colors.white.withOpacity(0.9),
                                    FontWeight.w500,
                                    "Inter",
                                    FontStyle.normal,
                                    MediaQueryUtil.getFontSize(200),
                                    TextAlign.left,
                                  ),
                                ],
                              ),
                              _buildPlanDetails(plan),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Positioned(
                            right: MediaQueryUtil.getDefaultWidthDim(20),
                            top: MediaQueryUtil.getDefaultHeightDim(20),
                            child: Container(
                              padding: EdgeInsets.all(
                                MediaQueryUtil.getValueInPixel(40),
                              ),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check_rounded,
                                color: Color(0xFFFDB631),
                                size: MediaQueryUtil.getFontSize(50),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: MediaQueryUtil.getDefaultHeightDim(20)),
        _buildFooterButton(),
      ],
    );
  }

  Widget _buildTag(String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQueryUtil.getDefaultWidthDim(24),
        vertical: MediaQueryUtil.getDefaultHeightDim(12),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: CommonWidgets.FontWidget(
        text,
        const Color(0xFF1A1A2E),
        FontWeight.w600,
        "Inter",
        FontStyle.normal,
        MediaQueryUtil.getFontSize(150),
        TextAlign.left,
      ),
    );
  }

  Widget _buildPlanDetails(BodyItem plan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: MediaQueryUtil.getDefaultHeightDim(100)),
        Row(
          children: [
            _buildDetailItem("EMI", plan.emi ?? 'N/A'),
            const SizedBox(width: 20),
            _buildDetailItem("Duration", plan.duration ?? 'N/A'),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonWidgets.FontWidget(
          label,
          Colors.white.withOpacity(0.7),
          FontWeight.w500,
          "Inter",
          FontStyle.normal,
          MediaQueryUtil.getFontSize(200),
          TextAlign.left,
        ),
        CommonWidgets.FontWidget(
          value,
          Colors.white,
          FontWeight.w700,
          "Inter",
          FontStyle.normal,
          MediaQueryUtil.getFontSize(150),
          TextAlign.left,
        ),
      ],
    );
  }

  Widget _buildFooterButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(
        horizontal: MediaQueryUtil.getDefaultWidthDim(20),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          MediaQueryUtil.getValueInPixel(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: MediaQueryUtil.getValueInPixel(8),
            offset: Offset(
              0,
              MediaQueryUtil.getValueInPixel(4),
            ),
          )
        ],
      ),
      child: ElevatedButton(
        onPressed: () => debugPrint("Footer button clicked!"),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQueryUtil.getDefaultWidthDim(32),
            vertical: MediaQueryUtil.getDefaultHeightDim(16),
          ),
          backgroundColor: Colors.transparent, // Transparent background
          shadowColor: Colors.transparent, // No shadow from the button itself
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              MediaQueryUtil.getValueInPixel(100),
            ),
            side: BorderSide(
              color: Colors.white,
              width: MediaQueryUtil.getValueInPixel(5),
            ), // White border
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonWidgets.FontWidget(
              widget.footer,
              Colors.white,
              FontWeight.w600,
              "Inter",
              FontStyle.normal,
              45,
              TextAlign.center,
            ),
            SizedBox(width: MediaQueryUtil.getDefaultWidthDim(12)),
            Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: MediaQueryUtil.getFontSize(40),
            ),
          ],
        ),
      ),
    );
  }
}
