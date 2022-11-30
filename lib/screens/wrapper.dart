import 'package:flutter/material.dart';
import 'package:iftar/screens/authenticate/authenticate.dart';
import 'package:iftar/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:iftar/user.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final IUser? userProvided = Provider.of<IUser?>(context);

    // return either Home() or Authenticate()
    return (userProvided == null)? const Authenticate() : const Home();
  }
}