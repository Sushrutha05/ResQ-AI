// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubtaskEntity {

 String get title; bool get isCompleted;
/// Create a copy of SubtaskEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubtaskEntityCopyWith<SubtaskEntity> get copyWith => _$SubtaskEntityCopyWithImpl<SubtaskEntity>(this as SubtaskEntity, _$identity);

  /// Serializes this SubtaskEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubtaskEntity&&(identical(other.title, title) || other.title == title)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,isCompleted);

@override
String toString() {
  return 'SubtaskEntity(title: $title, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class $SubtaskEntityCopyWith<$Res>  {
  factory $SubtaskEntityCopyWith(SubtaskEntity value, $Res Function(SubtaskEntity) _then) = _$SubtaskEntityCopyWithImpl;
@useResult
$Res call({
 String title, bool isCompleted
});




}
/// @nodoc
class _$SubtaskEntityCopyWithImpl<$Res>
    implements $SubtaskEntityCopyWith<$Res> {
  _$SubtaskEntityCopyWithImpl(this._self, this._then);

  final SubtaskEntity _self;
  final $Res Function(SubtaskEntity) _then;

/// Create a copy of SubtaskEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? isCompleted = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SubtaskEntity].
extension SubtaskEntityPatterns on SubtaskEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubtaskEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubtaskEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubtaskEntity value)  $default,){
final _that = this;
switch (_that) {
case _SubtaskEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubtaskEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SubtaskEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  bool isCompleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubtaskEntity() when $default != null:
return $default(_that.title,_that.isCompleted);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  bool isCompleted)  $default,) {final _that = this;
switch (_that) {
case _SubtaskEntity():
return $default(_that.title,_that.isCompleted);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  bool isCompleted)?  $default,) {final _that = this;
switch (_that) {
case _SubtaskEntity() when $default != null:
return $default(_that.title,_that.isCompleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubtaskEntity implements SubtaskEntity {
  const _SubtaskEntity({required this.title, this.isCompleted = false});
  factory _SubtaskEntity.fromJson(Map<String, dynamic> json) => _$SubtaskEntityFromJson(json);

@override final  String title;
@override@JsonKey() final  bool isCompleted;

/// Create a copy of SubtaskEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubtaskEntityCopyWith<_SubtaskEntity> get copyWith => __$SubtaskEntityCopyWithImpl<_SubtaskEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubtaskEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubtaskEntity&&(identical(other.title, title) || other.title == title)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,isCompleted);

@override
String toString() {
  return 'SubtaskEntity(title: $title, isCompleted: $isCompleted)';
}


}

/// @nodoc
abstract mixin class _$SubtaskEntityCopyWith<$Res> implements $SubtaskEntityCopyWith<$Res> {
  factory _$SubtaskEntityCopyWith(_SubtaskEntity value, $Res Function(_SubtaskEntity) _then) = __$SubtaskEntityCopyWithImpl;
@override @useResult
$Res call({
 String title, bool isCompleted
});




}
/// @nodoc
class __$SubtaskEntityCopyWithImpl<$Res>
    implements _$SubtaskEntityCopyWith<$Res> {
  __$SubtaskEntityCopyWithImpl(this._self, this._then);

  final _SubtaskEntity _self;
  final $Res Function(_SubtaskEntity) _then;

/// Create a copy of SubtaskEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? isCompleted = null,}) {
  return _then(_SubtaskEntity(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,isCompleted: null == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$TaskEntity {

 String get taskId; String get userId; String get title; String get description;@TimestampConverter() DateTime get deadline; String get priority; String get status; int get estimatedDuration; int get actualDuration; int get progress; String get createdBy; List<SubtaskEntity> get subtasks; int? get riskScore; String? get riskExplanation;@TimestampConverter() DateTime get createdAt;@TimestampConverter() DateTime get updatedAt;
/// Create a copy of TaskEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskEntityCopyWith<TaskEntity> get copyWith => _$TaskEntityCopyWithImpl<TaskEntity>(this as TaskEntity, _$identity);

  /// Serializes this TaskEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskEntity&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.status, status) || other.status == status)&&(identical(other.estimatedDuration, estimatedDuration) || other.estimatedDuration == estimatedDuration)&&(identical(other.actualDuration, actualDuration) || other.actualDuration == actualDuration)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&const DeepCollectionEquality().equals(other.subtasks, subtasks)&&(identical(other.riskScore, riskScore) || other.riskScore == riskScore)&&(identical(other.riskExplanation, riskExplanation) || other.riskExplanation == riskExplanation)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,userId,title,description,deadline,priority,status,estimatedDuration,actualDuration,progress,createdBy,const DeepCollectionEquality().hash(subtasks),riskScore,riskExplanation,createdAt,updatedAt);

@override
String toString() {
  return 'TaskEntity(taskId: $taskId, userId: $userId, title: $title, description: $description, deadline: $deadline, priority: $priority, status: $status, estimatedDuration: $estimatedDuration, actualDuration: $actualDuration, progress: $progress, createdBy: $createdBy, subtasks: $subtasks, riskScore: $riskScore, riskExplanation: $riskExplanation, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TaskEntityCopyWith<$Res>  {
  factory $TaskEntityCopyWith(TaskEntity value, $Res Function(TaskEntity) _then) = _$TaskEntityCopyWithImpl;
@useResult
$Res call({
 String taskId, String userId, String title, String description,@TimestampConverter() DateTime deadline, String priority, String status, int estimatedDuration, int actualDuration, int progress, String createdBy, List<SubtaskEntity> subtasks, int? riskScore, String? riskExplanation,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt
});




}
/// @nodoc
class _$TaskEntityCopyWithImpl<$Res>
    implements $TaskEntityCopyWith<$Res> {
  _$TaskEntityCopyWithImpl(this._self, this._then);

  final TaskEntity _self;
  final $Res Function(TaskEntity) _then;

/// Create a copy of TaskEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = null,Object? userId = null,Object? title = null,Object? description = null,Object? deadline = null,Object? priority = null,Object? status = null,Object? estimatedDuration = null,Object? actualDuration = null,Object? progress = null,Object? createdBy = null,Object? subtasks = null,Object? riskScore = freezed,Object? riskExplanation = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,deadline: null == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,estimatedDuration: null == estimatedDuration ? _self.estimatedDuration : estimatedDuration // ignore: cast_nullable_to_non_nullable
as int,actualDuration: null == actualDuration ? _self.actualDuration : actualDuration // ignore: cast_nullable_to_non_nullable
as int,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,subtasks: null == subtasks ? _self.subtasks : subtasks // ignore: cast_nullable_to_non_nullable
as List<SubtaskEntity>,riskScore: freezed == riskScore ? _self.riskScore : riskScore // ignore: cast_nullable_to_non_nullable
as int?,riskExplanation: freezed == riskExplanation ? _self.riskExplanation : riskExplanation // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskEntity].
extension TaskEntityPatterns on TaskEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskEntity value)  $default,){
final _that = this;
switch (_that) {
case _TaskEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskEntity value)?  $default,){
final _that = this;
switch (_that) {
case _TaskEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taskId,  String userId,  String title,  String description, @TimestampConverter()  DateTime deadline,  String priority,  String status,  int estimatedDuration,  int actualDuration,  int progress,  String createdBy,  List<SubtaskEntity> subtasks,  int? riskScore,  String? riskExplanation, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskEntity() when $default != null:
return $default(_that.taskId,_that.userId,_that.title,_that.description,_that.deadline,_that.priority,_that.status,_that.estimatedDuration,_that.actualDuration,_that.progress,_that.createdBy,_that.subtasks,_that.riskScore,_that.riskExplanation,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taskId,  String userId,  String title,  String description, @TimestampConverter()  DateTime deadline,  String priority,  String status,  int estimatedDuration,  int actualDuration,  int progress,  String createdBy,  List<SubtaskEntity> subtasks,  int? riskScore,  String? riskExplanation, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _TaskEntity():
return $default(_that.taskId,_that.userId,_that.title,_that.description,_that.deadline,_that.priority,_that.status,_that.estimatedDuration,_that.actualDuration,_that.progress,_that.createdBy,_that.subtasks,_that.riskScore,_that.riskExplanation,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taskId,  String userId,  String title,  String description, @TimestampConverter()  DateTime deadline,  String priority,  String status,  int estimatedDuration,  int actualDuration,  int progress,  String createdBy,  List<SubtaskEntity> subtasks,  int? riskScore,  String? riskExplanation, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _TaskEntity() when $default != null:
return $default(_that.taskId,_that.userId,_that.title,_that.description,_that.deadline,_that.priority,_that.status,_that.estimatedDuration,_that.actualDuration,_that.progress,_that.createdBy,_that.subtasks,_that.riskScore,_that.riskExplanation,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskEntity extends TaskEntity {
  const _TaskEntity({required this.taskId, required this.userId, required this.title, this.description = '', @TimestampConverter() required this.deadline, this.priority = 'Medium', this.status = 'Pending', this.estimatedDuration = 0, this.actualDuration = 0, this.progress = 0, this.createdBy = 'user', final  List<SubtaskEntity> subtasks = const [], this.riskScore, this.riskExplanation, @TimestampConverter() required this.createdAt, @TimestampConverter() required this.updatedAt}): _subtasks = subtasks,super._();
  factory _TaskEntity.fromJson(Map<String, dynamic> json) => _$TaskEntityFromJson(json);

@override final  String taskId;
@override final  String userId;
@override final  String title;
@override@JsonKey() final  String description;
@override@TimestampConverter() final  DateTime deadline;
@override@JsonKey() final  String priority;
@override@JsonKey() final  String status;
@override@JsonKey() final  int estimatedDuration;
@override@JsonKey() final  int actualDuration;
@override@JsonKey() final  int progress;
@override@JsonKey() final  String createdBy;
 final  List<SubtaskEntity> _subtasks;
@override@JsonKey() List<SubtaskEntity> get subtasks {
  if (_subtasks is EqualUnmodifiableListView) return _subtasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subtasks);
}

@override final  int? riskScore;
@override final  String? riskExplanation;
@override@TimestampConverter() final  DateTime createdAt;
@override@TimestampConverter() final  DateTime updatedAt;

/// Create a copy of TaskEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskEntityCopyWith<_TaskEntity> get copyWith => __$TaskEntityCopyWithImpl<_TaskEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskEntity&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.status, status) || other.status == status)&&(identical(other.estimatedDuration, estimatedDuration) || other.estimatedDuration == estimatedDuration)&&(identical(other.actualDuration, actualDuration) || other.actualDuration == actualDuration)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&const DeepCollectionEquality().equals(other._subtasks, _subtasks)&&(identical(other.riskScore, riskScore) || other.riskScore == riskScore)&&(identical(other.riskExplanation, riskExplanation) || other.riskExplanation == riskExplanation)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,taskId,userId,title,description,deadline,priority,status,estimatedDuration,actualDuration,progress,createdBy,const DeepCollectionEquality().hash(_subtasks),riskScore,riskExplanation,createdAt,updatedAt);

@override
String toString() {
  return 'TaskEntity(taskId: $taskId, userId: $userId, title: $title, description: $description, deadline: $deadline, priority: $priority, status: $status, estimatedDuration: $estimatedDuration, actualDuration: $actualDuration, progress: $progress, createdBy: $createdBy, subtasks: $subtasks, riskScore: $riskScore, riskExplanation: $riskExplanation, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TaskEntityCopyWith<$Res> implements $TaskEntityCopyWith<$Res> {
  factory _$TaskEntityCopyWith(_TaskEntity value, $Res Function(_TaskEntity) _then) = __$TaskEntityCopyWithImpl;
@override @useResult
$Res call({
 String taskId, String userId, String title, String description,@TimestampConverter() DateTime deadline, String priority, String status, int estimatedDuration, int actualDuration, int progress, String createdBy, List<SubtaskEntity> subtasks, int? riskScore, String? riskExplanation,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt
});




}
/// @nodoc
class __$TaskEntityCopyWithImpl<$Res>
    implements _$TaskEntityCopyWith<$Res> {
  __$TaskEntityCopyWithImpl(this._self, this._then);

  final _TaskEntity _self;
  final $Res Function(_TaskEntity) _then;

/// Create a copy of TaskEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? userId = null,Object? title = null,Object? description = null,Object? deadline = null,Object? priority = null,Object? status = null,Object? estimatedDuration = null,Object? actualDuration = null,Object? progress = null,Object? createdBy = null,Object? subtasks = null,Object? riskScore = freezed,Object? riskExplanation = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_TaskEntity(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,deadline: null == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,estimatedDuration: null == estimatedDuration ? _self.estimatedDuration : estimatedDuration // ignore: cast_nullable_to_non_nullable
as int,actualDuration: null == actualDuration ? _self.actualDuration : actualDuration // ignore: cast_nullable_to_non_nullable
as int,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as int,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,subtasks: null == subtasks ? _self._subtasks : subtasks // ignore: cast_nullable_to_non_nullable
as List<SubtaskEntity>,riskScore: freezed == riskScore ? _self.riskScore : riskScore // ignore: cast_nullable_to_non_nullable
as int?,riskExplanation: freezed == riskExplanation ? _self.riskExplanation : riskExplanation // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
