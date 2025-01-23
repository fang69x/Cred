import 'package:flutter/material.dart';

import '../models/emi_plan_model.dart';
import '../utils/common_widgets.dart';
import '../utils/media_query.dart';

class EMIPlan extends StatefulWidget {
  final Function onEMIChange;

  const EMIPlan({super.key, required this.onEMIChange});
  @override
  _EMIPlanState createState() => _EMIPlanState();
}

class _EMIPlanState extends State<EMIPlan> {
  int selectedPlanIndex = 0;

  final List<EMIPlanModel> emiPlans = [
    EMIPlanModel(label: 'RECOMMENDED', amount: '₹5,117', duration: '24 months'),
    EMIPlanModel(label: '', amount: '₹6,540', duration: '18 months'),
    EMIPlanModel(label: '', amount: '₹9,397', duration: '12 months'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: List.generate(emiPlans.length, (index) {
            return InkWell(
              onTap: () {
                setState(() {
                  selectedPlanIndex = index;
                });
              },
              child: Container(
                width: MediaQueryUtil.getDefaultWidthDim(1200),
                // margin: const EdgeInsets.symmetric(vertical: 8.0),
                // padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.0),
                  color: selectedPlanIndex == index ? Colors.green.shade400 : Colors.transparent,
                ),
                child: RadioListTile<int>(
                  title: CommonWidgets.FontWidget(emiPlans[index].amount, Colors.white, FontWeight.w600, "Inter", FontStyle.normal, 60, TextAlign.left),
                  subtitle: CommonWidgets.FontWidget(emiPlans[index].duration, Colors.white.withOpacity(0.7), FontWeight.w600, "Inter", FontStyle.normal, 60, TextAlign.left),
                  value: index,
                  groupValue: selectedPlanIndex,
                  onChanged: (value) {
                    setState(() {
                      selectedPlanIndex = value!;
                      widget.onEMIChange(emiPlans[index]);
                    });
                  },
                  activeColor: Colors.white,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
            );
          }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CommonWidgets.FontWidget("More EMI plans", Colors.white, FontWeight.w400, "Inter", FontStyle.normal, 40, TextAlign.left),
            CommonWidgets.FontWidget("First EMI date: 02 May \'24", Colors.white, FontWeight.w400, "Inter", FontStyle.normal, 40, TextAlign.left),
          ],
        ),
      ],
    );
  }
}
