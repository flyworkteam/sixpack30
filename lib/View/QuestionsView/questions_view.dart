import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:six_pack_30/Core/Network/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:six_pack_30/Riverpod/Controllers/user_provider.dart';
import 'package:six_pack_30/Core/Localization/translations.dart';
import 'package:six_pack_30/Riverpod/Controllers/locale_provider.dart';

class QuestionsView extends ConsumerStatefulWidget {
  const QuestionsView({super.key});
  @override
  ConsumerState<QuestionsView> createState() => _QuestionsViewState();
}

enum QuestionFlow { hedefOdak, vucut, vucudunuzuBilin }

class _QuestionsViewState extends ConsumerState<QuestionsView> {
  String get langCode => ref.watch(localeProvider).languageCode;
  int _currentStep = 1;
  bool _isLoading = false;
  bool _isFinalLoading = false;
  bool _isReadyScreen = false;
  bool _isProgressScreen = false;
  double _progressPercent = 0.0;
  PageController? _bgPageController;
  Timer? _bgTimer;
  QuestionFlow _currentFlow = QuestionFlow.hedefOdak;
  int? _selectedGender;
  int? _selectedGoal;
  bool _isCm = true;
  bool _isKg = true;
  double _bodyTypeIndex = 0.0;
  double _targetBodyTypeIndex = 0.0;
  int _selectedYear = 2000;
  int _selectedHeight = 164;
  double _selectedWeight = 61.5;
  double _targetWeight = 51.5;
  int? _selectedSpeed;
  int? _selectedExperience;
  int? _selectedTrainingType;
  int _selectedActivity = 2;
  final Set<int> _selectedDays = {};
  int? _selectedDuration;
 
   @override
   void initState() {
     super.initState();
     _bgPageController = PageController();
   }

  @override
  void dispose() {
    _bgPageController?.dispose();
    _bgTimer?.cancel();
    super.dispose();
  }

  Future<void> _saveProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final token = await user.getIdToken();
      if (token != null) {
        final data = {
          'gender': _selectedGender == 1 ? 'man' : 'woman',
          'goal': _selectedGoal == 0 ? 'Göbek Eritme' : 'Karın Kası Yapma',
          'height': _selectedHeight,
          'weight': _selectedWeight,
          'targetWeight': _targetWeight,
          'birthYear': _selectedYear,
          'bodyType': _bodyTypeIndex,
          'targetBodyType': _targetBodyTypeIndex,
          'speed': _selectedSpeed,
          'experience': _selectedExperience,
          'trainingType': _selectedTrainingType,
          'activityLevel': _selectedActivity,
          'trainingDays': _selectedDays.toList().join(','),
          'trainingDuration': _selectedDuration,
        };
        await ApiService().updateProfile(token, data);
        if (mounted) {
          ref.read(userProfileProvider.notifier).fetchProfile();
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    if (_isProgressScreen) {
      return Scaffold(body: _buildProgressLoadingScreen());
    }
    if (_isReadyScreen) {
      return Scaffold(body: _buildReadyScreen());
    }
    if (_isFinalLoading) {
      return Scaffold(body: _buildFinalLoadingScreen());
    }
    if (_isLoading) {
      return Scaffold(body: _buildLoadingScreen());
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentStep > 1) {
          setState(() => _currentStep--);
        } else if (_currentFlow == QuestionFlow.vucudunuzuBilin) {
          setState(() {
            _currentFlow = QuestionFlow.vucut;
            _currentStep = 4;
          });
        } else if (_currentFlow == QuestionFlow.vucut) {
          setState(() {
            _currentFlow = QuestionFlow.hedefOdak;
            _currentStep = 4;
          });
        }
      },
      child: Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12.h),
                    _buildHeader(context),
                    SizedBox(height: 12.h),
                    _buildProgressSection(),
                    SizedBox(height: 45.h),
                    if (_currentFlow == QuestionFlow.hedefOdak)
                      _buildHedefOdakContent()
                    else if (_currentFlow == QuestionFlow.vucut)
                      _buildVucutContent()
                    else
                      _buildVBContent(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
              child: _buildNextButton(),
            ),
          ],
        ),
      ),
    ),);
  }

  Widget _buildHedefOdakContent() {
    if (_currentStep == 1) return _buildStep1();
    if (_currentStep == 2) return _buildStep2();
    String prefix = (_selectedGender == 1) ? 'man' : 'woman';
    if (_currentStep == 3 || _currentStep == 4) {
      double indexValue = (_currentStep == 3) ? _bodyTypeIndex : _targetBodyTypeIndex;
      int imgNum = indexValue.round() + 1;
      String currentTitle = (_currentStep == 3) ? 'Vücut tipiniz nedir?' : 'İstediğiniz vücut tipi nedir?';
      
      double ox = 0;
      double oy = 25.h;
      double ih = 320;

      if (prefix == 'man') {
        if (imgNum == 1) {
          ox = -8.w;
          oy = 20.h;
          ih = 510;
        } else if (imgNum == 2) {
          ox = -4.w;
          oy = 20.h;
          ih = 510;
        } else if (imgNum == 3) {
          ox = -4.w;
          oy = 20.h;
          ih = 510;
        } else if (imgNum == 4) {
          ox = 0;
          oy = 15.h;
          ih = 490;
        } else if (imgNum == 5) {
          ox = 0;
          oy = 15.h;
          ih = 490;
        } else if (imgNum == 6) {
          ox = 0;
          oy = 10.h;
          ih = 470;
        }
      } else if (prefix == 'woman') {
        if (imgNum == 1) {
          ox = -4.w;
          oy = 20.h;
          ih = 420;
        } else if (imgNum == 2) {
          oy = 15.h;
          ih = 400;
        } else if (imgNum == 3) {
          oy = 10.h;
          ih = 520;
        } else if (imgNum == 4) {
          oy = 10.h;
          ih = 400;
        } else if (imgNum == 5) {
          ox = 4.w;
          oy = 5.h;
          ih = 380;
        } else if (imgNum == 6) {
          oy = 0.h;
          ih = 360;
        }
      }

      String resPath = 'https://sixpack30.b-cdn.net/images/$prefix$imgNum.svg';

      return _buildBodyTypeStep(
        title: currentTitle,
        imagePath: resPath,
        indexValue: indexValue,
        onChanged: (val) => setState(() {
          if (_currentStep == 3) _bodyTypeIndex = val;
          else _targetBodyTypeIndex = val;
        }),
        imageWidth: null,
        imageHeight: ih,
        offsetX: ox,
        offsetY: oy,
      );
    }
    return const SizedBox();
  }

  Widget _buildVucutContent() {
    if (_currentStep == 1) return _buildVucutStep1();
    if (_currentStep == 2) return _buildVucutStep2();
    if (_currentStep == 3) return _buildVucutStep3();
    if (_currentStep == 4) return _buildVucutStep4();
    return const SizedBox();
  }

  Widget _buildVucutStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hedef kilonuz nedir?',
          style: GoogleFonts.montserrat(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            height: 22 / 18,
          ),
        ),
        SizedBox(height: 28.h),
        Center(
          child: PopupMenuButton<bool>(
            onSelected: (bool value) {
              setState(() {
                _isKg = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: true, child: Text(Translations.translate('unit_kg', langCode))),
              PopupMenuItem(value: false, child: Text(Translations.translate('unit_lbs', langCode))),
            ],
            child: Container(
              width: 90.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: const Color(0xFF00EF5B),
                border: Border.all(color: Colors.white, width: 1.w),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isKg ? 'kg' : 'lbs',
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 16.w,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 45.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                Icon(
                  Icons.arrow_left,
                  color: const Color(0xFF373434),
                  size: 16.w,
                ),
                Text(
                  _isKg
                      ? '${_selectedWeight.toStringAsFixed(1)} kg'
                      : '${_kgToLbs(_selectedWeight).toStringAsFixed(1)} lbs',
                  style: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFB1B1B1),
                  ),
                ),
              ],
            ),
            SizedBox(width: 40.w),
          ],
        ),
        Center(
          child: Text(
            _isKg
                ? '${_targetWeight.toStringAsFixed(1)} kg'
                : '${_kgToLbs(_targetWeight).toStringAsFixed(1)} lbs',
            style: GoogleFonts.montserrat(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: 32.h),
        SizedBox(
          height: 150.h,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              RotatedBox(
                quarterTurns: -1,
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 10.w,
                  perspective: 0.00001,
                  diameterRatio: 10.0,
                  overAndUnderCenterOpacity: 1.0,
                  clipBehavior: Clip.none,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      if (_isKg) {
                        _targetWeight = 30.0 + (index * 0.1);
                      } else {
                        double totalLbs = 66.0 + (index * 0.1);
                        _targetWeight = _lbsToKg(totalLbs);
                      }
                    });
                  },
                  controller: FixedExtentScrollController(
                    initialItem: _isKg
                        ? ((_targetWeight - 30.0) / 0.1).round().clamp(0, 1200)
                        : ((_kgToLbs(_targetWeight) - 66.0) / 0.1).round().clamp(0, 2640),
                  ),
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      double val = _isKg ? 30.0 + (index * 0.1) : 66.0 + (index * 0.1);
                      bool isWholeNumber = (val * 10).round() % 10 == 0;
                      return RotatedBox(
                        quarterTurns: 1,
                        child: SizedBox(
                          width: 40.w,
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.topCenter,
                            children: [
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  width: 1.3.w,
                                  height: isWholeNumber ? 41.62.h : 31.21.h,
                                  color: const Color(
                                    0xFFB1B1B1,
                                  ).withValues(alpha: isWholeNumber ? 1.0 : 0.73),
                                ),
                              ),
                              if (isWholeNumber)
                                Positioned(
                                  bottom: 45.h,
                                  child: Text(
                                    val.toInt().toString(),
                                    softWrap: false,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFFB1B1B1),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: _isKg ? 1201 : 2641,
                  ),
                ),
              ),
              Positioned(
                top: 26.h,
                child: Container(
                  width: 2.w,
                  height: 127.h,
                  color: const Color(0xFF00EF5B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVucutStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Doğum yılınız Nedir?',
          style: GoogleFonts.montserrat(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            height: 22 / 18,
          ),
        ),
        SizedBox(height: 100.h),
        Center(
          child: SizedBox(
            height: 250.h,
            width: 150.w,
            child: ListWheelScrollView.useDelegate(
              itemExtent: 70.h,
              perspective: 0.00001,
              diameterRatio: 10.0,
              overAndUnderCenterOpacity: 1.0,
              onSelectedItemChanged: (index) {
                setState(() {
                  _selectedYear = 1950 + index;
                });
              },
              physics: const FixedExtentScrollPhysics(),
              controller: FixedExtentScrollController(
                initialItem: _selectedYear - 1950,
              ),
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  int year = 1950 + index;
                  bool isSelected = year == _selectedYear;
                  return Center(
                    child: Text(
                      '$year',
                      style: GoogleFonts.montserrat(
                        fontSize: 40.sp,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w300,
                        color: isSelected
                            ? Colors.black
                            : const Color(0xFFAAAAAA),
                      ),
                    ),
                  );
                },
                childCount: 81,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVucutStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Boyunuz nedir?',
          style: GoogleFonts.montserrat(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            height: 22 / 18,
          ),
        ),
        SizedBox(height: 28.h),
        PopupMenuButton<bool>(
          onSelected: (bool value) {
            setState(() {
              _isCm = value;
            });
          },
          itemBuilder: (context) => [
            PopupMenuItem(value: true, child: Text(Translations.translate('unit_cm', langCode))),
            PopupMenuItem(value: false, child: Text(Translations.translate('unit_ft', langCode))),
          ],
          child: Container(
            width: 90.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: const Color(0xFF00EF5B),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isCm ? 'cm' : 'ft',
                  style: GoogleFonts.leagueSpartan(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 5.w),
                Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16.w),
              ],
            ),
          ),
        ),
        SizedBox(height: 40.h),
        SizedBox(
          height: 350.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 160.w,
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 12.h,
                      perspective: 0.00001,
                      diameterRatio: 10.0,
                      overAndUnderCenterOpacity: 1.0,
                      clipBehavior: Clip.none,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          if (_isCm) {
                            _selectedHeight = 220 - index;
                          } else {
                            int totalInches = 95 - index;
                            _selectedHeight = _feetInchesToCm(totalInches);
                          }
                        });
                      },
                      controller: FixedExtentScrollController(
                        initialItem: _isCm
                            ? (220 - _selectedHeight).clamp(0, 100)
                            : (95 - (_selectedHeight / 2.54).round()).clamp(0, 47),
                      ),
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          if (_isCm) {
                            int hValue = 220 - index;
                            bool isMajor = hValue % 10 == 0;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (isMajor)
                                  Text(
                                    '$hValue',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFFB1B1B1),
                                      height: 1.0,
                                    ),
                                  ),
                                SizedBox(width: 10.w),
                                Container(
                                  width: hValue == _selectedHeight
                                      ? 41.w
                                      : (isMajor ? 41.w : 31.w),
                                  height: 1.3.h,
                                  color: const Color(0xFFD5D5D5),
                                ),
                              ],
                            );
                          } else {
                            int totalInches = 95 - index;
                            bool isMajor = totalInches % 12 == 0;
                            String ftText = _cmToFeetInches(_feetInchesToCm(totalInches));
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (isMajor)
                                  Text(
                                    ftText,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFFB1B1B1),
                                      height: 1.0,
                                    ),
                                  ),
                                SizedBox(width: 10.w),
                                Container(
                                  width: totalInches == (_selectedHeight / 2.54).round()
                                      ? 41.w
                                      : (isMajor ? 41.w : 31.w),
                                  height: 1.3.h,
                                  color: const Color(0xFFD5D5D5),
                                ),
                              ],
                            );
                          }
                        },
                        childCount: _isCm ? 101 : 48,
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                child: IgnorePointer(
                  child: SizedBox(
                    width: 342.w,
                    child: Row(
                      children: [
                        SizedBox(width: 24.w),
                        Text(
                          _isCm
                              ? '$_selectedHeight cm'
                              : _cmToFeetInches(_selectedHeight),
                          style: GoogleFonts.montserrat(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            height: 1.4,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 212.w,
                          height: 2.h,
                          color: const Color(0xFF00EF5B),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVucutStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mevcut kilonuz nedir?',
          style: GoogleFonts.montserrat(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            height: 22 / 18,
          ),
        ),
        SizedBox(height: 28.h),
        Center(
          child: PopupMenuButton<bool>(
            onSelected: (bool value) {
              setState(() {
                _isKg = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: true, child: Text(Translations.translate('unit_kg', langCode))),
              PopupMenuItem(value: false, child: Text(Translations.translate('unit_lbs', langCode))),
            ],
            child: Container(
              width: 90.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: const Color(0xFF00EF5B),
                border: Border.all(color: Colors.white, width: 1.w),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isKg ? 'kg' : 'lbs',
                    style: GoogleFonts.leagueSpartan(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 16.w,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 45.h),
        Center(
          child: Text(
            _isKg
                ? '${_selectedWeight.toStringAsFixed(1)} kg'
                : '${_kgToLbs(_selectedWeight).toStringAsFixed(1)} lbs',
            style: GoogleFonts.montserrat(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: 32.h),
        SizedBox(
          height: 150.h,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              RotatedBox(
                quarterTurns: -1,
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 10.w,
                  perspective: 0.00001,
                  diameterRatio: 10.0,
                  overAndUnderCenterOpacity: 1.0,
                  clipBehavior: Clip.none,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      if (_isKg) {
                        _selectedWeight = 40.0 + (index * 0.1);
                      } else {
                        double totalLbs = 88.0 + (index * 0.1);
                        _selectedWeight = _lbsToKg(totalLbs);
                      }
                    });
                  },
                  controller: FixedExtentScrollController(
                    initialItem: _isKg
                        ? ((_selectedWeight - 40.0) / 0.1).round().clamp(0, 1100)
                        : ((_kgToLbs(_selectedWeight) - 88.0) / 0.1).round().clamp(0, 2420),
                  ),
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      double val = _isKg ? 40.0 + (index * 0.1) : 88.0 + (index * 0.1);
                      bool isWholeNumber = (val * 10).round() % 10 == 0;
                      return RotatedBox(
                        quarterTurns: 1,
                        child: SizedBox(
                          width: 40.w,
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.topCenter,
                            children: [
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  width: 1.3.w,
                                  height: isWholeNumber ? 41.62.h : 31.21.h,
                                  color: const Color(
                                    0xFFB1B1B1,
                                  ).withValues(alpha: isWholeNumber ? 1.0 : 0.73),
                                ),
                              ),
                              if (isWholeNumber)
                                Positioned(
                                  bottom: 45.h,
                                  child: Text(
                                    val.toInt().toString(),
                                    softWrap: false,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFFB1B1B1),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: _isKg ? 1101 : 2421,
                  ),
                ),
              ),
              Positioned(
                top: 26.h,
                child: Container(
                  width: 2.w,
                  height: 127.h,
                  color: const Color(0xFF00EF5B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    String title = 'Hedef & Odak';
    if (_currentFlow == QuestionFlow.vucut) title = 'Vücut';
    if (_currentFlow == QuestionFlow.vucudunuzuBilin)
      title = 'Vücüdunuzu Bilin';
    return SizedBox(
      width: 342.w,
      height: 24.h,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: GestureDetector(
              onTap: () {
                if (_currentStep > 1) {
                  setState(() => _currentStep--);
                } else if (_currentFlow == QuestionFlow.vucudunuzuBilin) {
                  setState(() {
                    _currentFlow = QuestionFlow.vucut;
                    _currentStep = 4;
                  });
                } else if (_currentFlow == QuestionFlow.vucut) {
                  setState(() {
                    _currentFlow = QuestionFlow.hedefOdak;
                    _currentStep = 4;
                  });
                } else {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                }
              },
              child: Container(
                width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDEDED).withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: CachedNetworkImage(imageUrl: 'https://sixpack30.b-cdn.net/images/geriicon.png',
                  width: 12.w,
                  height: 12.h,
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF100F0F),
                height: 24 / 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    final bool isVB = _currentFlow == QuestionFlow.vucudunuzuBilin;
    int totalSteps = isVB ? 6 : 4;
    final List<double> widths = isVB
        ? [46, 50, 50, 50, 50, 50]
        : [80, 80, 80, 80];
    final double gap = isVB ? 9 : 7.5;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 342.w,
          child: Text(
            '$_currentStep/$totalSteps',
            textAlign: TextAlign.right,
            style: GoogleFonts.montserrat(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              height: 17 / 14,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: List.generate(totalSteps, (index) {
            return Row(
              children: [
                _buildProgressSegment(
                  isActive: index < _currentStep,
                  width: widths[index],
                ),
                if (index < totalSteps - 1) SizedBox(width: gap.w),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cinsiyetiniz nedir?',
          style: GoogleFonts.montserrat(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            height: 22 / 18,
          ),
        ),
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => setState(() {
                _selectedGender = 0;
                _bodyTypeIndex = 0.0;
                _targetBodyTypeIndex = 0.0;
              }),
              child: _buildGenderCard(
                imagePath: 'https://sixpack30.b-cdn.net/images/genderWOMAN.png',
                label: 'Kadın',
                isSelected: _selectedGender == 0,
              ),
            ),
            SizedBox(width: 12.w),
            GestureDetector(
              onTap: () => setState(() {
                _selectedGender = 1;
                _bodyTypeIndex = 0.0;
                _targetBodyTypeIndex = 0.0;
              }),
              child: _buildGenderCard(
                imagePath: 'https://sixpack30.b-cdn.net/images/genderMAN.png',
                label: Translations.translate('gender_man', langCode),
                isSelected: _selectedGender == 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        GestureDetector(
          onTap: () => setState(() => _selectedGender = 2),
          child: Container(
            width: double.infinity,
            height: 44.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: _selectedGender == 2
                    ? const Color(0xFF00EF5B)
                    : const Color(0xFFEBEBEB),
                width: 2.w,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.network('https://sixpack30.b-cdn.net/images/iconstack.io - (Value None).svg',
                  width: 18.w,
                  height: 18.h,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 9.w),
                Text(
                  'Belirtmek İstemiyorum',
                  style: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    height: 17 / 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ana hedefiniz nedir?',
          style: GoogleFonts.montserrat(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            height: 22 / 18,
          ),
        ),
        SizedBox(height: 20.h),
        _buildGoalCard(
          imagePath: 'https://sixpack30.b-cdn.net/images/gobekeritme.png',
          label: 'Göbek Eritme',
          isSelected: _selectedGoal == 0,
          onTap: () => setState(() => _selectedGoal = 0),
        ),
        SizedBox(height: 20.h),
        _buildGoalCard(
          imagePath: 'https://sixpack30.b-cdn.net/images/karinkasi.png',
          label: 'Karın Kası Yapma',
          isSelected: _selectedGoal == 1,
          onTap: () => setState(() => _selectedGoal = 1),
        ),
      ],
    );
  }

  Widget _buildBodyTypeStep({
    required String title,
    required String imagePath,
    required double indexValue,
    required Function(double) onChanged,
    required double? imageWidth,
    required double? imageHeight,
    double offsetX = 0.0,
    double offsetY = 0.0,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            height: 22 / 18,
          ),
        ),
        SizedBox(height: 35.h),
        Center(
          child: SizedBox(
            width: 320.w,
            height: 320.h,
            child: Center(
              child: Transform.rotate(
                angle: -45 * (3.14159 / 180),
                child: Container(
                  width: 147.27.w,
                  height: 147.27.h,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(14.73.r),
                  ),
                  child: OverflowBox(
                    minWidth: 0,
                    maxWidth: 1000,
                    minHeight: 0,
                    maxHeight: 1000,
                    child: Transform.rotate(
                      angle: 45 * (3.14159 / 180),
                      child: Transform.translate(
                        offset: Offset(offsetX, offsetY),
                        child: imagePath.endsWith('.svg')
                            ? SvgPicture.network(
                                imagePath,
                                width: imageWidth != null ? imageWidth.w : null,
                                height: imageHeight != null
                                    ? imageHeight.h
                                    : null,
                                fit: BoxFit.contain,
                              )
                            : CachedNetworkImage(
                                imageUrl: imagePath,
                                width: imageWidth != null ? imageWidth.w : null,
                                height: imageHeight != null
                                    ? imageHeight.h
                                    : null,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 35.h),
        Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                double trackWidth = 342.w;
                double horizontalPadding = 16.w;
                double interactiveWidth = trackWidth - (horizontalPadding * 2);
                void updateSliderValue(double localX) {
                  double relX = (localX - horizontalPadding).clamp(
                    0,
                    interactiveWidth,
                  );
                  double newValue = (relX / interactiveWidth) * 5;
                  onChanged(newValue.roundToDouble());
                }

                return GestureDetector(
                  onHorizontalDragUpdate: (details) =>
                      updateSliderValue(details.localPosition.dx),
                  onTapDown: (details) =>
                      updateSliderValue(details.localPosition.dx),
                  child: Container(
                    width: trackWidth,
                    height: 28.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCDFFE0),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(6, (index) {
                              return Container(
                                width: 8.w,
                                height: 8.h,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF8FFFBA),
                                  shape: BoxShape.circle,
                                ),
                              );
                            }),
                          ),
                        ),
                        Positioned(
                          left:
                              (indexValue / 5) * interactiveWidth +
                              horizontalPadding -
                              12.w,
                          child: Container(
                            width: 24.w,
                            height: 24.h,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF00EF5B,
                              ).withValues(alpha: 0.49),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF39DB77),
                                width: 2.5.w,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 7.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Biçimli',
                    style: GoogleFonts.montserrat(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Ekstra',
                    style: GoogleFonts.montserrat(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGoalCard({
    required String imagePath,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 343.w,
        height: 85.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF00EF5B)
                : const Color(0xFFEBEBEB),
            width: 2.w,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                bottomLeft: Radius.circular(10.r),
              ),
              child: CachedNetworkImage(
                imageUrl: imagePath,
                width: 104.w,
                height: 85.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 15.w),
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF100F0F),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    bool canProceed = false;
    if (_currentFlow == QuestionFlow.hedefOdak) {
      if (_currentStep == 1)
        canProceed = _selectedGender != null;
      else if (_currentStep == 2)
        canProceed = _selectedGoal != null;
      else
        canProceed = true;
    } else {
      canProceed = true;
    }
    return GestureDetector(
        onTap: () {
          if (!canProceed) return;
          setState(() {
            if (_currentFlow == QuestionFlow.hedefOdak) {
              if (_currentStep < 4) {
                _currentStep++;
              } else {
                _isLoading = true;
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                      _currentFlow = QuestionFlow.vucut;
                      _currentStep = 1;
                    });
                  }
                });
              }
            } else if (_currentFlow == QuestionFlow.vucut) {
              if (_currentStep < 4) {
                _currentStep++;
              } else {
                _isFinalLoading = true;
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) {
                    setState(() {
                      _isFinalLoading = false;
                      _currentFlow = QuestionFlow.vucudunuzuBilin;
                      _currentStep = 1;
                    });
                  }
                });
              }
            } else if (_currentFlow == QuestionFlow.vucudunuzuBilin) {
              if (_currentStep < 6) {
                _currentStep++;
              } else {
                _isReadyScreen = true;
              }
            }
          });
        },
        child: Opacity(
          opacity: canProceed ? 1.0 : 0.5,
          child: Container(
            width: 342.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: const Color(0xFF00EF5B),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sonraki',
                  style: GoogleFonts.montserrat(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0A0A0A),
                    height: 20 / 16,
                    letterSpacing: -0.176.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                SvgPicture.network('https://sixpack30.b-cdn.net/images/iconstack.io - (Arrow Down).svg',
                  width: 18.w,
                  height: 18.h,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ),
      );
  }

  Widget _buildLoadingScreen() {
    return Stack(
      children: [
        Positioned.fill(
          child: CachedNetworkImage(imageUrl: 'https://sixpack30.b-cdn.net/images/Sorular.png', fit: BoxFit.cover),
        ),
        Positioned.fill(
          child: Container(color: Colors.black.withValues(alpha: 0.66)),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Vücüt',
                style: GoogleFonts.montserrat(
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 49 / 40,
                ),
              ),
              SizedBox(height: 11.h),
              SizedBox(
                width: 250.w,
                height: 110.h,
                child: Stack(
                  children: [
                    _buildPolygon(
                      6,
                      left: 196,
                      top: 22,
                      w: 68,
                      h: 50,
                      color: const Color(0xFF22FE75).withValues(alpha: 0.1),
                    ),
                    _buildPolygon(
                      5,
                      left: 159,
                      top: 16,
                      w: 80,
                      h: 60,
                      color: const Color(0xFF56FF96).withValues(alpha: 0.3),
                    ),
                    _buildPolygon(
                      4,
                      left: 119,
                      top: 9,
                      w: 88,
                      h: 65,
                      color: const Color(0xFF59FB96).withValues(alpha: 0.4),
                    ),
                    _buildPolygon(
                      3,
                      left: 80,
                      top: 9,
                      w: 93,
                      h: 70,
                      color: const Color(0xFF49FF8D).withValues(alpha: 0.6),
                    ),
                    _buildPolygon(
                      2,
                      left: 43,
                      top: 7,
                      w: 92,
                      h: 68,
                      color: const Color(0xFF65FF9F).withValues(alpha: 0.8),
                    ),
                    _buildPolygon(
                      1,
                      left: 0,
                      top: 0,
                      w: 106,
                      h: 80,
                      color: const Color(0xFF82FFB1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _startProgressAnimation() {
    _progressPercent = 0.0;
    _bgTimer?.cancel();
    _bgTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_bgPageController != null && _bgPageController!.hasClients) {
        int nextPage = (_bgPageController!.page?.round() ?? 0) + 1;
        _bgPageController!.animateToPage(
          nextPage % 2,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 50));
      if (!mounted) {
        _bgTimer?.cancel();
        return false;
      }
      setState(() {
        _progressPercent += 0.01;
      });
      if (_progressPercent >= 1.0) {
        setState(() {
          _progressPercent = 1.0;
        });
        _bgTimer?.cancel();
        _bgPageController?.animateToPage(
          1,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
        return false;
      }
      return true;
    });
  }

  Widget _buildProgressLoadingScreen() {
    final int percent = (_progressPercent * 100).clamp(0, 100).round();
    final bool isComplete = percent >= 100;

    return Stack(
      fit: StackFit.expand,
      children: [
        IgnorePointer(
          child: PageView.builder(
            physics: const ClampingScrollPhysics(),
            controller: _bgPageController,
            itemBuilder: (context, index) {
              final String asset = (index % 2 == 0)
                  ? 'https://sixpack30.b-cdn.net/images/loading_bg.png'
                  : 'https://sixpack30.b-cdn.net/images/loading_complete_bg.png';
              return CachedNetworkImage(
                imageUrl: asset,
                fit: BoxFit.cover,
                alignment: asset.contains('complete')
                    ? const Alignment(0.1, 0.0)
                    : Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              );
            },
          ),
        ),
        Container(color: Colors.black.withValues(alpha: 0.35)),

        Positioned(
          left: 24.w,
          top: 616.h,
          child: SizedBox(
            width: 303.w,
            child: Text(
              isComplete
                  ? 'Planın Hazır!\nBaşlamaya\nSabırsızlanıyoruz'
                  : 'Hedefine Göre\nUyarlanmış İçerikler\nHazırlanıyor',
              style: GoogleFonts.montserrat(
                fontSize: 28.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 34 / 28,
              ),
            ),
          ),
        ),
        Positioned(
          left: 24.w,
          right: 24.w,
          top: 756.h,
          child: GestureDetector(
            onTap: isComplete
                ? () async {
                    await _saveProfileData();
                    if (mounted) {
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  }
                : null,
            child: Container(
              width: 342.w,
              height: 44.h,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: const Color(0xFFD4D4D4).withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double fullWidth = constraints.maxWidth;
                  final double currentBarWidth = fullWidth * _progressPercent;

                  return Stack(
                    children: [
                      Container(
                        width: currentBarWidth,
                        height: 44.h,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00EF5B),
                        ),
                      ),
                      Center(
                        child: Text(
                          isComplete ? 'Başlayın' : 'Hazırlanıyor...',
                          style: GoogleFonts.montserrat(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: isComplete
                                ? const Color(0xFF0A0A0A)
                                : Colors.white,
                            height: 20 / 16,
                            letterSpacing: -0.176.sp,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 12.w,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: Text(
                            '%$percent',
                            style: GoogleFonts.montserrat(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.154.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReadyScreen() {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(imageUrl: 'https://sixpack30.b-cdn.net/images/ready_bg.png',
          fit: BoxFit.cover,
          alignment: Alignment(0.25, 0.0),
        ),
        Container(color: Colors.black.withValues(alpha: 0.26)),
        Positioned(
          left: 24.w,
          top: 564.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kendinin En İyi\nVersiyonu Olmaya',
                style: GoogleFonts.montserrat(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 34 / 28,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Hazır Mısın?',
                style: GoogleFonts.montserrat(
                  fontSize: 48.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF06C44F),
                  height: 42 / 48,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 24.w,
          right: 24.w,
          top: 756.h,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isReadyScreen = false;
                _isProgressScreen = true;
                _progressPercent = 0.0;
              });
              _startProgressAnimation();
            },
            child: Container(
              width: 342.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: const Color(0xFF00EF5B),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Evet Hazırım',
                    style: GoogleFonts.montserrat(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0A0A0A),
                      height: 20 / 16,
                      letterSpacing: -0.176.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  SvgPicture.network('https://sixpack30.b-cdn.net/images/iconstack.io - (Arrow Down).svg',
                    width: 18.w,
                    height: 18.h,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFinalLoadingScreen() {
    return Stack(
      children: [
        Positioned.fill(
          child: CachedNetworkImage(imageUrl: 'https://sixpack30.b-cdn.net/images/sportswoman.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(color: Colors.black.withValues(alpha: 0.66)),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Vücüdunuzu\nBilin',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 49 / 40,
                ),
              ),
              SizedBox(height: 11.h),
              SizedBox(
                width: 280.w,
                height: 110.h,
                child: Stack(
                  children: [
                    _buildImgPolygon(
                      6,
                      left: 211.59,
                      top: 22.45,
                      w: 68.46,
                      h: 54.41,
                    ),
                    _buildImgPolygon(
                      5,
                      left: 171.69,
                      top: 16.83,
                      w: 79.69,
                      h: 64.08,
                    ),
                    _buildImgPolygon(
                      4,
                      left: 128.17,
                      top: 8.98,
                      w: 87.54,
                      h: 70.13,
                    ),
                    _buildImgPolygon(
                      3,
                      left: 85.84,
                      top: 8.98,
                      w: 93.15,
                      h: 74.96,
                    ),
                    _buildImgPolygon(
                      2,
                      left: 45.94,
                      top: 6.73,
                      w: 92.03,
                      h: 73.75,
                    ),
                    _buildImgPolygon(1, left: 0, top: 0, w: 106, h: 85.65),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImgPolygon(
    int num, {
    required double left,
    required double top,
    required double w,
    required double h,
  }) {
    return Positioned(
      left: left.w,
      top: top.h,
      child: CachedNetworkImage(imageUrl: 'https://sixpack30.b-cdn.net/images/Polygon$num.png',
        width: w.w,
        height: h.h,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _buildPolygon(
    int order, {
    required double left,
    required double top,
    required double w,
    required double h,
    required Color color,
  }) {
    return Positioned(
      left: left.w,
      top: top.h,
      child: CustomPaint(
        size: Size(w.w, h.h),
        painter: _TrianglePainter(color),
      ),
    );
  }

  Widget _buildProgressSegment({required bool isActive, double width = 80}) {
    return Container(
      width: width.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF00EF5B) : const Color(0xFFD7D7D7),
        borderRadius: BorderRadius.circular(5.r),
      ),
    );
  }

  Widget _buildVBContent() {
    if (_currentStep == 1) return _buildVBStep1();
    if (_currentStep == 2) return _buildVBStep2();
    if (_currentStep == 3) return _buildVBStep3();
    if (_currentStep == 4) return _buildVBStep4();
    if (_currentStep == 5) return _buildVBStep5();
    if (_currentStep == 6) return _buildVBStep6();
    return const SizedBox();
  }

  Widget _buildVBStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hedefinize ne kadar hızlı ulaşmak istiyorsunuz?',
          style: GoogleFonts.montserrat(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            height: 22 / 18,
          ),
        ),
        SizedBox(height: 20.h),
        _buildSelectionTile(
          index: 0,
          label: 'Hemen Şimdi',
          iconPath: 'https://sixpack30.b-cdn.net/images/iconstack.io - (Fast Arrow Up).svg',
          isSelected: _selectedSpeed == 0,
          onTap: () => setState(() => _selectedSpeed = 0),
        ),
        SizedBox(height: 10.h),
        _buildSelectionTile(
          index: 1,
          label: 'Çok Hızlı',
          iconPath: 'https://sixpack30.b-cdn.net/images/Forecast Lightning.svg',
          isSelected: _selectedSpeed == 1,
          onTap: () => setState(() => _selectedSpeed = 1),
        ),
        SizedBox(height: 10.h),
        _buildSelectionTile(
          index: 2,
          label: 'Hızlı & Dengeli',
          iconPath: 'https://sixpack30.b-cdn.net/images/iconstack.io - (Clock Fast).svg',
          isSelected: _selectedSpeed == 2,
          onTap: () => setState(() => _selectedSpeed = 2),
        ),
        SizedBox(height: 10.h),
        _buildSelectionTile(
          index: 3,
          label: Translations.translate('time_long_term', langCode),
          iconPath: 'https://sixpack30.b-cdn.net/images/iconstack.io - (Health Shield).svg',
          isSelected: _selectedSpeed == 3,
          onTap: () => setState(() => _selectedSpeed = 3),
        ),
      ],
    );
  }

  Widget _buildVBStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kas yapma ile son deneyimin nasıldı?',
          style: GoogleFonts.montserrat(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            height: 22 / 18,
          ),
        ),
        SizedBox(height: 20.h),
        _buildSelectionTile(
          index: 0,
          label: 'Hiç denemedim',
          iconPath: 'https://sixpack30.b-cdn.net/images/Experience_Never.svg',
          isSelected: _selectedExperience == 0,
          onTap: () => setState(() => _selectedExperience = 0),
        ),
        SizedBox(height: 10.h),
        _buildSelectionTile(
          index: 1,
          label: 'Denedim ama olmadı',
          iconPath: 'https://sixpack30.b-cdn.net/images/Experience_Failed.svg',
          isSelected: _selectedExperience == 1,
          onTap: () => setState(() => _selectedExperience = 1),
        ),
        SizedBox(height: 10.h),
        _buildSelectionTile(
          index: 2,
          label: 'Başardım ama tekrar aldım',
          iconPath: 'https://sixpack30.b-cdn.net/images/Experience_Regained.svg',
          isSelected: _selectedExperience == 2,
          onTap: () => setState(() => _selectedExperience = 2),
        ),
        SizedBox(height: 10.h),
        _buildSelectionTile(
          index: 3,
          label: Translations.translate('exp_still_trying', langCode),
          iconPath: 'https://sixpack30.b-cdn.net/images/Experience_Trying.svg',
          isSelected: _selectedExperience == 3,
          onTap: () => setState(() => _selectedExperience = 3),
        ),
        SizedBox(height: 10.h),
        _buildSelectionTile(
          index: 4,
          label: 'Başardım ve daha iyisini istiyorum',
          iconPath: 'https://sixpack30.b-cdn.net/images/Experience_Success.svg',
          isSelected: _selectedExperience == 4,
          onTap: () => setState(() => _selectedExperience = 4),
        ),
      ],
    );
  }

  Widget _buildVBStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tercih ettiğiniz antrenman tipi?',
          style: GoogleFonts.montserrat(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            height: 22 / 18,
          ),
        ),
        SizedBox(height: 20.h),
        _buildSelectionTile(
          index: 0,
          label: 'Başlaması Kolay',
          iconPath: 'https://sixpack30.b-cdn.net/images/Training_Easy.svg',
          isSelected: _selectedTrainingType == 0,
          onTap: () => setState(() => _selectedTrainingType = 0),
        ),
        SizedBox(height: 10.h),
        _buildSelectionTile(
          index: 1,
          label: Translations.translate('intensity_sweaty', langCode),
          iconPath: 'https://sixpack30.b-cdn.net/images/Training_Sweaty.svg',
          isSelected: _selectedTrainingType == 1,
          onTap: () => setState(() => _selectedTrainingType = 1),
        ),
        SizedBox(height: 10.h),
        _buildSelectionTile(
          index: 2,
          label: Translations.translate('intensity_hardcore', langCode),
          iconPath: 'https://sixpack30.b-cdn.net/images/Training_Tough.svg',
          isSelected: _selectedTrainingType == 2,
          onTap: () => setState(() => _selectedTrainingType = 2),
        ),
      ],
    );
  }

  Widget _buildVBStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aktivite düzeyiniz nedir?',
          style: GoogleFonts.montserrat(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            height: 22 / 18,
          ),
        ),
        SizedBox(height: 60.h),
        Center(
          child: Transform.rotate(
            angle: -0.785398,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30.r),
              child: Container(
                width: 242.w,
                height: 242.h,
                color: const Color(0xFFF3F3F3),
                child: Transform.rotate(
                  angle: 0.785398,
                  child: OverflowBox(
                    maxWidth: (_selectedActivity == 2) ? 380.w : 342.w,
                    maxHeight: (_selectedActivity == 2) ? 380.h : 342.h,
                    alignment: Alignment.center,
                    child: Transform.translate(
                      offset: (_selectedActivity >= 2)
                          ? Offset(-15.w, 15.h)
                          : Offset.zero,
                      child: CachedNetworkImage(imageUrl: 'https://sixpack30.b-cdn.net/images/${(_selectedGender == 1) ? 'actman' : 'actwoman'}${_selectedActivity + 1}.png',
                        width: (_selectedActivity == 2) ? 380.w : 342.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 60.h),
        _buildActivitySlider(),
        SizedBox(height: 149.h),
      ],
    );
  }

  Widget _buildVBStep5() {
    final days = [
      {
        'label': Translations.translate('monday', langCode),
        'icon': 'https://sixpack30.b-cdn.net/images/Day_Mon.svg',
      },
      {
        'label': 'Salı',
        'icon': 'https://sixpack30.b-cdn.net/images/Day_Tue.svg',
      },
      {
        'label': 'Çarşamba',
        'icon': 'https://sixpack30.b-cdn.net/images/Day_Wed.svg',
      },
      {
        'label': 'Perşembe',
        'icon': 'https://sixpack30.b-cdn.net/images/Day_Thu.svg',
      },
      {
        'label': Translations.translate('friday', langCode),
        'icon': 'https://sixpack30.b-cdn.net/images/Day_Fri.svg',
      },
      {
        'label': Translations.translate('saturday', langCode),
        'icon': 'https://sixpack30.b-cdn.net/images/Day_Sat_Final.svg',
      },
      {
        'label': Translations.translate('sunday', langCode),
        'icon': 'https://sixpack30.b-cdn.net/images/Day_Sun.svg',
      },
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Haftanın hangi günleri antrenman yaparsınız?',
          style: GoogleFonts.montserrat(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            height: 22 / 18,
          ),
        ),
        SizedBox(height: 20.h),
        ...List.generate(days.length, (index) {
          final bool isSelected = _selectedDays.contains(index);
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < days.length - 1 ? 10.h : 0,
            ),
            child: GestureDetector(
              onTap: () => setState(() {
                if (isSelected) {
                  _selectedDays.remove(index);
                } else {
                  _selectedDays.add(index);
                }
              }),
              child: Container(
                width: 342.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF06C44F)
                        : const Color(0xFFEBEBEB),
                    width: 1.w,
                  ),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Row(
                    children: [
                      if (days[index]['icon']!.endsWith('.svg'))
                        SvgPicture.network(
                          days[index]['icon']!,
                          width: 24.w,
                          height: 24.h,
                          colorFilter: isSelected
                              ? const ColorFilter.mode(
                                  Color(0xFF06C44F), BlendMode.srcIn)
                              : null,
                        )
                      else
                        CachedNetworkImage(
                          imageUrl: days[index]['icon']!,
                          width: 24.w,
                          height: 24.h,
                          color: isSelected ? const Color(0xFF06C44F) : null,
                        ),
                      SizedBox(width: 5.w),
                      Text(
                        days[index]['label']!,
                        style: GoogleFonts.montserrat(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF100F0F),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  String _cmToFeetInches(int cm) {
    double inches = cm / 2.54;
    int feet = (inches / 12).floor();
    int remainingInches = (inches % 12).round();
    if (remainingInches == 12) {
      feet++;
      remainingInches = 0;
    }
    return "$feet'$remainingInches\"";
  }

  int _feetInchesToCm(int totalInches) {
    return (totalInches * 2.54).round();
  }

  double _kgToLbs(double kg) {
    return kg * 2.20462;
  }

  double _lbsToKg(double lbs) {
    return lbs / 2.20462;
  }

  Widget _buildVBStep6() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Antrenman süren ne kadar?',
          style: GoogleFonts.montserrat(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            height: 22 / 18,
          ),
        ),
        SizedBox(height: 20.h),
        _buildSelectionTile(
          index: 0,
          label: '10 - 20 ',
          iconPath: 'https://sixpack30.b-cdn.net/images/Duration_1_Final.svg',
          isSelected: _selectedDuration == 0,
          onTap: () => setState(() => _selectedDuration = 0),
        ),
        SizedBox(height: 10.h),
        _buildSelectionTile(
          index: 1,
          label: '25 - 30 ',
          iconPath: 'https://sixpack30.b-cdn.net/images/Duration_2.svg',
          isSelected: _selectedDuration == 1,
          onTap: () => setState(() => _selectedDuration = 1),
        ),
        SizedBox(height: 10.h),
        _buildSelectionTile(
          index: 2,
          label: '40 - 45 ',
          iconPath: 'https://sixpack30.b-cdn.net/images/Duration_3.svg',
          isSelected: _selectedDuration == 2,
          onTap: () => setState(() => _selectedDuration = 2),
        ),
        SizedBox(height: 10.h),
        _buildSelectionTile(
          index: 3,
          label: '60+ ',
          iconPath: 'https://sixpack30.b-cdn.net/images/Duration_4.svg',
          isSelected: _selectedDuration == 3,
          onTap: () => setState(() => _selectedDuration = 3),
        ),
      ],
    );
  }

  void _updateActivityFromX(double x) {
    const centers = [14.0, 118.67, 223.33, 328.0];
    int closest = 0;
    double minDist = double.infinity;
    for (int i = 0; i < centers.length; i++) {
      final dist = (x - centers[i]).abs();
      if (dist < minDist) {
        minDist = dist;
        closest = i;
      }
    }
    setState(() => _selectedActivity = closest);
  }

  Widget _buildActivitySlider() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) {
            _updateActivityFromX(details.localPosition.dx);
          },
          onPanStart: (details) {
            _updateActivityFromX(details.localPosition.dx);
          },
          onPanUpdate: (details) {
            _updateActivityFromX(details.localPosition.dx);
          },
          child: Container(
            width: 342.w,
            height: 28.h,
            decoration: BoxDecoration(
              color: const Color(0xFFCDFFE0),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: List.generate(4, (i) {
                final bool isSelected = _selectedActivity == i;
                final double center = 14.0 + i * 104.67;
                final double size = isSelected ? 24.0 : 8.0;
                return Positioned(
                  left: (center - size / 2).w,
                  top: (14.0 - size / 2).h,
                  child: Container(
                    width: size.w,
                    height: size.h,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF00EF5B).withValues(alpha: 0.49)
                          : const Color(0xFF8FFFBA),
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(
                              color: const Color(0xFF39DB77),
                              width: 2.5.w,
                            )
                          : null,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        SizedBox(height: 7.h),
        SizedBox(
          width: 331.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Translations.translate('sedentary', langCode),
                style: GoogleFonts.montserrat(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 15 / 12,
                ),
              ),
              Text(
                Translations.translate('active', langCode),
                style: GoogleFonts.montserrat(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  height: 15 / 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionTile({
    required int index,
    required String label,
    required String iconPath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 342.w,
        height: 44.h,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: isSelected
                ? const Color(0xFF06C44F)
                : const Color(0xFFEBEBEB),
            width: 1.w,
          ),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            children: [
              if (iconPath.endsWith('.svg'))
                SvgPicture.network(
                  iconPath,
                  width: 24.w,
                  height: 24.h,
                  colorFilter: isSelected
                      ? const ColorFilter.mode(Color(0xFF06C44F), BlendMode.srcIn)
                      : null,
                )
              else
                CachedNetworkImage(
                  imageUrl: iconPath,
                  width: 24.w,
                  height: 24.h,
                  color: isSelected ? const Color(0xFF06C44F) : null,
                ),
              SizedBox(width: 5.w),
              Text(
                label,
                style: GoogleFonts.montserrat(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF100F0F),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderCard({
    required String imagePath,
    required String label,
    required bool isSelected,
  }) {
    return Container(
      width: 165.w,
      height: 195.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: isSelected ? const Color(0xFF00EF5B) : Colors.transparent,
          width: 2.w,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.r),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: imagePath.contains('genderMAN') ? 1.7 : 1.0,
              child: Transform.translate(
                offset: imagePath.contains('genderMAN')
                    ? Offset(3.5.w, 38.h)
                    : Offset.zero,
                child: CachedNetworkImage(
                  imageUrl: imagePath,
                  fit: BoxFit.cover,
                  width: 165.w,
                  height: 195.h,
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Color.fromRGBO(96, 96, 96, 0.2)],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 40.h,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.5),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 6.h,
              left: 0,
              right: 0,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 15 / 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
