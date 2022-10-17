class IUser{

  final String uid;
  String? email;
  String name;
  
  IUser(this.uid, this.email, this.name);
}


class IUserData {
  final String? uid;
  final String name;
  final String food;
  final int strength;

  IUserData({required this.uid, required this.name, required this.food, required this.strength});

}