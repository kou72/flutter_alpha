// 依存パッケージ
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStreamProvider = StreamProvider.autoDispose((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

class AuthModel {
  Future signOut() async => FirebaseAuth.instance.signOut();

  Future emailSignin({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future emailSignup({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}