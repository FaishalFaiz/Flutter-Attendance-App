/// Face embedding entity - biometric face data for verification

class FaceEmbedding {
  final String userId;
  final List<double> vector; // 128-dimensional embedding
  final String encryptedVector; // encrypted version for storage
  final int sampleCount; // number of angles captured
  final DateTime createdAt;
  final DateTime updatedAt;

  const FaceEmbedding({
    required this.userId,
    required this.vector,
    required this.encryptedVector,
    this.sampleCount = 1,
    required this.createdAt,
    required this.updatedAt,
  });

  FaceEmbedding copyWith({
    String? userId,
    List<double>? vector,
    String? encryptedVector,
    int? sampleCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FaceEmbedding(
      userId: userId ?? this.userId,
      vector: vector ?? this.vector,
      encryptedVector: encryptedVector ?? this.encryptedVector,
      sampleCount: sampleCount ?? this.sampleCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'encryptedVector': encryptedVector,
    'sampleCount': sampleCount,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory FaceEmbedding.fromJson(Map<String, dynamic> json) => FaceEmbedding(
    userId: json['userId'] as String,
    vector: [], // vector is not stored in JSON, only encrypted
    encryptedVector: json['encryptedVector'] as String,
    sampleCount: json['sampleCount'] as int? ?? 1,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FaceEmbedding && runtimeType == other.runtimeType && userId == other.userId;

  @override
  int get hashCode => userId.hashCode;
}