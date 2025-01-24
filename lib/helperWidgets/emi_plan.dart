import 'package:flutter/material.dart';
import '../models/emi_plan_model.dart';
import '../utils/common_widgets.dart';
import '../utils/media_query.dart';
import '../models/api.model.dart'; // Import the API model

class EMIPlan extends StatefulWidget {
  final Function onEMIChange;
  final List<BodyItem> emiPlanItems; // Pass API data
  final String footer;
  const EMIPlan({
    super.key,
    required this.onEMIChange,
    required this.emiPlanItems,
    required this.footer, // Constructor update
  });

  @override
  _EMIPlanState createState() => _EMIPlanState();
}

class _EMIPlanState extends State<EMIPlan> {
  int selectedPlanIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQueryUtil.getDefaultHeightDim(600),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.emiPlanItems.length,
            itemBuilder: (context, index) {
              final plan = widget.emiPlanItems[index];
              return GestureDetector(
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
                  width: MediaQueryUtil.getDefaultWidthDim(700),
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: selectedPlanIndex == index
                        ? Colors.green.shade400
                        : Colors.grey.shade800,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (plan.tag != null && plan.tag!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: CommonWidgets.FontWidget(
                            plan.tag!,
                            Colors.black,
                            FontWeight.w600,
                            "Inter",
                            FontStyle.normal,
                            40,
                            TextAlign.left,
                          ),
                        ),
                      SizedBox(height: 16.0),
                      CommonWidgets.FontWidget(
                        plan.title ?? 'N/A',
                        Colors.white,
                        FontWeight.bold,
                        "Inter",
                        FontStyle.normal,
                        80,
                        TextAlign.left,
                      ),
                      SizedBox(height: 16.0),
                      CommonWidgets.FontWidget(
                        plan.subtitle ?? 'N/A',
                        Colors.white,
                        FontWeight.normal,
                        "Inter",
                        FontStyle.normal,
                        60,
                        TextAlign.left,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: MediaQueryUtil.getDefaultHeightDim(50)),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Action to perform when the footer button is clicked
                  debugPrint("Footer button clicked!");
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green, // Text color
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                ),
                child: CommonWidgets.FontWidget(
                  widget.footer,
                  Colors.white,
                  FontWeight.w400,
                  "Inter",
                  FontStyle.normal,
                  40,
                  TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
