// 依存パッケージ
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

// 参照ファイル
import '/model/auth_model.dart';

// freezed 生成ファイル
part 'guests_model.freezed.dart';
part 'guests_model.g.dart';

class GuestsDB {
  Future<List<Guest>> getGuests(String eventUid, String eventId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('/users/$eventUid/events/$eventId/guests')
        .get();
    final guests = snapshot.docs.map((doc) => Guest.fromJson(doc.data()));
    return guests.toList();
  }

  Future setGuests(String eventUid, String eventId) async {
    final user = Auth().getCurrentUser();
    final guest = Guest(name: user.email!, uid: user.uid);
    await FirebaseFirestore.instance
        .collection('/users/$eventUid/events/$eventId/guests')
        .doc(user.uid)
        .set(guest.toJson());
  }

  Future deleteGuests(String eventUid, String eventId) async {
    final user = Auth().getCurrentUser();
    await FirebaseFirestore.instance
        .collection('/users/$eventUid/events/$eventId/guests')
        .doc(user.uid)
        .delete();
  }
}

@freezed
abstract class Guest with _$Guest {
  const factory Guest({
    @Default('') String name,
    @Default('') String uid,
  }) = _Guest;
  factory Guest.fromJson(Map<String, dynamic> json) => _$GuestFromJson(json);
}
