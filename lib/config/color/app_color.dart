// ignore_for_file: overridden_fields, non_constant_identifier_names, library_private_types_in_public_api, unused_field, constant_identifier_names

/*
 * @Author: Km Muzahid
 * @Date: 2026-01-07 14:20:59
 * @Email: km.muzahid@gmail.com
 */
import 'package:flutter/material.dart';

extension AppColorsX on BuildContext {
  ThemeColor get colors => Theme.of(this).extension<ThemeColor>()!;
}

@immutable
class ThemeColor extends ThemeExtension<ThemeColor> {
  const ThemeColor({
    required this.background,
    required this.bACKGROUND_card,
    required this.bACKGROUND_clickableBorder,
    required this.bACKGROUND_darkCard,
    required this.bACKGROUND_darkCardBoarder,
    required this.bACKGROUND_darkPage,
    required this.bACKGROUND_page,
    required this.border_divider,
    required this.iconBorder,
    required this.lightYellow,
    required this.pRIMARY_brandClr,
    required this.pRIMARY_priLight,
    required this.pRIMARY_priMedium,
    required this.pRIMARY_priSoft,
    required this.ratingPremiumTags_goldAccent,
    required this.sTATUS_error,
    required this.sTATUS_info,
    required this.sTATUS_success,
    required this.sTATUS_warning,
    required this.socialLinksShareBTN_skyBlue,
    required this.successVerifiedPositivestats_freshGrass,
    required this.tEXT_dark,
    required this.tEXT_sub,
    required this.tEXT_subDark,
    required this.tEXT_white,
    required this.navActiveColor,
  });

  final Color background;
  final Color bACKGROUND_card;
  final Color bACKGROUND_clickableBorder;
  final Color bACKGROUND_darkCard;
  final Color bACKGROUND_darkCardBoarder;
  final Color bACKGROUND_darkPage;
  final Color bACKGROUND_page;
  final Color border_divider;
  final Color iconBorder;
  final Color lightYellow;
  final Color pRIMARY_brandClr;
  final Color pRIMARY_priLight;
  final Color pRIMARY_priMedium;
  final Color pRIMARY_priSoft;
  final Color ratingPremiumTags_goldAccent;
  final Color sTATUS_error;
  final Color sTATUS_info;
  final Color sTATUS_success;
  final Color sTATUS_warning;
  final Color socialLinksShareBTN_skyBlue;
  final Color successVerifiedPositivestats_freshGrass;
  final Color tEXT_dark;
  final Color tEXT_sub;
  final Color tEXT_subDark;
  final Color tEXT_white;
  final Color navActiveColor;

  // ── Dark ──────────────────────────────────────────────────────────────────
  static const ThemeColor dark = ThemeColor(
    background: Color.fromARGB(255, 10, 39, 26), 
    // background: Color(0xFF0C2E1E), 
    bACKGROUND_card: Color(0xFFFEFBE8),
    bACKGROUND_clickableBorder: Color(0xFF789086),
    bACKGROUND_darkCard: Color(0xFF052217),
    bACKGROUND_darkCardBoarder: Color(0xFF1A3129),
    bACKGROUND_darkPage: Color(0xFF061512),
    bACKGROUND_page: Color.fromARGB(255, 55, 92, 74),
    border_divider: Color(0xFFE5E7EB),
    iconBorder: Color(0xFF0C2E1E),
    lightYellow: Color(0xFFFFF4CC),
    pRIMARY_brandClr: Color(0xFF184F3A),
    pRIMARY_priLight: Color(0xFF2F6F57),
    pRIMARY_priMedium: Color(0xFF184F3A),
    pRIMARY_priSoft: Color(0xFF6FAE97),
    ratingPremiumTags_goldAccent: Color(0xFFC8A951),
    sTATUS_error: Color(0xFFD14343),
    sTATUS_info: Color(0xFF2F80ED),
    sTATUS_success: Color(0xFF2E7D32),
    sTATUS_warning: Color(0xFFF4B400),
    socialLinksShareBTN_skyBlue: Color(0xFF3A7CA5),
    successVerifiedPositivestats_freshGrass: Color(0xFF4CAF50),
    tEXT_dark: Color(0xFF1F2933),
    tEXT_sub: Color(0xFF6B7280),
    tEXT_subDark: Color(0xFFB2CBC1),
    tEXT_white: Color(0xFFFFFFFF),
    navActiveColor: Color(0xFFFFFFFF),
  );

  // ── Light ─────────────────────────────────────────────────────────────────
  static const ThemeColor light = ThemeColor(
    background: Color(0xFFFFFFFF),
    bACKGROUND_card: Color(0xFFFFFFFF),
    bACKGROUND_clickableBorder: Color.fromARGB(255, 196, 205, 216),
    bACKGROUND_darkCard: Color(0xFFF8FAF9),
    bACKGROUND_darkCardBoarder: Color(0xFFE2E8F0),
    bACKGROUND_darkPage: Color(0xFFE5E7EB), // grey.shade200
    bACKGROUND_page: Color(0xFFFFFFFF),
    border_divider: Color(0xFFE5E7EB),
    iconBorder: Color(0xFF4B5563),
    lightYellow: Color.fromARGB(255, 255, 208, 0),
    pRIMARY_brandClr: Color(0xFF184F3A),
    pRIMARY_priLight: Color(0xFFF9FAFB), // grey.shade50
    pRIMARY_priMedium: Color(0xFFD1D5DB), // grey.shade300
    pRIMARY_priSoft: Color(0xFF6FAE97),
    ratingPremiumTags_goldAccent: Color(0xFFC8A951),
    sTATUS_error: Color(0xFFE05A5A),
    sTATUS_info: Color(0xFF2F80ED),
    sTATUS_success: Color(0xFF2E7D32),
    sTATUS_warning: Color(0xFFF6B93B),
    socialLinksShareBTN_skyBlue: Color(0xFF3A7CA5),
    successVerifiedPositivestats_freshGrass: Color(0xFF4CAF50),
    tEXT_dark: Color(0xFF1F2937),
    tEXT_sub: Color(0xFF4B5563),
    tEXT_subDark: Color(0xFF6B7280),
    tEXT_white: Color(0xFF1F2937),
    navActiveColor: Color(0xFF184F3A),
  );

  @override
  ThemeColor copyWith({
    Color? background_theme,
    Color? bACKGROUND_card,
    Color? bACKGROUND_clickableBorder,
    Color? bACKGROUND_darkCard,
    Color? bACKGROUND_darkCardBoarder,
    Color? bACKGROUND_darkPage,
    Color? bACKGROUND_page,
    Color? border_divider,
    Color? iconBorder,
    Color? lightYellow,
    Color? pRIMARY_brandClr,
    Color? pRIMARY_priLight,
    Color? pRIMARY_priMedium,
    Color? pRIMARY_priSoft,
    Color? ratingPremiumTags_goldAccent,
    Color? sTATUS_error,
    Color? sTATUS_info,
    Color? sTATUS_success,
    Color? sTATUS_warning,
    Color? socialLinksShareBTN_skyBlue,
    Color? successVerifiedPositivestats_freshGrass,
    Color? tEXT_dark,
    Color? tEXT_sub,
    Color? tEXT_subDark,
    Color? tEXT_white,
    Color? navActiveColor,
  }) {
    return ThemeColor(
      background: background_theme ?? background,
      bACKGROUND_card: bACKGROUND_card ?? this.bACKGROUND_card,
      bACKGROUND_clickableBorder: bACKGROUND_clickableBorder ?? this.bACKGROUND_clickableBorder,
      bACKGROUND_darkCard: bACKGROUND_darkCard ?? this.bACKGROUND_darkCard,
      bACKGROUND_darkCardBoarder: bACKGROUND_darkCardBoarder ?? this.bACKGROUND_darkCardBoarder,
      bACKGROUND_darkPage: bACKGROUND_darkPage ?? this.bACKGROUND_darkPage,
      bACKGROUND_page: bACKGROUND_page ?? this.bACKGROUND_page,
      border_divider: border_divider ?? this.border_divider,
      iconBorder: iconBorder ?? this.iconBorder,
      lightYellow: lightYellow ?? this.lightYellow,
      pRIMARY_brandClr: pRIMARY_brandClr ?? this.pRIMARY_brandClr,
      pRIMARY_priLight: pRIMARY_priLight ?? this.pRIMARY_priLight,
      pRIMARY_priMedium: pRIMARY_priMedium ?? this.pRIMARY_priMedium,
      pRIMARY_priSoft: pRIMARY_priSoft ?? this.pRIMARY_priSoft,
      ratingPremiumTags_goldAccent:
          ratingPremiumTags_goldAccent ?? this.ratingPremiumTags_goldAccent,
      sTATUS_error: sTATUS_error ?? this.sTATUS_error,
      sTATUS_info: sTATUS_info ?? this.sTATUS_info,
      sTATUS_success: sTATUS_success ?? this.sTATUS_success,
      sTATUS_warning: sTATUS_warning ?? this.sTATUS_warning,
      socialLinksShareBTN_skyBlue: socialLinksShareBTN_skyBlue ?? this.socialLinksShareBTN_skyBlue,
      successVerifiedPositivestats_freshGrass:
          successVerifiedPositivestats_freshGrass ?? this.successVerifiedPositivestats_freshGrass,
      tEXT_dark: tEXT_dark ?? this.tEXT_dark,
      tEXT_sub: tEXT_sub ?? this.tEXT_sub,
      tEXT_subDark: tEXT_subDark ?? this.tEXT_subDark,
      tEXT_white: tEXT_white ?? this.tEXT_white,
      navActiveColor: navActiveColor ?? this.navActiveColor,
    );
  }

  @override
  ThemeColor lerp(ThemeColor? other, double t) {
    if (other is! ThemeColor) return this;
    return ThemeColor(
      background: Color.lerp(background, other.background, t)!,
      bACKGROUND_card: Color.lerp(bACKGROUND_card, other.bACKGROUND_card, t)!,
      bACKGROUND_clickableBorder: Color.lerp(
        bACKGROUND_clickableBorder,
        other.bACKGROUND_clickableBorder,
        t,
      )!,
      bACKGROUND_darkCard: Color.lerp(bACKGROUND_darkCard, other.bACKGROUND_darkCard, t)!,
      bACKGROUND_darkCardBoarder: Color.lerp(
        bACKGROUND_darkCardBoarder,
        other.bACKGROUND_darkCardBoarder,
        t,
      )!,
      bACKGROUND_darkPage: Color.lerp(bACKGROUND_darkPage, other.bACKGROUND_darkPage, t)!,
      bACKGROUND_page: Color.lerp(bACKGROUND_page, other.bACKGROUND_page, t)!,
      border_divider: Color.lerp(border_divider, other.border_divider, t)!,
      iconBorder: Color.lerp(iconBorder, other.iconBorder, t)!,
      lightYellow: Color.lerp(lightYellow, other.lightYellow, t)!,
      pRIMARY_brandClr: Color.lerp(pRIMARY_brandClr, other.pRIMARY_brandClr, t)!,
      pRIMARY_priLight: Color.lerp(pRIMARY_priLight, other.pRIMARY_priLight, t)!,
      pRIMARY_priMedium: Color.lerp(pRIMARY_priMedium, other.pRIMARY_priMedium, t)!,
      pRIMARY_priSoft: Color.lerp(pRIMARY_priSoft, other.pRIMARY_priSoft, t)!,
      ratingPremiumTags_goldAccent: Color.lerp(
        ratingPremiumTags_goldAccent,
        other.ratingPremiumTags_goldAccent,
        t,
      )!,
      sTATUS_error: Color.lerp(sTATUS_error, other.sTATUS_error, t)!,
      sTATUS_info: Color.lerp(sTATUS_info, other.sTATUS_info, t)!,
      sTATUS_success: Color.lerp(sTATUS_success, other.sTATUS_success, t)!,
      sTATUS_warning: Color.lerp(sTATUS_warning, other.sTATUS_warning, t)!,
      socialLinksShareBTN_skyBlue: Color.lerp(
        socialLinksShareBTN_skyBlue,
        other.socialLinksShareBTN_skyBlue,
        t,
      )!,
      successVerifiedPositivestats_freshGrass: Color.lerp(
        successVerifiedPositivestats_freshGrass,
        other.successVerifiedPositivestats_freshGrass,
        t,
      )!,
      tEXT_dark: Color.lerp(tEXT_dark, other.tEXT_dark, t)!,
      tEXT_sub: Color.lerp(tEXT_sub, other.tEXT_sub, t)!,
      tEXT_subDark: Color.lerp(tEXT_subDark, other.tEXT_subDark, t)!,
      tEXT_white: Color.lerp(tEXT_white, other.tEXT_white, t)!,
      navActiveColor: Color.lerp(navActiveColor, other.navActiveColor, t)!,
    );
  }
}
 
