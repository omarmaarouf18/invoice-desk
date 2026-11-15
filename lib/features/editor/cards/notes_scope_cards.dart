part of '../editor_cards.dart';

class NotesCard extends ConsumerWidget {
  const NotesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final en = _watchInv(ref, (i) => i.notesEn);
    final ar = _watchInv(ref, (i) => i.notesAr);
    final ctl = _ctl(ref);
    return PanelCard(
      title: l.cardNotes,
      icon: Icons.notes_outlined,
      child: _Pair(
        SyncedTextField(
          label: l.notesEn,
          value: en,
          minLines: 4,
          maxLines: 10,
          textDirection: TextDirection.ltr,
          keyboardType: TextInputType.multiline,
          onChanged: (v) => ctl.edit((i) => i.copyWith(notesEn: v)),
        ),
        SyncedTextField(
          label: l.notesAr,
          value: ar,
          minLines: 4,
          maxLines: 10,
          textDirection: TextDirection.rtl,
          keyboardType: TextInputType.multiline,
          onChanged: (v) => ctl.edit((i) => i.copyWith(notesAr: v)),
        ),
      ),
    );
  }
}

class ScopeCard extends ConsumerWidget {
  const ScopeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final sc = _watchInv(ref, (i) => i.scope);
    final ctl = _ctl(ref);
    void set(ScopePage Function(ScopePage s) f) =>
        ctl.edit((i) => i.copyWith(scope: f(i.scope)));
    const gap = SizedBox(height: Space.m - 4);
    return PanelCard(
      title: l.cardScope,
      icon: Icons.assignment_outlined,
      trailing: Switch(
        value: sc.enabled,
        onChanged: (v) => set((s) => s.copyWith(enabled: v)),
      ),
      child: AnimatedSize(
        duration: motion(context),
        alignment: AlignmentDirectional.topStart,
        child: !sc.enabled
            ? Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  l.scopeToggle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              )
            : Column(
                children: [
                  SyncedTextField(
                    label: l.scopeTitle,
                    value: sc.title,
                    onChanged: (v) => set((s) => s.copyWith(title: v)),
                  ),
                  gap,
                  SyncedTextField(
                    label: l.scopeOverview,
                    value: sc.overview,
                    minLines: 2,
                    maxLines: 6,
                    keyboardType: TextInputType.multiline,
                    onChanged: (v) => set((s) => s.copyWith(overview: v)),
                  ),
                  gap,
                  _Pair(
                    SyncedTextField(
                      label: l.scopeDone,
                      value: sc.done,
                      minLines: 4,
                      maxLines: 10,
                      keyboardType: TextInputType.multiline,
                      onChanged: (v) => set((s) => s.copyWith(done: v)),
                    ),
                    SyncedTextField(
                      label: l.scopeDelivered,
                      value: sc.delivered,
                      minLines: 4,
                      maxLines: 10,
                      keyboardType: TextInputType.multiline,
                      onChanged: (v) => set((s) => s.copyWith(delivered: v)),
                    ),
                  ),
                  gap,
                  SyncedTextField(
                    label: l.scopeWarranty,
                    value: sc.warranty,
                    minLines: 2,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    onChanged: (v) => set((s) => s.copyWith(warranty: v)),
                  ),
                ],
              ),
      ),
    );
  }
}
