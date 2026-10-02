class UserModel {
  final int? id;
  final String phone;
  final String? passwordHash;
  final DateTime createdAt;

  UserModel({
    this.id,
    required this.phone,
    this.passwordHash,
    required this.createdAt,
});
  Map<String, dynamic> toMap() {
    return {
      'phone': phone,
      'password': passwordHash,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String,dynamic>map){
    return UserModel(
      id: map['id']as int?,
      phone: map['phone'] as String,
      passwordHash: map['password'] as String?,
      createdAt: DateTime.parse(map['created_at']as String),
    );
  }
}