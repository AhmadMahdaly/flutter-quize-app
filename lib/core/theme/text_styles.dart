import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smle/core/cache_helper/cache_helper.dart';


TextStyle interRegular =CacheHelper.getCurrentLanguage()=='en'?
GoogleFonts.inter(
  fontWeight: FontWeight.w400,
): GoogleFonts.lateef(
  fontWeight: FontWeight.w400,
);
TextStyle interRegularColor = CacheHelper.getCurrentLanguage()=='en'?
GoogleFonts.inter(
    fontWeight: FontWeight.w400,
    color: Colors.grey
): GoogleFonts.lateef(
    fontWeight: FontWeight.w400,
    color: Colors.grey
);
TextStyle interMedium = CacheHelper.getCurrentLanguage()=='en'?
GoogleFonts.inter(
  fontWeight: FontWeight.w500,
) :GoogleFonts.lateef(
 fontWeight: FontWeight.w500,
);
TextStyle interBold = CacheHelper.getCurrentLanguage()=='en'?
GoogleFonts.inter(
  fontWeight: FontWeight.w600,
) :GoogleFonts.lateef(
 fontWeight: FontWeight.w600,
);

TextStyle interExtraBold =CacheHelper.getCurrentLanguage()=='en'?
GoogleFonts.inter(
  fontWeight: FontWeight.w700,
):GoogleFonts.lateef(
  fontWeight: FontWeight.w700,
);

TextStyle interBlack =CacheHelper.getCurrentLanguage()=='en'?
GoogleFonts.rubik(
  fontWeight: FontWeight.w900,
): GoogleFonts.lateef(
  fontWeight: FontWeight.w900,
);