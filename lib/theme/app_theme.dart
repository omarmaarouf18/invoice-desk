import 'package:flutter/material.dart';
import 'package:invoice_desk/domain/models.dart';

const fontFamily = 'IBMPlexSansArabic';

/// Spacing grid (8 px) and shape tokens.
abstract final class Space {
  static const double xs = 4;
  static const double s = 8;
  static const double m = 16;
  static const double l = 24;
  static const double xl = 32;
  static const double radius = 12;
  static const double radiusSmall = 8;
  static const Duration motion = Duration(milliseconds: 150);
}

/// Colours that Material's scheme does not cover.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.border,
    required this.subtle,
    required this.muted,
    required this.statusFg,
    required this.statusBg,
    required this.highlight,
  });

  final Color border;

  /// Soft panel background (summary strip, table headers).
  final Color subtle;

  /// Secondary text.
  final Color muted;
  final Map<DisplayStatus, Color> statusFg;
  final Map<DisplayStatus, Color> statusBg;

  /// Search-match background.
  final Color highlight;

  static const light = AppColors(
    border: Color(0xFFDCE2EA),
    subtle: Color(0xFFF3F6F9),
    muted: Color(0xFF5B6878),
    highlight: Color(0xFFFFE8A3),
    statusFg: {
      DisplayStatus.draft: Color(0xFF4A5567),
      DisplayStatus.sent: Color(0xFF8A5300),
      DisplayStatus.overdue: Color(0xFFB42318),
      DisplayStatus.paid: Color(0xFF067647),
      DisplayStatus.voided: Color(0xFF6B7280),
    },
    statusBg: {
      DisplayStatus.draft: Color(0xFFEEF1F5),
      DisplayStatus.sent: Color(0xFFFFF4DB),
      DisplayStatus.overdue: Color(0xFFFEE4E2),
      DisplayStatus.paid: Color(0xFFDCFAE6),
      DisplayStatus.voided: Color(0xFFF1F2F4),
    },
  );

  static const dark = AppColors(
    border: Color(0xFF2A3647),
    subtle: Color(0xFF172131),
    muted: Color(0xFF98A4B5),
    highlight: Color(0xFF6B5310),
    statusFg: {
      DisplayStatus.draft: Color(0xFFC3CBD6),
      DisplayStatus.sent: Color(0xFFFFC967),
      DisplayStatus.overdue: Color(0xFFFF9C92),
      DisplayStatus.paid: Color(0xFF6CE0A4),
      DisplayStatus.voided: Color(0xFF9CA3AF),
    },
    statusBg: {
      DisplayStatus.draft: Color(0xFF243042),
      DisplayStatus.sent: Color(0xFF3D2E0D),
      DisplayStatus.overdue: Color(0xFF451A17),
      DisplayStatus.paid: Color(0xFF0F3A27),
      DisplayStatus.voided: Color(0xFF262B33),
    },
  );

  @override
  AppColors copyWith() => this;

  @override
  AppColors lerp(AppColors? other, double t) =>
      t < 0.5 ? this : (other ?? this);
}

extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}

const _ink = Color(0xFF0F1B2D);
const _teal = Color(0xFF0F766E);
const _tealDark = Color(0xFF2BB3A3);

const _tabular = [FontFeature.tabularFigures()];

TextTheme _textTheme(Color ink, Color muted) {
  TextStyle st(double size, FontWeight w, [Color? c]) => TextStyle(
    fontFamily: fontFamily,
    fontSize: size,
    fontWeight: w,
    height: 1.45,
    letterSpacing: 0,
    color: c ?? ink,
    fontFeatures: _tabular,
  );
  return TextTheme(
    displaySmall: st(28, FontWeight.w700),
    headlineSmall: st(22, FontWeight.w700),
    titleLarge: st(18, FontWeight.w700),
    titleMedium: st(15, FontWeight.w600),
    titleSmall: st(13, FontWeight.w600),
    bodyLarge: st(14, FontWeight.w400),
    bodyMedium: st(13, FontWeight.w400),
    bodySmall: st(12, FontWeight.w400, muted),
    labelLarge: st(13, FontWeight.w600),
    labelMedium: st(12, FontWeight.w600),
    labelSmall: st(11, FontWeight.w600, muted),
  );
}

ThemeData buildTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final colors = dark ? AppColors.dark : AppColors.light;
  final accent = dark ? _tealDark : _teal;
  final surface = dark ? const Color(0xFF111A27) : Colors.white;
  final background = dark ? const Color(0xFF0B121D) : const Color(0xFFF6F8FA);
  final ink = dark ? const Color(0xFFE6EBF1) : _ink;

  final scheme = ColorScheme(
    brightness: brightness,
    primary: accent,
    onPrimary: dark ? const Color(0xFF00201C) : Colors.white,
    primaryContainer: dark ? const Color(0xFF113F3A) : const Color(0xFFD6F1EE),
    onPrimaryContainer: dark
        ? const Color(0xFFBDEFE8)
        : const Color(0xFF053B37),
    secondaryContainer: dark
        ? const Color(0xFF113F3A)
        : const Color(0xFFD6F1EE),
    onSecondaryContainer: dark
        ? const Color(0xFFBDEFE8)
        : const Color(0xFF053B37),
    secondary: dark ? const Color(0xFF9FB3C8) : const Color(0xFF3B4C63),
    onSecondary: dark ? _ink : Colors.white,
    error: dark ? const Color(0xFFFF9C92) : const Color(0xFFB42318),
    onError: dark ? _ink : Colors.white,
    surface: surface,
    onSurface: ink,
    onSurfaceVariant: colors.muted,
    surfaceContainerLowest: background,
    surfaceContainerLow: background,
    surfaceContainer: colors.subtle,
    surfaceContainerHigh: colors.subtle,
    surfaceContainerHighest: colors.border,
    outline: colors.border,
    outlineVariant: colors.border,
    inverseSurface: dark ? const Color(0xFFE6EBF1) : _ink,
    onInverseSurface: dark ? _ink : Colors.white,
    inversePrimary: dark ? _teal : _tealDark,
  );

  final text = _textTheme(ink, colors.muted);
  final radius = BorderRadius.circular(Space.radiusSmall);
  final inputBorder = OutlineInputBorder(
    borderRadius: radius,
    borderSide: BorderSide(color: colors.border),
  );

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    fontFamily: fontFamily,
    textTheme: text,
    scaffoldBackgroundColor: background,
    canvasColor: surface,
    dividerColor: colors.border,
    visualDensity: VisualDensity.compact,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    splashFactory: NoSplash.splashFactory,
    extensions: [colors],
    dividerTheme: DividerThemeData(
      color: colors.border,
      thickness: 1,
      space: 1,
    ),
    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Space.radius),
        side: BorderSide(color: colors.border),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: surface,
      contentPadding: const EdgeInsetsDirectional.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      border: inputBorder,
      enabledBorder: inputBorder,
      focusedBorder: inputBorder.copyWith(
        borderSide: BorderSide(color: accent, width: 1.5),
      ),
      errorBorder: inputBorder.copyWith(
        borderSide: BorderSide(color: scheme.error),
      ),
      focusedErrorBorder: inputBorder.copyWith(
        borderSide: BorderSide(color: scheme.error, width: 1.5),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      suffixIconConstraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      labelStyle: text.bodyMedium?.copyWith(color: colors.muted),
      floatingLabelStyle: text.bodyMedium?.copyWith(color: accent),
      hintStyle: text.bodyMedium?.copyWith(color: colors.muted),
      errorStyle: text.bodySmall?.copyWith(color: scheme.error),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: text.bodyLarge,
      inputDecorationTheme: InputDecorationThemeData(
        isDense: true,
        constraints: const BoxConstraints(maxHeight: 40),
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsetsDirectional.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: accent, width: 1.5),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: scheme.error),
        ),
        labelStyle: text.bodyMedium?.copyWith(color: colors.muted),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 36,
          minHeight: 36,
        ),
        suffixIconConstraints: const BoxConstraints(
          minWidth: 36,
          minHeight: 36,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 40),
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: radius),
        textStyle: text.labelLarge,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 40),
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 14),
        shape: RoundedRectangleBorder(borderRadius: radius),
        side: BorderSide(color: colors.border),
        foregroundColor: ink,
        textStyle: text.labelLarge,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(0, 36),
        shape: RoundedRectangleBorder(borderRadius: radius),
        textStyle: text.labelLarge,
      ),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: radius),
        side: BorderSide(color: colors.border),
        textStyle: text.labelLarge,
        visualDensity: VisualDensity.compact,
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      side: BorderSide(color: colors.border),
      labelStyle: text.labelMedium,
      backgroundColor: surface,
      selectedColor: scheme.primaryContainer,
      showCheckmark: false,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
    ),
    tooltipTheme: TooltipThemeData(
      waitDuration: const Duration(milliseconds: 400),
      textStyle: text.bodySmall?.copyWith(color: scheme.onInverseSurface),
      decoration: BoxDecoration(
        color: scheme.inverseSurface,
        borderRadius: radius,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      width: 520,
      backgroundColor: scheme.inverseSurface,
      contentTextStyle: text.bodyMedium?.copyWith(
        color: scheme.onInverseSurface,
      ),
      actionTextColor: dark ? _teal : _tealDark,
      shape: RoundedRectangleBorder(borderRadius: radius),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Space.radius),
        side: BorderSide(color: colors.border),
      ),
      titleTextStyle: text.titleLarge,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: colors.border),
      ),
      textStyle: text.bodyMedium,
    ),
    menuTheme: MenuThemeData(
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(surface),
        elevation: const WidgetStatePropertyAll(2),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(color: colors.border),
          ),
        ),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (s) =>
            s.contains(WidgetState.selected) ? scheme.onPrimary : colors.muted,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? accent : colors.subtle,
      ),
      trackOutlineColor: WidgetStatePropertyAll(colors.border),
    ),
    scrollbarTheme: const ScrollbarThemeData(
      thickness: WidgetStatePropertyAll(6),
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.linux: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: FadeForwardsPageTransitionsBuilder(),
      },
    ),
  );
}
