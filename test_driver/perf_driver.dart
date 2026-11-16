import 'package:flutter_driver/flutter_driver.dart' as driver;
import 'package:integration_test/integration_test_driver.dart';

/// Writes build/calendar_month.timeline_summary.json for the perf test.
Future<void> main() => integrationDriver(
  responseDataCallback: (data) async {
    final raw = data?['calendar_month'];
    if (raw is! Map<String, dynamic>) return;
    final summary = driver.TimelineSummary.summarize(
      driver.Timeline.fromJson(raw),
    );
    await summary.writeTimelineToFile(
      'calendar_month',
    );
  },
);
