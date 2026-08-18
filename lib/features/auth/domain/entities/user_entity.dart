import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String? gender;
  final String? image;
  final String? accessToken;
  final String? refreshToken;

  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.gender,
    this.image,
    this.accessToken,
    this.refreshToken,
  });

  String get fullName => '$firstName $lastName'.trim();

  String get initials {
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return '${firstName[0]}${lastName[0]}'.toUpperCase();
    } else if (firstName.isNotEmpty && firstName.length >= 2) {
      return firstName.substring(0, 2).toUpperCase();
    } else if (username.length >= 2) {
      return username.substring(0, 2).toUpperCase();
    } else if (username.isNotEmpty) {
      return username[0].toUpperCase();
    }
    return 'NB';
  }

  @override
  List<Object?> get props => [
    id,
    username,
    email,
    firstName,
    lastName,
    gender,
    image,
    accessToken,
    refreshToken,
  ];
}
