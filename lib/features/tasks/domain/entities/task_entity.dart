import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_entity.freezed.dart';
part 'task_entity.g.dart';

class TimestampConverter implements JsonConverter<DateTime, dynamic> {
  const TimestampConverter();

  @override
  DateTime fromJson(dynamic json) {
    if (json is Timestamp) {
      return json.toDate();
    } else if (json is String) {
      return DateTime.parse(json);
    }
    return DateTime.now();
  }

  @override
  dynamic toJson(DateTime object) => Timestamp.fromDate(object);
}

@freezed
abstract class TaskEntity with _$TaskEntity {
  const TaskEntity._();

  const factory TaskEntity({
    required String taskId,
    required String userId,
    required String title,
    @Default('') String description,
    @TimestampConverter() required DateTime deadline,
    @Default('Medium') String priority,
    @Default('Pending') String status,
    @Default(0) int estimatedDuration,
    @Default(0) int actualDuration,
    @Default(0) int progress,
    @Default('user') String createdBy,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _TaskEntity;

  factory TaskEntity.fromJson(Map<String, dynamic> json) =>
      _$TaskEntityFromJson(json);
}
