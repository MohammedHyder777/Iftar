import 'package:flutter/material.dart';
import 'package:iftar/data.dart';
import 'package:iftar/user.dart';
import 'package:provider/provider.dart';

class DataTile extends StatelessWidget {
  final Data data;
  final bool isThisUser;
  const DataTile({Key? key, required this.data, required this.isThisUser}) : super(key: key);

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
          )
        ),
        child: ListTile(
          horizontalTitleGap: 50,
          leading: CircleAvatar(backgroundColor:Colors.white, child: Icon(Icons.dining, color: Colors.red[data.strength],)),
          title: Text(data.name, style: const TextStyle(color: Colors.white)),
          subtitle: Text(data.food, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////

class DataList extends StatefulWidget {
  const DataList({Key? key}) : super(key: key);

  @override
  State<DataList> createState() => _DataListState();
}

class _DataListState extends State<DataList> {

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<List<Data>>(context);
    final user = Provider.of<IUser>(context);
    print('*********\n${user.uid}\n*********');
    for (var u in data) {
      print('${u.uid} : ${u.name}');
    }
    
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return DataTile(data: data[index], isThisUser: data[index].uid == user.uid,);
      },
    );
  }
}