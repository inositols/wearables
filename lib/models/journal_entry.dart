import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';

part 'journal_entry.g.dart';

@JsonSerializable()
class JournalEntry {
  final String date;
  final int mood;
  final String note;

  const JournalEntry({
    required this.date,
    required this.mood,
    required this.note,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) =>
      _$JournalEntryFromJson(json);

  Map<String, dynamic> toJson() => _$JournalEntryToJson(this);

  DateTime get dateTime => DateTime.parse(date);

  String get moodEmoji {
    switch (mood) {
      case 1:
        return '😞';
      case 2:
        return '😕';
      case 3:
        return '😐';
      case 4:
        return '😊';
      case 5:
        return '😄';
      default:
        return '😐';
    }
  }

  String get moodDescription {
    switch (mood) {
      case 1:
        return 'Very Poor';
      case 2:
        return 'Poor';
      case 3:
        return 'Neutral';
      case 4:
        return 'Good';
      case 5:
        return 'Excellent';
      default:
        return 'Unknown';
    }
  }

  Color get moodColor {
    switch (mood) {
      case 1:
        return Colors.red; // Very Poor - Red
      case 2:
        return Colors.orange; // Poor - Orange
      case 3:
        return Colors.yellow; // Neutral - Yellow
      case 4:
        return Colors.lightGreen; // Good - Light Green
      case 5:
        return Colors.green; // Excellent - Green
      default:
        return Colors.grey; // Unknown - Grey
    }
  }

  @override
  String toString() {
    return 'JournalEntry(date: $date, mood: $mood, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JournalEntry &&
        other.date == date &&
        other.mood == mood &&
        other.note == note;
  }

  @override
  int get hashCode {
    return date.hashCode ^ mood.hashCode ^ note.hashCode;
  }
}


