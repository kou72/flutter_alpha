// 依存パッケージ
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 参照ファイル
import '/view_model/event_detail_view_model.dart';

class JoinButton extends HookWidget {
  const JoinButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useProvider(eventDetailViewModelProvider);

    return SizedBox(
      width: 200,
      child: button(state: state),
    );
  }

  Widget button({required SelectEvent state}) {
    if (state.canJoin == true) {
      return ElevatedButton(
        onPressed: state.method,
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            const EdgeInsets.all(20),
          ),
        ),
        child: const Text('申し込み'),
      );
    } else {
      return OutlinedButton(
        onPressed: state.method,
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
            const EdgeInsets.all(20),
          ),
        ),
        child: const Text('キャンセル'),
      );
    }
  }
}
