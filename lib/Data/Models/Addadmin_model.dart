class AddAdminModel {
  final String roleName;
  final Map<String, dynamic> admin;

  AddAdminModel({
    required this.roleName,
    required this.admin,
  });

  Map<String, dynamic> toJson() {
    return {
      'roleName': roleName,
      'admin': admin,
    };
  }
}
