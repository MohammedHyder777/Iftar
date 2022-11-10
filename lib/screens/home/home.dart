import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iftar/data.dart';
import 'package:iftar/reports/reports.dart';
import 'package:iftar/screens/home/statistics_card.dart';
import 'package:iftar/screens/home/data_list.dart';
import 'package:iftar/screens/home/preferences_form.dart';
import 'package:iftar/services/auth.dart';
import 'package:iftar/services/database.dart';
import 'package:iftar/user.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

int countFoodOrders(String type, BuildContext mycontext) {
    final data = Provider.of<List<Data>>(mycontext);
    int count = 0;
    for (var user in data) {
      if (user.food == type) {
        count++;
      }
    }
    return count;
  }

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _authService = AuthService();
  String currentCriteria = 'food';


  @override
  Widget build(BuildContext context) {
    final IUser? user = Provider.of<IUser?>(context);
    DatabaseService dbService = DatabaseService(user!.uid);

    /// Show Preferences //////////////////////////////////
    void showPreferences() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: const PreferencesForm(),
          );
        },
      );
    }

    ////////////////////////////////////////////////////////

    /// Delete order confirmation messege
    void viewDeleteOrderConfirm() {
      showDialog(
        barrierColor: const Color.fromARGB(171, 230, 118, 118),
        context: context,
        builder: (context) => AlertDialog(
            icon: const Icon(
              Icons.warning_rounded,
              color: Colors.red,
              size: 70,
            ),
            content: const Text(
              'أترغب في إلغاء هذا الطلب؟',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                label: const Text('تراجع'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.indigo),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 8)),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  try {
                    dbService.deleteOrder(user.uid);
                    // _authService.signOut();
                  } on FirebaseException catch (e) {
                    throw Exception();
                  }
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.delete),
                label: const Text('تأكيد'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 8)),
                ),
              ),
            ]),
      );
    }
    //////////////////////////////////////////

    /// Delete account confirmation messege
    void viewDeleteConfirm() {
      showDialog(
        barrierColor: const Color.fromARGB(171, 230, 118, 118),
        context: context,
        builder: (context) => AlertDialog(
            icon: const Icon(
              Icons.warning_rounded,
              color: Colors.red,
              size: 70,
            ),
            content: const Text(
              'أتدرك أنك بالموافقة ستفقد حسابك وجميع بياناتك؟',
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                label: const Text('إلغاء'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.indigo),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 8)),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  try {
                    _authService.deleteUserAccount();
                    // _authService.signOut();  // After account deletion the user will be auto logged out.
                  } on FirebaseException catch (e) {
                    throw Exception();
                  }
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.delete_forever),
                label: const Text('تأكيد'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 8)),
                ),
              ),
            ]),
      );
    }
    ////////////////////////////////////////////////////////////////////////////

    /// create PDF :
    void createPdfReport() {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          icon: Icon(
            Icons.insert_drive_file,
            size: 30,
            color: Colors.indigo,
          ),
          content: Text(
            'قريبا ... إن شاء الله',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.indigo,
            ),
          ),
        ),
      );
    }
    ////////////////////////////////////////////////////////////////////////////

    return StreamProvider<List<Data>>.value(
      initialData: const [],
      value: dbService.document,
      builder: (context, child) => Scaffold(
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
                style: const TextStyle(
                  fontSize: 23,
                ),
                children: [
                  TextSpan(
                      text: '\n${user.email}\n',
                      style: const TextStyle(fontSize: 10))
                ]),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
          ),
          actions: [
            DropdownButton(
              underline: const SizedBox(
                height: 0,
              ),
              hint: Row(
                children: const [
                  Icon(
                    Icons.settings,
                    size: 22,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text('خيارات',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
              alignment: AlignmentDirectional.bottomEnd,
              items: [
                DropdownMenuItem(
                  value: '1',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.tune, color: Colors.indigo[800]),
                      Text('عدل الطلب',
                          style: TextStyle(color: Colors.indigo[800])),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: '2',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.logout, color: Colors.indigo[800]),
                      Text('أشعر بالخروج',
                          style: TextStyle(color: Colors.indigo[800])),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: '3',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.print_rounded, color: Colors.indigo[800]),
                      Text('اعرض تقريرا',
                          style: TextStyle(color: Colors.indigo[800])),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: '4',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.delete, color: Colors.indigo[800]),
                      Text('احذف الطلب',
                          style: TextStyle(color: Colors.indigo[800])),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: '5',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.delete_forever, color: Colors.red[800]),
                      Text('احذف الحساب',
                          style: TextStyle(color: Colors.indigo[800])),
                    ],
                  ),
                ),
              ],
              onChanged: (val) async {
                if (val == '1') {
                  if (await DatabaseService.hasData(user.uid)) {
                    showPreferences();
                  } else {
                    dbService.updateUserOrderData(
                        'لن أفطر معكم', user.name, 300);
                    showPreferences();
                  }
                }
                if (val == '2') {
                  _authService.signOut();
                }
                if (val == '3') {
                  // createPdfReport();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ReportScreen(),));
                }
                if (val == '4') {
                  viewDeleteOrderConfirm();
                }
                if (val == '5') {
                  viewDeleteConfirm();
                }
              },
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/logo.jpg'),
                  fit: BoxFit.contain,
                  opacity: 0.5)),
          child: DataList(
            sortCriteria: currentCriteria,
          ),
        ),
        floatingActionButton: SpeedDial(
          spaceBetweenChildren: 14,
          spacing: 14,
          direction: SpeedDialDirection.up,
          activeIcon: Icons.close,
          buttonSize: const Size(70, 70),
          childrenButtonSize: const Size(65, 65),
          children: [
            SpeedDialChild(
              shape: const StadiumBorder(),
              backgroundColor: currentCriteria == 'name'
                  ? const Color.fromARGB(209, 5, 23, 122)
                  : const Color.fromARGB(209, 5, 122, 107),
              child: const Text(
                'بالاسم',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                setState(() => currentCriteria = 'name');
              },
            ),
            SpeedDialChild(
              shape: const StadiumBorder(),
              backgroundColor: currentCriteria == 'food'
                  ? const Color.fromARGB(209, 5, 23, 122)
                  : const Color.fromARGB(209, 5, 122, 107),
              child: const Text(
                'بالوجبة',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                setState(() => currentCriteria = 'food');
              },
            ),
            SpeedDialChild(
              shape: const StadiumBorder(),
              backgroundColor: currentCriteria == 'strength'
                  ? const Color.fromARGB(209, 5, 23, 122)
                  : const Color.fromARGB(209, 5, 122, 107),
              child: const Text(
                'بالرغبة',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                setState(() => currentCriteria = 'strength');
              },
            ),
          ],
          child: const Text('رتب'),
        ),
        // Statistics:
        extendBody: false,
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StatisticsCard(
              count: '${countFoodOrders('لن أفطر معكم', context)}',
              type: 'لن أفطر معكم',
            ),
            StatisticsCard(
              count: '${countFoodOrders('غير الفول', context)}',
              type: 'غير الفول',
            ),
            StatisticsCard(
              count: '${countFoodOrders('فول', context)}',
              type: 'الفول',
            )
          ],
        ),
      ),
    );
  }
}
