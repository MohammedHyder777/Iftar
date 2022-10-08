class IUser{

  final String uid;
  String? email;
  IUser(this.uid, this.email);
}


class IUserData {
  final String? uid;
  final String name;
  final String food;
  final int strength;

  IUserData({required this.uid, required this.name, required this.food, required this.strength});

}