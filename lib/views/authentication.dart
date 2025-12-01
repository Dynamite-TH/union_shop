import 'package:flutter/material.dart';
import 'package:union_shop/views/widgets/common_widgets.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Text('Log In/ Register'),
      ),
      bottomNavigationBar: FooterWidget(),
    );
  }
}
