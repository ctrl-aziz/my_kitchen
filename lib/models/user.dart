class AppUser {
  final String uid;

  AppUser.uid({required this.uid});
}

class UserData {
  final String? uid;
  final String? name;
  final String? image;
  final List<String>? likes;
  final List<String>? foods;
  final List<String>? favorites;
  final List<String>? followers;

  UserData({
    this.uid,
    this.name,
    this.image,
    this.likes,
    this.foods,
    this.favorites,
    this.followers,
  });
}
