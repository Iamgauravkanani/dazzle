// user_model.dart

class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName; // <-- ADDED
  final String businessName;
  final String city;
  final String state;
  final String businessType;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName, // <-- ADDED
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
      'lastName': lastName, // <-- ADDED
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
      lastName: json['lastName'] ?? '', // <-- ADDED
      businessName: json['businessName'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      businessType: json['businessType'] ?? '',
    );
  }

  // Uses lastName now
  String get fullName => '$firstName $lastName';

  UserModel copyWith({
    String? uid,
    String? email,
    String? firstName,
    String? lastName, // <-- ADDED
    String? businessName,
    String? city,
    String? state,
    String? businessType,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName, // <-- ADDED
      businessName: businessName ?? this.businessName,
      city: city ?? this.city,
      state: state ?? this.state,
      businessType: businessType ?? this.businessType,
    );
  }
}
