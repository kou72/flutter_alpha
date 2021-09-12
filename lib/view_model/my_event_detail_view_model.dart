// 依存パッケージ
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 参照ファイル
import '/model/events_model.dart';

final myEventDetailViewModelProvider =
    StateNotifierProvider<MyEventDetailViewModel, Event>(
  (ref) => MyEventDetailViewModel(),
);

class MyEventDetailViewModel extends StateNotifier<Event> {
  MyEventDetailViewModel() : super(const Event());

  final eventsDB = EventsDB();

  void initEvent({required Event event, required String uid}) {
    state = state.copyWith(
      id: event.id,
      title: event.title,
      body: event.body,
      guestCount: event.guestCount,
      uid: uid,
    );
  }

  void changeTitle(String value) {
    state = state.copyWith(title: value);
  }

  void changeBody(String value) {
    state = state.copyWith(body: value);
  }

  Future createEvent(Event event) async {
    await eventsDB.createEvent(event);
  }

  Future updateEvent() async {
    state = state.copyWith(updateTime: DateTime.now());
    await eventsDB.updateEvent(state);
  }

  Future deleteEvent() async {
    await eventsDB.deleteEvent(state);
  }
}
