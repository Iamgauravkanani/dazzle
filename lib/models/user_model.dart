class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String businessName;
  final String city;
  final String state;
  final String businessType;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.businessName,
    required this.city,
    required this.state,
    required this.businessType,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'businessName': businessName,
      'city': city,
      'state': state,
      'businessType': businessType,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      businessName: json['businessName'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      businessType: json['businessType'] ?? '',
    );
  }

  String get fullName => '$firstName $businessName';

  UserModel copyWith({
    String? uid,
    String? email,
    String? firstName,
    String? businessName,
    String? city,
    String? state,
    String? businessType,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      businessName: businessName ?? this.businessName,
      city: city ?? this.city,
      state: state ?? this.state,
      businessType: businessType ?? this.businessType,
    );
  }
} 