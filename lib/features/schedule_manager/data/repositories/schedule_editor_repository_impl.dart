import 'package:dartz/dartz.dart';
import 'package:polysleep/core/error/exceptions.dart';
import 'package:polysleep/core/error/failure.dart';
import 'package:polysleep/features/schedule_manager/data/datasources/assets_data_source.dart';
import 'package:polysleep/features/schedule_manager/data/datasources/preferences_data_source.dart';
import 'package:polysleep/features/schedule_manager/data/models/sleep_schedule_model.dart';
import 'package:polysleep/features/schedule_manager/data/models/sleep_segment_model.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/segment_datetime.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_schedule.dart';
import 'package:polysleep/features/schedule_manager/domain/entities/sleep_segment.dart';
import 'package:polysleep/features/schedule_manager/domain/repositories/schedule_editor_repository.dart';
import 'package:meta/meta.dart';

class ScheduleEditorRepositoryImpl implements ScheduleEditorRepository {
  final PreferencesDataSource preferencesDataSource;
  final AssetsDataSource assetsDataSource;

  ScheduleEditorRepositoryImpl(
      {@required this.preferencesDataSource, @required this.assetsDataSource});
  // temporary
  getSegments() async {
    final segments = [
      SleepSegment(
          startTime: SegmentDateTime(hr: 10, min: 30, day: 0),
          endTime: SegmentDateTime(hr: 12, min: 0, day: 0))
    ];
    return segments;
  }

  @override
  Future<Either<Failure, SleepSchedule>> getCurrentSchedule() async {
    try {
      final currentSchedule = await preferencesDataSource.getCurrentSchedule();
      return Right(currentSchedule);
    } on PreferencesException {
      return Left(PreferencesFailure());
    }
  }

  @override
  Future<Either<Failure, SleepSegment>> putTemporarySleepSegment(
      SleepSegment segment) {
    // TODO: implement putTemporarySleepSegment

    return null;
  }

  @override
  Future<Either<Failure, SleepSchedule>> getDefaultSchedule() async {
    try {
      final defaultSchedule = await assetsDataSource.getDefaultSchedule();
      return Right(defaultSchedule);
    } on AssetsException {
      return Left(AssetsFailure());
    }
  }

  @override
  Future<Either<Failure, SleepSchedule>> putCurrentSchedule(
      SleepSchedule schedule) async {
    try {
      // TODO:
      List<SleepSegmentModel> mSegments = schedule.segments
          .map((f) =>
              SleepSegmentModel(startTime: f.startTime, endTime: f.endTime))
          .toList();
      final model =
          SleepScheduleModel(segments: mSegments, name: schedule.name);
      final SleepSchedule updatedModel =
          await preferencesDataSource.putCurrentSchedule(model);
      return Right(updatedModel);
    } on PreferencesException {
      return Left(PreferencesFailure());
    }
  }

  // We will need to return a list of all our schedule at some point.
  // How about a
}