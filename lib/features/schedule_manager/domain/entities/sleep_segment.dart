import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:polysleep/core/constants.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';

class SleepSegment {
  DateTime startTime;
  DateTime endTime;
  final String name;
  final bool isBeingEdited;

  SleepSegment(
      {@required this.startTime,
      @required this.endTime,
      this.name = "",
      this.isBeingEdited = false}) {
    if (startTime.isAfter(endTime)) {
      this.startTime =
          SegmentDateTime(hr: startTime.hour, min: startTime.minute, day: 0);
      this.endTime =
          SegmentDateTime(hr: endTime.hour, min: endTime.minute, day: 1);
    }
  }

  // equality overrides
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SleepSegment &&
          runtimeType == other.runtimeType &&
          startTime.isAtSameMomentAs(other.startTime) &&
          endTime.isAtSameMomentAs(other.endTime) &&
          isBeingEdited == other.isBeingEdited;

  @override
  int get hashCode =>
      startTime.hashCode + endTime.hashCode + isBeingEdited.hashCode;

  SleepSegment clone() {
    return SleepSegment(
        startTime: this.startTime,
        endTime: this.endTime,
        name: this.name,
        isBeingEdited: this.isBeingEdited);
  }

  int getStartMinutesFromMidnight() {
    return startTime.hour * 60 + startTime.minute;
  }

  int getEndMinutesFromMidnight() {
    return endTime.hour * 60 + endTime.minute;
  }

  bool startAndEndsOnSameDay() {
    return startTime.day == endTime.day;
  }

  int getDurationMinutes() {
    // one minutes is 60,000 ms
    final ms =
        endTime.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch;

    return ms ~/ 60000;
  }

  static int getTotalSleepMinutes(List<SleepSegment> segs) =>
      MINUTES_PER_DAY - getTotalAwakeMinutes(segs);

  static int getTotalAwakeMinutes(List<SleepSegment> segs) => segs
      .map((seg) => seg.getDurationMinutes())
      .reduce((segA, segB) => segA + segB);
}
