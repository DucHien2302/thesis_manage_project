import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User extends Equatable {
  final String id;
  final String userName;
  final bool isActive;
  final int userType;
  final String userTypeName;

  const User({
    required this.id,
    required this.userName,
    required this.isActive,
    required this.userType,
    required this.userTypeName,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object> get props => [id, userName, isActive, userType, userTypeName];
}

@JsonSerializable()
class UserLogin extends Equatable {
  final String userName;
  final String password;

  const UserLogin({
    required this.userName,
    required this.password,
  });

  factory UserLogin.fromJson(Map<String, dynamic> json) =>
      _$UserLoginFromJson(json);
  Map<String, dynamic> toJson() => _$UserLoginToJson(this);

  @override
  List<Object> get props => [userName, password];
}

@JsonSerializable()
class UserCreate extends Equatable {
  final String userName;
  final String password;
  final bool isActive;
  final int userType;

  const UserCreate({
    required this.userName,
    required this.password,
    this.isActive = true,
    required this.userType,
  });

  factory UserCreate.fromJson(Map<String, dynamic> json) =>
      _$UserCreateFromJson(json);
  Map<String, dynamic> toJson() => _$UserCreateToJson(this);

  @override
  List<Object> get props => [userName, password, isActive, userType];
}

@JsonSerializable()
class AuthResponse extends Equatable {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final User user;

  const AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);

  @override
  List<Object> get props => [accessToken, refreshToken, tokenType, user];
}
