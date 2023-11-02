class Account {
  String id;
  String name;
  String? myToken;
  String? imagePath;

  Account({
    required this.id,
    required this.name,
    this.myToken,
    this.imagePath,
  });
}
