// 依存パッケージ
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 参照ファイル
import '/view/components/signin/email_form.dart';
import '/view/components/signin/email_signin_button.dart';
import '/view/components/signin/email_signup_button.dart';
import '/view/components/signin/info_text.dart';
import '/view/components/signin/password_form.dart';

class SigninPage extends StatelessWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signin'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            InfoText(),
            EmailForm(),
            PasswordForm(),
            EmailSigninButton(),
            EmailSignupButton(),
          ],
        ),
      ),
    );
  }
}
