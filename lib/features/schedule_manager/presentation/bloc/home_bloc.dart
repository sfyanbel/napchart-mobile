import 'dart:async';

import 'package:polysleep/core/usecases/usecase.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/usecases/get_current_or_default_schedule.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/current_schedule_model.dart';
import 'package:polysleep/features/schedule_manager/presentation/bloc/view_model_provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:meta/meta.dart';
import 'home_event.dart';

class HomeViewModel implements ViewModelBase {
  HomeViewModel({@required this.getCurrentOrDefaultSchedule}) {
    timer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => produceCurrentTime());
    onLoadSchedule();
  }

  /* ------- STREAMS  --------- */
  final currentScheduleSubject = BehaviorSubject<SleepSchedule>();
  Stream<SleepSchedule> get currentScheduleStream =>
      currentScheduleSubject.stream;
  SleepSchedule get currentSchedule => currentScheduleSubject.value;

  final selectedSegmentSubject = BehaviorSubject<int>.seeded(-1);
  Stream<int> get seletedSegmentStream => selectedSegmentSubject.stream;
  int get selectedSegment => selectedSegmentSubject.value;

  final GetCurrentOrDefaultSchedule getCurrentOrDefaultSchedule;

  /* We want the current time to be output as a stream every second (or minute),
 so that our UI can update accordingly */
  final _currentTimeStateController = StreamController<DateTime>();
  Stream<DateTime> get currentTime => _currentTimeStateController.stream;
  StreamSink<DateTime> get _inTime => _currentTimeStateController.sink;

  Timer timer;

  void produceCurrentTime() {
    _inTime.add(DateTime.now());
  }

  //! Event handlers
  void onLoadSchedule() async {
    final resp = await getCurrentOrDefaultSchedule(NoParams());
    resp.fold((failure) async {
      // currentScheduleSubject.add(null);
    }, (schedule) async {
      // currentScheduleSubject.add(schedule);
      currentScheduleSubject.add(schedule);
    });
  }

  //! Class methods
  bool get shouldShowNapNavigationArrows =>
      this.currentSchedule.segments.length > 1;

  //! Cleanup
  void dispose() {
    _currentTimeStateController.close();
    currentScheduleSubject.close();
    selectedSegmentSubject.close();
  }
}
