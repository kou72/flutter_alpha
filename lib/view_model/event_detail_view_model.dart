// 依存パッケージ
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// 参照ファイル
import '/model/auth_model.dart';
import '/model/events_model.dart';
import '/model/guests_model.dart';

// freezed 生成ファイル
part 'event_detail_view_model.freezed.dart';

final eventDetailViewModelProvider =
    StateNotifierProvider<EventDetailViewModel, SelectEvent>(
        (ref) => EventDetailViewModel());

class EventDetailViewModel extends StateNotifier<SelectEvent> {
  EventDetailViewModel() : super(const SelectEvent());

  void initEvent({required Event event}) {
    state = state.copyWith(
      id: event.id,
      title: event.title,
      body: event.body,
      uid: event.uid,
      guestCount: event.guestCount,
    );
  }

  Future<void> initjoinEventButton() async {
    final user = Auth().getCurrentUser();
    if (user.uid == state.uid) {
      state = state.copyWith(method: null, canJoin: true);
    } else {
      final canJoin = await canJoinEvent();
      final method = canJoin ? joinEvent : cancelEvent;
      state = state.copyWith(method: method, canJoin: canJoin);
    }
  }

  Future joinEvent() async {
    if (state.canJoin == true) {
      await EventsDB().incrementGuestCount(state.uid, state.id);
      await GuestsDB().setGuests(state.uid, state.id);
      state = state.copyWith(
        guestCount: state.guestCount + 1,
        method: cancelEvent,
        canJoin: false,
      );
    }
  }

  Future cancelEvent() async {
    if (state.canJoin == false) {
      await EventsDB().decrementGuestCount(state.uid, state.id);
      await GuestsDB().deleteGuests(state.uid, state.id);
      state = state.copyWith(
        guestCount: state.guestCount - 1,
        method: joinEvent,
        canJoin: true,
      );
    }
  }

  Future<bool> canJoinEvent() async {
    final user = Auth().getCurrentUser();
    final guestList = await GuestsDB().getGuests(state.uid, state.id);
    final isJoin = guestList.map((guest) => guest.uid).contains(user.uid);
    if (isJoin == false) {
      return true;
    } else {
      return false;
    }
  }
}

@freezed
abstract class SelectEvent with _$SelectEvent {
  const factory SelectEvent({
    @Default('') String id,
    @Default('') String title,
    @Default('') String body,
    @Default('') String uid,
    @Default(0) int guestCount,
    @Default(null) Function()? method,
    @Default(true) bool canJoin,
  }) = _SelectEvent;
}
