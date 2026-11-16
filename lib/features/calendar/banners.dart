import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:invoice_desk/app/providers.dart';
import 'package:invoice_desk/features/calendar/calendar_controller.dart';
import 'package:invoice_desk/l10n/l10n.dart';
import 'package:invoice_desk/theme/app_theme.dart';

/// Dismissed-today state of the "today" banner, remembered per day.
class TodayBannerNotifier extends Notifier<bool> {
  @override
  bool build() =>
      ref.read(uiPrefsProvider).todayBannerDismissed ==
      ref.watch(todayProvider).toIso();

  void dismiss() {
    state = true;
    ref.read(uiPrefsProvider).todayBannerDismissed = ref
        .read(todayProvider)
        .toIso();
  }
}

final todayBannerDismissedProvider =
    NotifierProvider<TodayBannerNotifier, bool>(TodayBannerNotifier.new);

class ProfileBannerNotifier extends Notifier<bool> {
  @override
  bool build() => ref.read(uiPrefsProvider).profileBannerDismissed;

  void dismiss() {
    state = true;
    ref.read(uiPrefsProvider).profileBannerDismissed = true;
  }
}

final profileBannerDismissedProvider =
    NotifierProvider<ProfileBannerNotifier, bool>(ProfileBannerNotifier.new);

/// The non-blocking strip above the workspace: "اليوم: 2 مستحق · 1 متأخر —
/// عرض في التقويم" when anything is due today or overdue (dismissable for
/// the day), and "أكمل بياناتك" while the profile is empty.
class TopBanners extends ConsumerWidget {
  const TopBanners({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final counts = ref.watch(todayCountsProvider);
    final todayGone = ref.watch(todayBannerDismissedProvider);
    final settings = ref.watch(settingsProvider).value;
    final profileGone = ref.watch(profileBannerDismissedProvider);
    final showToday =
        !todayGone && counts != null && (counts.due + counts.overdue) > 0;
    final showProfile =
        !profileGone && settings != null && !settings.hasProfile;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showProfile)
          _Banner(
            key: const Key('profile-banner'),
            icon: Icons.badge_outlined,
            text: '${l.profileBanner} — ${l.profileBannerBody}',
            action: l.openSettings,
            onAction: () {
              ref.read(calendarModeProvider.notifier).set(false);
              ref.read(workspaceProvider.notifier).show(Workspace.settings);
            },
            onDismiss: ref
                .read(profileBannerDismissedProvider.notifier)
                .dismiss,
          ),
        if (showToday)
          _Banner(
            key: const Key('today-banner'),
            icon: Icons.today_outlined,
            text: l.todayBanner(counts.due, counts.overdue),
            action: l.showInCalendar,
            onAction: () {
              ref.read(calendarModeProvider.notifier).set(true);
              ref.read(calendarProvider.notifier).goToday();
              ref.read(calendarProvider.notifier).openPanel();
            },
            onDismiss: ref.read(todayBannerDismissedProvider.notifier).dismiss,
          ),
      ],
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    required this.icon,
    required this.text,
    required this.action,
    required this.onAction,
    required this.onDismiss,
    super.key,
  });
  final IconData icon;
  final String text;
  final String action;
  final VoidCallback onAction;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: context.colors.subtle,
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: context.colors.border)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: Space.m),
        height: 40,
        child: Row(
          children: [
            Icon(icon, size: 18, color: theme.colorScheme.primary),
            const SizedBox(width: Space.s),
            Expanded(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            TextButton(onPressed: onAction, child: Text(action)),
            IconButton(
              tooltip: context.l10n.dismiss,
              iconSize: 18,
              icon: const Icon(Icons.close),
              onPressed: onDismiss,
            ),
          ],
        ),
      ),
    );
  }
}

/// Once per launch, when the setting is on and something is due today or
/// overdue: a desktop notification (skipped silently without a notifier).
class StartupNotification extends ConsumerStatefulWidget {
  const StartupNotification({super.key});

  @override
  ConsumerState<StartupNotification> createState() =>
      _StartupNotificationState();
}

class _StartupNotificationState extends ConsumerState<StartupNotification> {
  var _sent = false;

  @override
  Widget build(BuildContext context) {
    final counts = ref.watch(todayCountsProvider);
    if (!_sent && counts != null) {
      _sent = true;
      if (ref.read(notifyOnStartProvider) && counts.due + counts.overdue > 0) {
        final l = context.l10n;
        ref
            .read(desktopNotifierProvider)
            .show(l.appTitle, l.todayBanner(counts.due, counts.overdue))
            .ignore();
      }
    }
    return const SizedBox.shrink();
  }
}
