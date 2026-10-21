class UserModel {
  /// Local SQLite user ID.
  final int? id;

  /// User ID assigned by the FastAPI/PostgreSQL backend.
  final String? serverUserId;

  final String phone;
  final String? passwordHash;
  final DateTime createdAt;

  UserModel({
    this.id,
    this.serverUserId,
    required this.phone,
    this.passwordHash,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'phone': phone,
      'password_hash': passwordHash,
      'created_at': createdAt.toIso8601String(),
      'server_user_id': serverUserId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      serverUserId: map['server_user_id'] as String?,
      phone: map['phone'] as String,
      passwordHash: map['password_hash'] as String?,
      createdAt: DateTime.parse(
        map['created_at'] as String,
      ),
    );
  }

  UserModel copyWith({
    int? id,
    String? serverUserId,
    String? phone,
    String? passwordHash,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      serverUserId: serverUserId ?? this.serverUserId,
      phone: phone ?? this.phone,
      passwordHash: passwordHash ?? this.passwordHash,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}