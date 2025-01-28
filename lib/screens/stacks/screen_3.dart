import 'package:cred/helperWidgets/curved_edge_button.dart';
import 'package:cred/models/api.model.dart';
import 'package:cred/models/emi_plan_model.dart';
import 'package:cred/models/stack_popup.dart';
import 'package:cred/providers/data.provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Screen3 extends StatefulWidget {
  final Function handleBackButton;
  final Function handleEMIPlan;

  const Screen3({
    Key? key,
    required this.handleBackButton,
    required this.handleEMIPlan,
  }) : super(key: key);

  @override
  _Screen3State createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> with TickerProviderStateMixin {
  late AnimationController slideController;
  late Animation<double> slideAnimation;
  final ValueNotifier<int?> selectedTileIndex = ValueNotifier<int?>(null);
  final Color primaryColor = const Color(0xFF4A90E2); // Primary brand color

  @override
  void initState() {
    StackPopupModel.incCurrentStackPopupIndex();
    slideController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    slideAnimation =
        Tween<double>(begin: 0.0, end: 0.6).animate(slideController);
    super.initState();
  }

  @override
  void dispose() {
    slideController.dispose();
    selectedTileIndex.dispose();
    StackPopupModel.decCurrentStackPopupIndex();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CredDataProvider>(
        builder: (context, credDataProvider, child) {
      if (credDataProvider.isLoading) {
        return _buildLoadingState();
      }
      if (credDataProvider.error != null) {
        return _buildErrorState(credDataProvider.error!);
      }
      if (credDataProvider.credData == null ||
          credDataProvider.credData!.items.isEmpty) {
        return _buildEmptyState();
      }

      final thirdItem = credDataProvider.credData!.items[2];
      final ctaText = thirdItem.ctaText;
      final openState = thirdItem.openState!.body;

      return Stack(
        children: [
          Column(
            children: [
              _buildMainContent(openState!, ctaText!),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildMainContent(OpenStateBody openState, String ctaText) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(openState),
            const SizedBox(height: 24),
            _buildBankList(openState),
            const SizedBox(height: 24),
            _buildFooter(openState),
            const SizedBox(height: 40),
            CurvedEdgeButton(
              text: ctaText,
              width: double.infinity,
              backgroundColor: primaryColor,
              textColor: Colors.white,
              onTap: () => widget.handleEMIPlan(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(OpenStateBody openState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          openState.title,
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.grey[800],
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          openState.subtitle,
          style: GoogleFonts.roboto(
            fontSize: 15,
            color: Colors.grey[600],
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildBankList(OpenStateBody openState) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: openState.items.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: Colors.grey[200],
          indent: 16,
          endIndent: 16,
        ),
        itemBuilder: (context, index) {
          final bank = openState.items[index];
          return ValueListenableBuilder<int?>(
            valueListenable: selectedTileIndex,
            builder: (context, selectedIndex, child) {
              final isSelected = selectedIndex == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor.withOpacity(0.05) : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.account_balance,
                      color: primaryColor,
                      size: 24,
                    ),
                  ),
                  title: Text(
                    bank.title!,
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    bank.subtitle.toString(),
                    style: GoogleFonts.roboto(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  trailing: Checkbox(
                    value: isSelected,
                    onChanged: (value) =>
                        selectedTileIndex.value = value! ? index : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    activeColor: primaryColor,
                  ),
                  onTap: () =>
                      selectedTileIndex.value = isSelected ? null : index,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFooter(OpenStateBody openState) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Text(
        openState.footer,
        textAlign: TextAlign.center,
        style: GoogleFonts.roboto(
          color: Colors.grey[600],
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: primaryColor),
          const SizedBox(height: 16),
          Text(
            'Loading options...',
            style: GoogleFonts.roboto(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: Colors.red[300], size: 48),
          const SizedBox(height: 16),
          Text(
            'Failed to load data',
            style: GoogleFonts.roboto(
              color: Colors.grey[800],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: GoogleFonts.roboto(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.hourglass_empty, color: Colors.grey[400], size: 48),
          const SizedBox(height: 16),
          Text(
            'No payment options available',
            style: GoogleFonts.roboto(
              color: Colors.grey[800],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void reverseStackPopupAnim() {}
}
