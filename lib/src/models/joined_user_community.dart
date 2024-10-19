class JoinedUser {
  String userId;
  dynamic createdAt;
  // Add other relevant properties here

  JoinedUser({
    required this.userId,
    required this.createdAt,
    // Initialize other properties
  });

  factory JoinedUser.fromJson(Map<String, dynamic> json) {
    return JoinedUser(
      userId: json['uid'],
      createdAt: json['createdAt'],
      // Initialize other properties from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': userId,
      'createdAt': createdAt,
      // Include other properties in the JSON
    };
  }
}