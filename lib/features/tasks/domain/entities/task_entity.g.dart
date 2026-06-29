// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubtaskEntity _$SubtaskEntityFromJson(Map<String, dynamic> json) =>
    _SubtaskEntity(
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$SubtaskEntityToJson(_SubtaskEntity instance) =>
    <String, dynamic>{
      'title': instance.title,
      'isCompleted': instance.isCompleted,
    };

_TaskEntity _$TaskEntityFromJson(Map<String, dynamic> json) => _TaskEntity(
  taskId: json['taskId'] as String,
  userId: json['userId'] as String,
  title: json['title'] as String,
  description: json['description'] as String? ?? '',
  deadline: const TimestampConverter().fromJson(json['deadline']),
  priority: json['priority'] as String? ?? 'Medium',
  status: json['status'] as String? ?? 'Pending',
  estimatedDuration: (json['estimatedDuration'] as num?)?.toInt() ?? 0,
  actualDuration: (json['actualDuration'] as num?)?.toInt() ?? 0,
  progress: (json['progress'] as num?)?.toInt() ?? 0,
  createdBy: json['createdBy'] as String? ?? 'user',
  subtasks:
      (json['subtasks'] as List<dynamic>?)
          ?.map((e) => SubtaskEntity.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  riskScore: (json['riskScore'] as num?)?.toInt(),
  riskExplanation: json['riskExplanation'] as String?,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$TaskEntityToJson(_TaskEntity instance) =>
    <String, dynamic>{
      'taskId': instance.taskId,
      'userId': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'deadline': const TimestampConverter().toJson(instance.deadline),
      'priority': instance.priority,
      'status': instance.status,
      'estimatedDuration': instance.estimatedDuration,
      'actualDuration': instance.actualDuration,
      'progress': instance.progress,
      'createdBy': instance.createdBy,
      'subtasks': instance.subtasks,
      'riskScore': instance.riskScore,
      'riskExplanation': instance.riskExplanation,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
