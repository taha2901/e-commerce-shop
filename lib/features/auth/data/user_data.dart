class UserData {
  final String id;
  final String username;
  final String email;
  final String role; 
  final String createdAt;

  UserData( {
    required this.id,
    required this.role,
    required this.username,
    required this.email,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'role': role, // إضافة الدور
      'createdAt': createdAt
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map, String id) {
    return UserData(
      id: id,
      username: map['username'] ?? '',
      role: map['role'] ?? 'user', // تعيين دور افتراضي للمستخدم
      email: map['email'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }

  // إضافة copyWith للسهولة
  UserData copyWith({
    String? id,
    String? username,
    String? email,
    String? role,
    String? createdAt,
  }) {
    return UserData(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'UserData(id: $id, username: $username, email: $email, createdAt: $createdAt , role: $role)';
  }
}
