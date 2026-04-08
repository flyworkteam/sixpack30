import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
class ProfileEditView extends StatefulWidget {
  const ProfileEditView({super.key});
  @override
  State<ProfileEditView> createState() => _ProfileEditViewState();
}
class _ProfileEditViewState extends State<ProfileEditView> {
  bool _isDropdownOpen = false;
  String _selectedBodyType = 'Normal';
  String _activeField = '';
  int _age = 26;
  int _height = 165;
  int _weight = 52;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 150.h, top: 73.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(237, 237, 237, 0.85),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(Icons.arrow_back_ios_new,
                                size: 14.sp, color: Colors.black),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Profili Düzenle',
                            style: GoogleFonts.montserrat(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              letterSpacing: -0.11.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 24.w),
                    ],
                  ),
                ),
                SizedBox(height: 36.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 48.w),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 49.w,
                        height: 49.w,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 24.r,
                              backgroundColor: const Color(0xFFD9D9D9),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/genderWOMAN.png',
                                  width: 48.w,
                                  height: 48.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                width: 16.w,
                                height: 16.w,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(240, 240, 240, 0.85),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white, width: 1.w),
                                ),
                                child: Center(
                                  child: Icon(Icons.edit,
                                      size: 9.sp,
                                      color: const Color.fromRGBO(78, 74, 74, 0.88)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Sinem Bakır',
                        style: GoogleFonts.montserrat(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0D0D0D),
                          letterSpacing: -0.11.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),
                _buildFormField(label: 'Adınız', value: 'Sinem Bakır', isEditable: false),
                SizedBox(height: 20.h),
                _buildBodyTypeField(),
                SizedBox(height: 20.h),
                _buildFormField(
                  label: 'Yaşınız',
                  value: _age.toString(),
                  onTap: () {
                    setState(() => _activeField = 'Yaşınız');
                    _showAgeBottomSheet();
                  },
                ),
                SizedBox(height: 20.h),
                _buildFormField(
                  label: 'Boyunuz',
                  value: (_height / 100).toStringAsFixed(2),
                  onTap: () {
                    setState(() => _activeField = 'Boyunuz');
                    _showVerticalRulerBottomSheet(
                      unit: 'cm',
                      minValue: 100,
                      maxValue: 250,
                      initialValue: _height,
                      onChanged: (val) {
                        setState(() => _height = val);
                      },
                    );
                  },
                ),
                SizedBox(height: 20.h),
                _buildFormField(
                  label: 'Kilonuz',
                  value: _weight.toString(),
                  onTap: () {
                    setState(() => _activeField = 'Kilonuz');
                    _showRulerBottomSheet(
                      unit: 'kg',
                      minValue: 30,
                      maxValue: 200,
                      initialValue: _weight,
                      majorTickOffset: 5,
                      onChanged: (val) {
                        setState(() => _weight = val);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            left: 24.w,
            right: 24.w,
            bottom: 40.h,
            child: SizedBox(
              width: 342.w,
              height: 76.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 342.w,
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00EF5B),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: Text(
                          'Değişiklikleri Kaydet',
                          style: GoogleFonts.montserrat(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            height: 1.25,
                            letterSpacing: -0.176.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  GestureDetector(
                    onTap: () {
                    },
                    child: SizedBox(
                      height: 20.h,
                      child: Center(
                        child: Text(
                          'Hesabı Sil',
                          style: GoogleFonts.montserrat(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            height: 1.25,
                            letterSpacing: -0.176.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isDropdownOpen)
            Positioned(
              left: 270.w,
              top: 360.h,
              child: _buildDropdownOverlay(),
            ),
        ],
      ),
    );
  }
  Widget _buildFormField({
    required String label,
    required String value,
    bool isEditable = true,
    VoidCallback? onTap,
  }) {
    final bool isActive = _activeField == label;
    final Color borderColor = isEditable
        ? (isActive ? const Color(0xFF737373) : const Color(0xFFEBEBEB))
        : Colors.transparent;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              letterSpacing: -0.11.sp,
            ),
          ),
          SizedBox(height: 5.h),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 342.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                border: isEditable ? Border.all(color: borderColor) : null,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: GoogleFonts.montserrat(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF525050),
                      letterSpacing: -0.11.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildBodyTypeField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vücut Tipiniz',
            style: GoogleFonts.montserrat(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              letterSpacing: -0.11.sp,
            ),
          ),
          SizedBox(height: 5.h),
          GestureDetector(
            onTap: () {
              setState(() {
                _isDropdownOpen = !_isDropdownOpen;
              });
            },
            child: Container(
              width: 342.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                border: Border.all(color: const Color(0xFFEBEBEB)),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedBodyType,
                      style: GoogleFonts.montserrat(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF525050),
                        letterSpacing: -0.11.sp,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: const Color(0xFF525050),
                      size: 20.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildDropdownOverlay() {
    final types = ['Zayıf', 'Normal', 'Kilolu', 'Çok Kilolu'];
    return Container(
      width: 85.w,
      height: 82.h,
      decoration: BoxDecoration(
        color: const Color(0xFFECECEC),
        border: Border.all(color: const Color.fromRGBO(235, 235, 235, 0.11)),
        borderRadius: BorderRadius.circular(6.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: types.map((type) {
          final isSelected = _selectedBodyType == type;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedBodyType = type;
                _isDropdownOpen = false;
              });
            },
            child: Container(
              width: 85.w,
              height: 20.h,
              color: isSelected ? const Color.fromRGBO(208, 205, 205, 0.43) : Colors.transparent,
              child: Center(
                child: Text(
                  type,
                  style: GoogleFonts.montserrat(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF0D0D0D),
                    letterSpacing: -0.11.sp,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
  void _showAgeBottomSheet() {
    int selectedIndex = _age - 13;
    if (selectedIndex < 0) selectedIndex = 0;
    final FixedExtentScrollController scrollController =
        FixedExtentScrollController(initialItem: selectedIndex);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: 260.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF1FFF6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.r),
                  topRight: Radius.circular(10.r),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 22.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 36.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFFC9C9C9),
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.cancel_outlined,
                              color: const Color(0xFF6D7071),
                              size: 24.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: ListWheelScrollView.useDelegate(
                      controller: scrollController,
                      itemExtent: 45.h,
                      perspective: 0.005,
                      diameterRatio: 1.5,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (index) {
                        setModalState(() {
                          selectedIndex = index;
                        });
                        setState(() {
                          _age = index + 13;
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          final int ageValue = index + 13;
                          final bool isSelected = index == selectedIndex;
                          return Center(
                            child: Text(
                              ageValue.toString(),
                              style: GoogleFonts.leagueSpartan(
                                fontSize: isSelected ? 33.4.sp : 26.7.sp,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.black
                                    : const Color(0xFFCECECE),
                                height: 1.0,
                              ),
                            ),
                          );
                        },
                        childCount: 86,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() => _activeField = '');
    });
  }
  void _showRulerBottomSheet({
    required String unit,
    required int minValue,
    required int maxValue,
    required int initialValue,
    required Function(int) onChanged,
    int majorTickOffset = 0,
  }) {
    int selectedValue = initialValue;
    final double tickWidth = 10.w;
    final ScrollController scrollController = ScrollController(
      initialScrollOffset: (initialValue - minValue) * tickWidth,
    );
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: 260.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF1FFF6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.r),
                  topRight: Radius.circular(10.r),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 22.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 36.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFFC9C9C9),
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.cancel_outlined,
                              color: const Color(0xFF6D7071),
                              size: 24.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    '$selectedValue $unit',
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 33.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification notification) {
                            if (notification is ScrollUpdateNotification) {
                              int newValue = minValue +
                                  (scrollController.offset / tickWidth).round();
                              if (newValue < minValue) newValue = minValue;
                              if (newValue > maxValue) newValue = maxValue;
                              if (newValue != selectedValue) {
                                setModalState(() {
                                  selectedValue = newValue;
                                });
                                onChanged(newValue);
                              }
                            }
                            return true;
                          },
                          child: ListView.builder(
                            controller: scrollController,
                            scrollDirection: Axis.horizontal,
                            physics: const ClampingScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width / 2 -
                                      tickWidth / 2,
                            ),
                            itemCount: maxValue - minValue + 1,
                            itemBuilder: (context, index) {
                              final int value = minValue + index;
                              final bool isMajor = (value + majorTickOffset) % 10 == 0;
                              final bool isMedium = value % 5 == 0 && !isMajor;
                              return SizedBox(
                                width: tickWidth,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 1.w,
                                      height: isMajor
                                          ? 35.h
                                          : (isMedium ? 25.h : 20.h),
                                      color: const Color(0xFFCECECE),
                                    ),
                                    SizedBox(height: 8.h),
                                    if (isMajor)
                                      SizedBox(
                                        height: 30.h,
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Positioned(
                                              left: -30.w,
                                              right: -30.w,
                                              top: 0,
                                              bottom: 0,
                                              child: Center(
                                                child: Text(
                                                  value.toString(),
                                                  style: GoogleFonts.leagueSpartan(
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color(0xFFCECECE),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          width: 2.w,
                          height: 51.h,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() => _activeField = '');
    });
  }
  void _showVerticalRulerBottomSheet({
    required String unit,
    required int minValue,
    required int maxValue,
    required int initialValue,
    required Function(int) onChanged,
  }) {
    int selectedValue = initialValue;
    final double tickHeight = 10.h;
    final ScrollController scrollController = ScrollController(
      initialScrollOffset: (initialValue - minValue) * tickHeight,
    );
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: 260.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF1FFF6),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.r),
                  topRight: Radius.circular(10.r),
                ),
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 22.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 36.w,
                              height: 5.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFFC9C9C9),
                                borderRadius: BorderRadius.circular(100.r),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Icon(
                                  Icons.cancel_outlined,
                                  color: const Color(0xFF6D7071),
                                  size: 24.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 60.w,
                    top: 130.h - 16.5.sp,
                    child: Text(
                      '$selectedValue $unit',
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 33.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 60.w,
                    top: 50.h,
                    bottom: 20.h,
                    width: 120.w,
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification notification) {
                            if (notification is ScrollUpdateNotification) {
                              int newValue = minValue +
                                  (scrollController.offset / tickHeight).round();
                              if (newValue < minValue) newValue = minValue;
                              if (newValue > maxValue) newValue = maxValue;
                              if (newValue != selectedValue) {
                                setModalState(() {
                                  selectedValue = newValue;
                                });
                                onChanged(newValue);
                              }
                            }
                            return true;
                          },
                          child: ListView.builder(
                            controller: scrollController,
                            scrollDirection: Axis.vertical,
                            physics: const ClampingScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                              vertical: ((260.h - 50.h - 20.h) / 2) -
                                  (tickHeight / 2),
                            ),
                            itemCount: maxValue - minValue + 1,
                            itemBuilder: (context, index) {
                              final int value = minValue + index;
                              final bool isMajor = value % 10 == 0;
                              final bool isMedium = value % 5 == 0 && !isMajor;
                              return SizedBox(
                                height: tickHeight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (isMajor)
                                      Container(
                                        margin: EdgeInsets.only(right: 15.w),
                                        width: 50.w,
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Positioned(
                                              left: 0,
                                              right: 0,
                                              top: -25.h,
                                              bottom: -25.h,
                                              child: Align(
                                                alignment: Alignment.centerRight,
                                                child: Text(
                                                  value.toString(),
                                                  style: GoogleFonts.leagueSpartan(
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color(0xFFCECECE),
                                                    height: 1.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    Container(
                                      height: 1.h,
                                      width: isMajor
                                          ? 36.w
                                          : (isMedium ? 28.w : 20.w),
                                      color: const Color(0xFFCECECE),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          height: 2.h,
                          width: 45.w,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() => _activeField = '');
    });
  }
}
