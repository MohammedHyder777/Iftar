import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:iftar/screens/reports/reports.dart';
import 'package:iftar/screens/settings_screen.dart';
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

final mykeyNavigator = GlobalKey<NavigatorState>(); //Allows showing dialogs when the parent context is not found

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.changeLanguage(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? mylocale;

  void changeLanguage(Locale locale) {
    setState(() {
      mylocale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<IUser?>.value(
        value: AuthService().user,
        initialData: null,
        child: MaterialApp(
          navigatorKey: mykeyNavigator,
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          supportedLocales: const [Locale('ar'), Locale('en')],
          locale: mylocale,
          routes: {
            '/': (context) => const Wrapper(),
            'reports_screen': (context) => const ReportScreen(),
            'settings_screen':(context) => const SettingsScreen(),
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
