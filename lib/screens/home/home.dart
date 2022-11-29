import 'package:flutter/material.dart';
import 'package:iftar/data.dart';
import 'package:iftar/screens/home/sidenav_drawer.dart';
import 'package:iftar/screens/home/statistics_card.dart';
import 'package:iftar/screens/home/data_list.dart';
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
    GlobalKey<ScaffoldState> keyToOpenEndDrawer = GlobalKey();

    return StreamProvider<List<Data>>.value(
      initialData: const [],
      value: DatabaseService.document,
      builder: (context, child) => Scaffold(
        key: keyToOpenEndDrawer,
        backgroundColor: Colors.blueGrey[200],
        appBar: AppBar(
          // backgroundColor: Colors.blue,
          shape: const StadiumBorder(),
          toolbarHeight: 77,
          leading: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: IconButton(onPressed: () => keyToOpenEndDrawer.currentState!.openDrawer(), icon: const Icon(Icons.menu, size: 26,)),
          ),
          // leadingWidth: 20,
          elevation: 7,
          title: Text.rich(
            TextSpan(
                text: 'الصفحة  الرئيسية',
                style: const TextStyle(
                  fontSize: 23,
                ),
                children: [
                  TextSpan(
                      text: '\n${user!.email}\n',
                      style: const TextStyle(fontSize: 10))
                ]),
            // textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 10),
              child: IconButton(onPressed: () => _authService.signOut(), icon: const Icon(Icons.logout, size: 26,)),
            ),
          ],
        ),
        drawer: Directionality(textDirection: TextDirection.rtl ,child: SideNavDrawer(iuser: user)),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/logo.jpg'),
                  fit: BoxFit.contain,
                  opacity: 0.5)),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: DataList(
              sortCriteria: currentCriteria,
            ),
          ),
        ),
        floatingActionButton: SpeedDial(
          spaceBetweenChildren: 14,
          spacing: 14,
          direction: MediaQuery.of(context).orientation == Orientation.portrait? SpeedDialDirection.up : SpeedDialDirection.left,
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
