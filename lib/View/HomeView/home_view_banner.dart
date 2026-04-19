  Widget _buildPremiumBanner() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PaywallView()),
          );
        },
        child: Container(
          width: 342.w,
          height: 124.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            gradient: const LinearGradient(
              begin: Alignment(0.0, -1.0),
              end: Alignment(0.0, 1.0),
              colors: [Color(0xFF20C729), Color(0xFF063527)],
              stops: [-0.0645, 1.1124],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 4.h),
                            child: SvgPicture.asset(
                              'assets/images/Premium_Upgrade_Icon.svg',
                              width: 32.w,
                              height: 32.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Premium’ a Geç',
                            style: GoogleFonts.montserrat(
                              fontSize: 16.67.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: -0.11.sp,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Padding(
                        padding: EdgeInsets.only(left: 40.w),
                        child: Text(
                          'Tüm gelişmiş özelliklerin kilidini aç.',
                          style: GoogleFonts.montserrat(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: -0.11.sp,
                            height: 1.25,
                          ),
                        ),
                      ),
                      SizedBox(height: 13.h),
                      Padding(
                        padding: EdgeInsets.only(left: 40.w),
                        child: Container(
                          width: 217.w,
                          height: 44.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF20C729), Color(0xFF063527)],
                            ).createShader(bounds),
                            blendMode: BlendMode.srcIn,
                            child: Text(
                              'Planı Yükselt',
                              style: GoogleFonts.montserrat(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.11.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
