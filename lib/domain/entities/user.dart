/// User entity - core domain model

class User {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String authProvider; // 'email' | 'google'
  final String? faceEmbeddingEncrypted; // encrypted 128-d vector
  final String? faceImageUrl; // Firebase Storage path
  final String? defaultOrgId;
  final bool faceVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.authProvider,
    this.faceEmbeddingEncrypted,
    this.faceImageUrl,
    this.defaultOrgId,
    this.faceVerified = false,
    required this.createdAt,
    required this.updatedAt,
  });

  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    String? authProvider,
    String? faceEmbeddingEncrypted,
    String? faceImageUrl,
    String? defaultOrgId,
    bool? faceVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      authProvider: authProvider ?? this.authProvider,
      faceEmbeddingEncrypted: faceEmbeddingEncrypted ?? this.faceEmbeddingEncrypted,
      faceImageUrl: faceImageUrl ?? this.faceImageUrl,
      defaultOrgId: defaultOrgId ?? this.defaultOrgId,
      faceVerified: faceVerified ?? this.faceVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'displayName': displayName,
    'photoUrl': photoUrl,
    'authProvider': authProvider,
    'faceEmbeddingEncrypted': faceEmbeddingEncrypted,
    'faceImageUrl': faceImageUrl,
    'defaultOrgId': defaultOrgId,
    'faceVerified': faceVerified,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String,
    email: json['email'] as String,
    displayName: json['displayName'] as String,
    photoUrl: json['photoUrl'] as String?,
    authProvider: json['authProvider'] as String,
    faceEmbeddingEncrypted: json['faceEmbeddingEncrypted'] as String?,
    faceImageUrl: json['faceImageUrl'] as String?,
    defaultOrgId: json['defaultOrgId'] as String?,
    faceVerified: json['faceVerified'] as bool? ?? false,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  @override
  String toString() => 'User(id: $id, email: $email, role: $authProvider)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}