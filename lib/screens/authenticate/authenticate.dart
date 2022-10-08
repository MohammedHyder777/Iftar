import 'package:flutter/material.dart';
import 'package:iftar/screens/authenticate/sign_in.dart';
import 'package:iftar/screens/authenticate/sign_up.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignInView = true;
  void toggleView(){
    setState(() {
      showSignInView = !showSignInView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showSignInView? SignIn(toggler: toggleView,) : SignUp(toggler: toggleView,);
  }
}