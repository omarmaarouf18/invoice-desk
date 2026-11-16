import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/locale.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/app/shell.dart';
import 'package:invoice_desk/features/actions.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';

export 'package:invoice_desk/app/locale.dart' show appLocale;

class InvoiceDeskApp extends ConsumerWidget {
  const InvoiceDeskApp({super.key, this.home = const Shell()});

  final Widget home;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Invoice Desk',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: messengerKey,
      locale: ref.watch(localeProvider),
      supportedLocales: appSupportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      themeMode: ref.watch(themeModeProvider),
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeAnimationDuration: Space.motion,
      home: home,
    );
  }
}
