import 'package:flutter/material.dart';
import 'package:iftar/reports/reports.dart';
import 'package:iftar/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:iftar/services/auth.dart';
import 'package:provider/provider.dart';
import 'user.dart';
void main() async {
  print('Before fb initialize');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print('After fb initialize');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<IUser?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
          routes: {
            '/': (context) => const Wrapper(),
            'reports_screen':(context) => const ReportScreen()
          },
          theme: ThemeData(
            primarySwatch: Colors.indigo,

            outlinedButtonTheme: OutlinedButtonThemeData(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.all(11)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
          ),

            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.all(11)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
          )),
    ));
  }
}
