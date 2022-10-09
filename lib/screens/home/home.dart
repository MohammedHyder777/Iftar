
import 'package:flutter/material.dart';
import 'package:iftar/data.dart';
import 'package:iftar/screens/home/data_list.dart';
import 'package:iftar/screens/home/preferences_form.dart';
import 'package:iftar/services/auth.dart';
import 'package:iftar/services/database.dart';
import 'package:iftar/user.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);


  final AuthService _authService = AuthService();
  

  @override
  Widget build(BuildContext context) {
    final IUser? user = Provider.of<IUser?>(context);

    void _showPreferences() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: PreferencesForm(),
          );
        },
      );
    }
    return StreamProvider<List<Data>>.value(
      initialData: const [],
      value: DatabaseService().document,
      child: Scaffold(
        backgroundColor: Colors.blueGrey[200],
        appBar: AppBar(
          // backgroundColor: Colors.blue,
          shape: const StadiumBorder(),
          toolbarHeight: 77,
          leading: const SizedBox(width: 5),
          leadingWidth: 20,
          elevation: 7,
          title: Text.rich(
            TextSpan(
              text: 'الصفحة  الرئيسية',
              style: const TextStyle(fontSize: 23,),
              children: [
                TextSpan(
                  text: '\n${user!.email}\n',
                  style: const TextStyle(fontSize: 10)
                )
              ]
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton.icon(
              onPressed: () async {
                await _authService.signOut();
              }, 
              icon: const Icon(
                Icons.person_off_outlined,
                color: Colors.white,
                size: 22,
              ),
              label: const Text(
                'خروج',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            TextButton.icon(
              onPressed: () => _showPreferences(),
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
                size: 22,
              ),
              label: const Text(
                'ضبط',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              
            )
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/logo.jpg'),
              fit: BoxFit.contain,
              opacity: 0.5
            )
          ),
          child: const DataList(),
        ),
      ),
    );
  }
}