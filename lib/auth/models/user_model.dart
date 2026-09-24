class UserModel {
  final int? id;
  final String phone;
  final DateTime createdAt;

  UserModel({
    this.id,
    required this.phone,
    required this.createdAt,
});
  Map<String,dynamic> toMap(){
    return{

      'phone':phone,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String,dynamic>map){
    return UserModel(
      id: map['id']as int?,
      phone: map['phone'] as String,
      createdAt: DateTime.parse(map['created_at']as String),
    );
  }
}