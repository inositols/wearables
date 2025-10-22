// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'biometric_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BiometricData _$BiometricDataFromJson(Map<String, dynamic> json) => BiometricData(
      date: json['date'] as String,
      hrv: (json['hrv'] as num).toDouble(),
      rhr: json['rhr'] as int,
      steps: json['steps'] as int,
      sleepScore: json['sleepScore'] as int,
    );

Map<String, dynamic> _$BiometricDataToJson(BiometricData instance) =>
    <String, dynamic>{
      'date': instance.date,
      'hrv': instance.hrv,
      'rhr': instance.rhr,
      'steps': instance.steps,
      'sleepScore': instance.sleepScore,
    };

