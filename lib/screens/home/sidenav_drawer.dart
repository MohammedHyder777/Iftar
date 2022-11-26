import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iftar/screens/home/preferences_form.dart';
import 'package:iftar/user.dart';
import 'package:iftar/services/database.dart';
import '../../services/auth.dart';

class SideNavDrawer extends StatelessWidget {
  SideNavDrawer({super.key, required this.iuser});
  final IUser iuser;

  bool hasOrder = true;

  void setHasOrder() async {
    hasOrder = await DatabaseService.hasData(iuser.uid);
  }

  @override
  Widget build(BuildContext context) {
    setHasOrder();

    return Drawer(
      // width: MediaQuery.of(context).size.width * 0.7,
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
                color: Colors.indigo,
                image: DecorationImage(
                    image: AssetImage('assets/logo.jpg'), fit: BoxFit.cover)),
            child: SizedBox(),
          ),
          ExpansionTile(
            childrenPadding: const EdgeInsets.only(right: 15),
            leading: Icon(Icons.set_meal, color: Colors.indigo[800]),
            title: Text('أدر طلباتك', style: TextStyle(color: Colors.indigo[800], fontSize: 18, fontWeight: FontWeight.bold)),
            children: [
              ListTile(
                leading: Icon(Icons.tune, color: Colors.indigo[800]),
                title:
                    Text(hasOrder? 'عدل الطلب' : 'اطلب', style: TextStyle(color: Colors.indigo[800])),
                onTap: () async {
                  if (await DatabaseService.hasData(iuser.uid)) {
                    Navigator.of(context).pop();
                    showPreferences(context);
                  } else {
                    Navigator.of(context).pop();
                    DatabaseService(iuser.uid).updateUserOrderData('لن أفطر معكم', iuser.name, 300);
                    showPreferences(context);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.indigo[800]),
                title:
                    Text('ألغ الطلب', style: TextStyle(color: Colors.indigo[800])),
                onTap: () {
                  viewDeleteOrderConfirm(context, iuser);
                },
              )
            ],
          ),
          ExpansionTile(
            childrenPadding: const EdgeInsets.only(right: 15),
            leading: Icon(Icons.stacked_bar_chart, color: Colors.indigo[800]),
            title: Text('اعرض تقريرا',
                style: TextStyle(color: Colors.indigo[800], fontSize: 18, fontWeight: FontWeight.bold)),
            children: [
              ListTile(
                leading: Icon(Icons.bar_chart, color: Colors.indigo[800]),
                title: Text('في شكل أشرطة بيانية', style: TextStyle(color: Colors.indigo[800])),
                onTap: () {
                  Navigator.pushNamed(context, 'reports_screen', arguments: 'Bar');
                },
              ),
              ListTile(
                leading: Icon(Icons.pie_chart, color: Colors.indigo[800]),
                title: Text('في شكل دائري', style: TextStyle(color: Colors.indigo[800])),
                onTap: () {
                  Navigator.pushNamed(context, 'reports_screen', arguments: 'Pie');
                },
              ),
              ListTile(
                leading: Icon(Icons.donut_large_rounded, color: Colors.indigo[800]),
                title: Text('في شكل حلقي', style: TextStyle(color: Colors.indigo[800])),
                onTap: () {
                  Navigator.pushNamed(context, 'reports_screen', arguments: 'Doughnut');
                },
              ),
            ],
          ),
          ExpansionTile(
            childrenPadding: const EdgeInsets.only(right: 15),
            leading: Icon(Icons.account_box, color: Colors.indigo[800]),
            title: Text('أدر حسابك', style: TextStyle(color: Colors.indigo[800], fontSize: 18, fontWeight: FontWeight.bold)),
            children: [
              ListTile(
                leading: Icon(Icons.delete_forever, color: Colors.red[800]),
                title: Text('احذف الحساب', style: TextStyle(color: Colors.indigo[800])),
                onTap: () => viewDeleteConfirm(context),
              )
            ],
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.indigo[800]),
            title: Text('سجّل الخروج',
                style: TextStyle(color: Colors.indigo[800])),
            onTap: () => AuthService().signOut(),
          ),
        ],
      ),
    );
  }
}

/// Show Preferences //////////////////////////////////
    void showPreferences(BuildContext context) {
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
    void viewDeleteOrderConfirm(BuildContext context, IUser user) {
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
                    DatabaseService().deleteOrder(user.uid);
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
    void viewDeleteConfirm(BuildContext context) {
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
              'أتدرك أنك بالموافقة ستفقد حسابك وطلباتك؟',
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
                    AuthService().deleteUserAccount();
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
    void createPdfReport(BuildContext context) {
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