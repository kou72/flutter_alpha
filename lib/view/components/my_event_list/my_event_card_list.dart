// 依存パッケージ
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 参照ファイル
import '/model/events_model.dart';
import '/view/my_event_detail_page.dart';

class MyEventCardList extends HookWidget {
  const MyEventCardList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenMaxHeight = MediaQuery.of(context).size.height;
    final eventList = useProvider(myEventsProvider);

    return SizedBox(
      height: screenMaxHeight * 0.8,
      child: eventList.when(
        data: (events) {
          return _eventCardList(context, events.toList());
        },
        loading: () {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
        error: (err, stackTrace) {
          return Center(
            child: Text(err.toString()),
          );
        },
      ),
    );
  }

  Widget _eventCardList(BuildContext context, List<Event> events) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return _eventCard(context, events[index]);
      },
    );
  }

  Widget _eventCard(BuildContext context, Event event) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: Colors.blue[100],
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) {
                return MyEventDetailPage(event: event);
              },
            ),
          );
        },
        child: SizedBox(
          height: 64,
          child: ListTile(
            title: Text('${event.title}：${event.guestCount}人'),
            subtitle: Text(event.updateTime.toString()),
          ),
        ),
      ),
    );
  }
}
