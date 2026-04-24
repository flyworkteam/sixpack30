import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../Riverpod/Controllers/premium_provider.dart';

class RevenueCatPaywallView extends ConsumerStatefulWidget {
  const RevenueCatPaywallView({super.key});

  @override
  ConsumerState<RevenueCatPaywallView> createState() => _RevenueCatPaywallViewState();
}

class _RevenueCatPaywallViewState extends ConsumerState<RevenueCatPaywallView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          PaywallView(
            onPurchaseCompleted: (customerInfo, _) async {
              await ref.read(premiumProvider.notifier).updatePurchaseStatus();
              if (context.mounted) Navigator.pop(context);
            },
            onRestoreCompleted: (customerInfo) async {
              await ref.read(premiumProvider.notifier).updatePurchaseStatus();
              if (context.mounted) Navigator.pop(context);
            },
          ),
          
          Positioned(
            right: 10,
            top: MediaQuery.of(context).padding.top + 5,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 50,
                height: 50,
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
