import 'package:flutter/material.dart';
import 'package:iftar/resources/resources.dart';
import 'package:iftar/services/database.dart';
import 'package:iftar/user.dart';
import 'package:provider/provider.dart';

class PreferencesForm extends StatefulWidget {
  const PreferencesForm({Key? key}) : super(key: key);

  @override
  State<PreferencesForm> createState() => _PreferencesFormState();
}

class _PreferencesFormState extends State<PreferencesForm> {

  final _formKey = GlobalKey<FormState>();
  List<String> food = ['فول', 'غير الفول', 'لن أفطر معكم'];

  String? newName;
  String? newFood;
  int? newStrength;
  bool updateClicked = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<IUser>(context);
    return StreamBuilder<Object>(
        stream: DatabaseService(user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            IUserData userData = snapshot.data as IUserData;

            return updateClicked
                ? const CircleLoading()
                : Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const Text(
                            '!ما تشتهي؟ ... ممّا هو متاح',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // A Field for setting Name
                          TextFormField(
                            initialValue: userData.name,
                            decoration: fieldDecor(label: 'الاسم').copyWith(
                              filled: false,
                            ),
                            textDirection: TextDirection.rtl,
                            validator: (value) =>
                                value!.isEmpty ? 'من أنت؟ أدخل اسمك' : null,
                            onChanged: (value) =>
                                setState(() => newName = value),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          // A dropdown for setting food
                          DropdownButtonFormField(
                            alignment: AlignmentDirectional.centerEnd,
                            isExpanded: true,
                            value: newFood ?? userData.food,
                            items: food.map((e) {
                              return DropdownMenuItem(
                                value: e,
                                alignment: AlignmentDirectional.centerEnd,
                                child: Text(e),
                              );
                            }).toList(),
                            onChanged: (value) =>
                                setState(() => newFood = value as String),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          // A slider for setting strength
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'ما قدر جوعتك؟',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Slider(
                              value:
                                  (newStrength ?? userData.strength).toDouble(),
                              max: 900,
                              min: 100,
                              divisions: 8,
                              activeColor:
                                  Colors.blue[newStrength ?? userData.strength],
                              inactiveColor: Colors.lightBlue[
                                  newStrength ?? userData.strength - 300],
                              thumbColor:
                                  Colors.blue[newStrength ?? userData.strength],
                              onChanged: (value) =>
                                  setState(() => newStrength = value.toInt())),
                          // Update Button
                          OutlinedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  updateClicked = true;
                                });
                                await DatabaseService(user.uid).updateUserOrderData(
                                    newFood ?? userData.food,
                                    newName ?? userData.name,
                                    newStrength ?? userData.strength);
                                // updateClicked = false; // Not necessary because when 'ضبط' is pressed a new instance of PreferencesForm is initialized with updateClicked = false.
                                // setState(() => updateClicked = false);
                                Navigator.pop(context);
                              }
                            },
                            child: const Text(
                              'حدّث تفضيلاتك',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ));
          } else {
            return const Loading();
          }
        });
  }
}
