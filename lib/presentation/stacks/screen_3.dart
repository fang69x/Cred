import 'package:cred/core/constants/media_query.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'package:cred/presentation/widgets/curved_edge_button.dart';
import 'package:cred/data/models/api.model.dart';
import 'package:cred/data/models/stack_popup.dart';
import 'package:cred/presentation/providers/api_data_provider.dart';

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
    MediaQueryUtil.init(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0A2F4D),
            const Color(0xFF1A1A2E).withOpacity(0.9),
          ],
        ),
      ),
      child: Consumer<CredDataProvider>(
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
              _buildBackgroundElements(),
              _buildMainContent(openState!, ctaText!),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBackgroundElements() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blueAccent.withOpacity(0.1),
              Colors.purpleAccent.withOpacity(0.05),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(OpenStateBody openState, String ctaText) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            MediaQueryUtil.getResponsivePadding(horizontal: 50, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(openState),
            SizedBox(height: MediaQueryUtil.getDefaultHeightDim(50)),
            _buildBankList(openState),
            SizedBox(height: MediaQueryUtil.getDefaultHeightDim(50)),
            _buildFooter(openState),
            SizedBox(height: MediaQueryUtil.getDefaultHeightDim(50)),
            CurvedEdgeButton(
              text: ctaText,
              width: double.infinity,
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
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: MediaQueryUtil.getFontSize(80),
            fontWeight: FontWeight.w700,
            height: 1.2,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: MediaQueryUtil.getDefaultHeightDim(20)),
        Text(
          openState.subtitle,
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.8),
            fontSize: MediaQueryUtil.getFontSize(40),
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildBankList(OpenStateBody openState) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 5),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: openState.items.length,
            separatorBuilder: (context, index) => Divider(
              height: 0,
              color: Colors.white.withOpacity(0.1),
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
                      color: isSelected
                          ? Colors.white.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: MediaQueryUtil.getResponsivePadding(
                        horizontal: 50,
                        vertical: 30,
                      ),
                      leading: Container(
                        padding: EdgeInsets.all(
                            MediaQueryUtil.getDefaultWidthDim(5)),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4AF37).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.account_balance,
                          color: const Color(0xFFD4AF37),
                          size: MediaQueryUtil.getValueInPixel(100),
                        ),
                      ),
                      title: Text(
                        bank.title!,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: MediaQueryUtil.getFontSize(60),
                        ),
                      ),
                      subtitle: Text(
                        bank.subtitle.toString(),
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: MediaQueryUtil.getFontSize(50),
                        ),
                      ),
                      trailing: Container(
                        width: MediaQueryUtil.getValueInPixel(100),
                        height: MediaQueryUtil.getValueInPixel(80),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFD4AF37)
                                : Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                          color: isSelected
                              ? const Color(0xFFD4AF37)
                              : Colors.transparent,
                        ),
                        child: isSelected
                            ? const Icon(Icons.check,
                                size: 16, color: Colors.black)
                            : null,
                      ),
                      onTap: () =>
                          selectedTileIndex.value = isSelected ? null : index,
                      splashColor:
                          Colors.white24, // Add Material touch feedback
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(OpenStateBody openState) {
    return Container(
      child: Text(
        openState.footer,
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          color: Colors.white.withOpacity(0.7),
          fontSize: MediaQueryUtil.getFontSize(50),
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white.withOpacity(0.8)),
            strokeWidth: 2,
          ),
          SizedBox(height: MediaQueryUtil.getDefaultHeightDim(16)),
          Text(
            'Loading payment options...',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.8),
              fontSize: MediaQueryUtil.getFontSize(50),
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
          Icon(Icons.error_outline,
              color: Colors.white.withOpacity(0.8), size: 48),
          SizedBox(height: MediaQueryUtil.getDefaultHeightDim(16)),
          Text(
            'Failed to load data',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.9),
              fontSize: MediaQueryUtil.getFontSize(50),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: MediaQueryUtil.getDefaultHeightDim(8)),
          Text(
            error,
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.7),
              fontSize: MediaQueryUtil.getFontSize(50),
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
          Icon(Icons.hourglass_empty,
              color: Colors.white.withOpacity(0.8), size: 48),
          const SizedBox(height: 16),
          Text(
            'No payment options available',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.9),
              fontSize: MediaQueryUtil.getFontSize(50),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
