import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../Riverpod/Controllers/premium_provider.dart';

class PaywallView extends ConsumerStatefulWidget {
  const PaywallView({super.key});

  @override
  ConsumerState<PaywallView> createState() => _PaywallViewState();
}

class _PaywallViewState extends ConsumerState<PaywallView> {
  int _selectedIndex = 0;
  List<Package> _packages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPackages();
  }

  Future<void> _loadPackages() async {
    try {
      final offerings = await ref.read(premiumProvider.notifier).getOfferings();
      if (mounted) {
        setState(() {
          _packages = offerings;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Stack(
        children: [
          Container(
            height: 400.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF06C44F).withValues(alpha: 0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Planınızı Yükseltin',
                    style: GoogleFonts.montserrat(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.5.sp,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    '30 Günlük Karın Kası serüvenine tam erişim sağlayın ve hedeflerinize daha hızlı ulaşın.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFB3B3B3),
                      height: 1.5,
                    ),
                  ),
                  if (_isLoading)
                    const Expanded(child: Center(child: CircularProgressIndicator(color: Color(0xFF06C44F))))
                  else if (_packages.isEmpty)
                    Expanded(
                      child: Center(
                        child: Text(
                          'Paketler şu an yüklenemiyor.\nLütfen daha sonra tekrar deneyin.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(color: Colors.white, fontSize: 14.sp),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _packages.length,
                        separatorBuilder: (context, index) => SizedBox(height: 16.h),
                        itemBuilder: (context, index) {
                          final package = _packages[index];
                          final product = package.storeProduct;
                          String subtitle = 'Seçkin Paket';
                          if (package.packageType == PackageType.monthly) subtitle = 'Hemen Başla';
                          if (package.packageType == PackageType.threeMonth) subtitle = 'En Popüler';
                          if (package.packageType == PackageType.annual) subtitle = 'En İyi Fiyat';

                          return _buildPackageOption(
                            index: index,
                            title: product.title,
                            price: product.priceString,
                            subtitle: subtitle,
                            isPopular: package.packageType == PackageType.threeMonth,
                          );
                        },
                      ),
                    ),

                  const Spacer(),
                  
                  GestureDetector(
                    onTap: () async {
                      if (_packages.isEmpty) return;

                      final messenger = ScaffoldMessenger.of(context);
                      final navigator = Navigator.of(context);
                      
                      try {
                        final package = _packages[_selectedIndex];
                        final success = await ref.read(premiumProvider.notifier).purchasePackage(package);
                        
                        if (success) {
                          messenger.showSnackBar(const SnackBar(content: Text('Tebrikler! Artık Premium üyesisiniz.')));
                          navigator.pop();
                        }
                      } catch (e) {
                         messenger.showSnackBar(SnackBar(content: Text('Bir hata oluştu: $e')));
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF06C44F),
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF06C44F).withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Devam Et',
                        style: GoogleFonts.montserrat(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextButton(
                    onPressed: () => ref.read(premiumProvider.notifier).restorePurchases(),
                    child: Text(
                      'Satın Almaları Geri Yükle',
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFFB3B3B3),
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageOption({
    required int index,
    required String title,
    required String price,
    required String subtitle,
    bool isPopular = false,
  }) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A1A1A) : Colors.transparent,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF06C44F) : const Color(0xFF333333),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (isPopular) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF06C44F),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            'POPÜLER',
                            style: GoogleFonts.montserrat(
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.montserrat(
                      fontSize: 12.sp,
                      color: const Color(0xFFB3B3B3),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: GoogleFonts.montserrat(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: isSelected ? const Color(0xFF06C44F) : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
