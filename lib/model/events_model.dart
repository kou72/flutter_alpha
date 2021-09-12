// 依存パッケージ
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

// 参照ファイル
import '/model/auth_model.dart';

// freezed 生成ファイル
part 'events_model.freezed.dart';
part 'events_model.g.dart';

final eventsProvider = StreamProvider.autoDispose((ref) {
  final stream = FirebaseFirestore.instance
      .collectionGroup('events')
      .orderBy('updateTime', descending: true)
      .snapshots();
  final events = stream.map(
    (snapshot) => snapshot.docs.map(
      (doc) => Event.fromJson(doc.data()),
    ),
  );
  return events;
});

final myEventsProvider = StreamProvider.autoDispose((ref) {
  final user = Auth().getCurrentUser();
  final stream = FirebaseFirestore.instance
      .collection('/users/${user.uid}/events/')
      .orderBy('updateTime', descending: true)
      .snapshots();
  final events = stream.map(
    (snapshot) => snapshot.docs.map(
      (doc) => Event.fromJson(doc.data()),
    ),
  );
  return events;
});

class EventsDB {
  Future createEvent(Event event) async {
    final user = Auth().getCurrentUser();
    await FirebaseFirestore.instance
        .collection('/users/${user.uid}/events/')
        .doc(event.id)
        .set(event.toJson());
  }

  Future updateEvent(Event event) async {
    await FirebaseFirestore.instance
        .collection('/users/${event.uid}/events/')
        .doc(event.id)
        .update(event.toJson());
  }

  Future deleteEvent(Event event) async {
    await FirebaseFirestore.instance
        .collection('/users/${event.uid}/events/')
        .doc(event.id)
        .delete();
  }

  Future incrementGuestCount(String uid, String id) async {
    final documentReference =
        FirebaseFirestore.instance.collection('/users/$uid/events/').doc(id);
    final snapshot = await documentReference.get();
    final increment = Event.fromJson(snapshot.data()!).guestCount + 1;

    await documentReference.update({'guestCount': increment});
  }

  Future decrementGuestCount(String uid, String id) async {
    final documentReference =
        FirebaseFirestore.instance.collection('/users/$uid/events/').doc(id);
    final snapshot = await documentReference.get();
    final increment = Event.fromJson(snapshot.data()!).guestCount - 1;

    await documentReference.update({'guestCount': increment});
  }
}

@freezed
abstract class Event with _$Event {
  const factory Event({
    @Default('') String id,
    @Default('') String title,
    @Default('') String body,
    @Default('') String uid,
    @Default(0) int guestCount,
    @Default(null) @TimestampConverter() DateTime? updateTime,
  }) = _Event;
  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}

class TimestampConverter implements JsonConverter<DateTime?, Timestamp?> {
  const TimestampConverter();
  @override
  DateTime? fromJson(Timestamp? json) => json?.toDate();
  @override
  Timestamp? toJson(DateTime? object) =>
      object == null ? null : Timestamp.fromDate(object);
}
