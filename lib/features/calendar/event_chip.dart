import 'package:flutter/material.dart';
import 'package:invoice_desk/domain/calendar/models.dart';
import 'package:invoice_desk/features/calendar/event_style.dart';
import 'package:invoice_desk/theme/app_theme.dart';

/// A one-line event pill: icon + text on the type's colour (never colour
/// alone). Movable events can be dragged to another day.
class EventChip extends StatelessWidget {
  const EventChip(this.event, {super.key, this.selected = false, this.onTap});
  final CalendarEvent event;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final chip = _Pill(event: event, selected: selected, onTap: onTap);
    if (!event.type.isMovable || event.done) return chip;
    return Draggable<CalendarEvent>(
      data: event,
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(width: 160, child: _Pill(event: event)),
      ),
      childWhenDragging: Opacity(opacity: 0.4, child: chip),
      child: chip,
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.event, this.selected = false, this.onTap});
  final CalendarEvent event;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final s = eventStyle(context, event);
    final text = eventTitle(context, event);
    return Semantics(
      label: '${eventTypeLabel(context, event.type)}: $text',
      button: onTap != null,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Space.radiusSmall / 2),
        child: Container(
          height: 20,
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: s.bg,
            borderRadius: BorderRadius.circular(Space.radiusSmall / 2),
            border: selected ? Border.all(color: s.fg, width: 1.5) : null,
          ),
          child: Row(
            children: [
              Icon(s.icon, size: 12, color: s.fg),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: s.fg,
                    height: 1.2,
                    decoration: event.done ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
