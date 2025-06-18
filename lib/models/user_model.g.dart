// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String,
  userName: json['userName'] as String,
  isActive: json['isActive'] as bool,
  userType: (json['userType'] as num).toInt(),
  userTypeName: json['userTypeName'] as String,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'userName': instance.userName,
  'isActive': instance.isActive,
  'userType': instance.userType,
  'userTypeName': instance.userTypeName,
};

UserLogin _$UserLoginFromJson(Map<String, dynamic> json) => UserLogin(
  userName: json['userName'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$UserLoginToJson(UserLogin instance) => <String, dynamic>{
  'userName': instance.userName,
  'password': instance.password,
};

UserCreate _$UserCreateFromJson(Map<String, dynamic> json) => UserCreate(
  userName: json['userName'] as String,
  password: json['password'] as String,
  isActive: json['isActive'] as bool? ?? true,
  userType: (json['userType'] as num).toInt(),
);

Map<String, dynamic> _$UserCreateToJson(UserCreate instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'password': instance.password,
      'isActive': instance.isActive,
      'userType': instance.userType,
    };

AuthResponse _$AuthResponseFromJson(Map<String, dynamic> json) => AuthResponse(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  tokenType: json['tokenType'] as String,
  user: User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthResponseToJson(AuthResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'tokenType': instance.tokenType,
      'user': instance.user,
    };
