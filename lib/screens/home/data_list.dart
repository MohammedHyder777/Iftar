import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:iftar/data.dart';
import 'package:iftar/screens/home/sidenav_drawer.dart';
import 'package:iftar/user.dart';
import 'package:provider/provider.dart';

class DataTile extends StatelessWidget {
  final Data data;
  final bool isThisUser;
  const DataTile({Key? key, required this.data, required this.isThisUser})
      : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        decoration: BoxDecoration(
            color: isThisUser
                ? const Color.fromARGB(209, 5, 23, 122)
                : const Color.fromARGB(209, 5, 122, 107),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(100),
              topLeft: Radius.circular(60),
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(60),
            )),
        child: ListTile(
          horizontalTitleGap: 50,
          leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.dining,
                color: Colors.red[data.strength],
              )),
          title: Text(data.name, style: const TextStyle(color: Colors.white)),
          subtitle:
              Text(data.food, style: const TextStyle(color: Colors.white)),
          trailing: !isThisUser
              ? null
              : Padding(
                padding: const EdgeInsets.only(right: 15),
                child: CurrentUserButtons(iuser: Provider.of<IUser>(context)),
              )
        ),
      ),
    );
  }
}

//*///////////////////////////////////////////////////////////////////////
class CurrentUserButtons extends StatelessWidget {
  const CurrentUserButtons({super.key, required this.iuser});
  final IUser iuser;
  @override
  Widget build(BuildContext context) {
    
    return SpeedDial(
      elevation: 0,
      backgroundColor: Colors.indigo[100],
      foregroundColor: Colors.indigo[800],
      icon: Icons.edit,
      activeIcon: Icons.close,
      buttonSize: const Size(33.0, 33.0),
      childrenButtonSize: const Size(45.0, 45.0),
      direction: SpeedDialDirection.left,
      closeDialOnPop: true,
      overlayOpacity: 0.2, // = no overlay. This is better than renderOverlay = false which make exceptions and bad UX.
      children: [
        SpeedDialChild(
          child: const Icon(Icons.tune, size: 20, color: Colors.indigo,),
          onTap: () => showPreferences(context),
        ),
        SpeedDialChild(
          child: const Icon(Icons.delete, size: 20, color: Colors.red,),
          onTap: () => viewDeleteOrderConfirm(context, iuser),
        ),
      ],
    );
  }
}

//*///////////////////////////////////////////////////////////////////////////////

/// Sort the items in the data list by the given criteria (default is 'food').
void sortBy(List<Data> unsorted, String criteria) {
  if (criteria == 'name') {
    // unsorted.sortBy((a, b) => a.name.compareTo(b.name));
    // To reverse the sorting (from arabic ي to english a):
    unsorted.sort((a, b) => a.name.compareTo(b.name));
  }
  if (criteria == 'food') {
    unsorted.sort((a, b) => a.food.compareTo(b.food));
  }
  if (criteria == 'strength') {
    unsorted.sort((a, b) => b.strength.compareTo(a.strength));
  }
}

class DataList extends StatefulWidget {
  const DataList({Key? key, this.sortCriteria = 'food'}) : super(key: key);
  final String sortCriteria;
  @override
  State<DataList> createState() => _DataListState();
}

class _DataListState extends State<DataList> {
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<List<Data>>(context);
    // Make data a modifiable list to avoid the exception:
    // Unsupported operation: Cannot modify an unmodifiable list
    data = List.from(data);
    sortBy(data, widget.sortCriteria);

    final user = Provider.of<IUser>(context);

    for (var u in data) {
      print('${u.uid} : ${u.name}');
    }

    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return DataTile(
          data: data[index],
          isThisUser: data[index].uid == user.uid,
        );
      },
    );
  }
}