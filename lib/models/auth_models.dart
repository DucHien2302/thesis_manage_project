import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_models.g.dart';

@JsonSerializable()
class RefreshTokenRequest extends Equatable {
  final String refreshToken;

  const RefreshTokenRequest({
    required this.refreshToken,
  });

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestFromJson(json);
  Map<String, dynamic> toJson() => _$RefreshTokenRequestToJson(this);

  @override
  List<Object> get props => [refreshToken];
}

@JsonSerializable()
class ChangePasswordRequest extends Equatable {
  final String oldPassword;
  final String newPassword;

  const ChangePasswordRequest({
    required this.oldPassword,
    required this.newPassword,
  });

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ChangePasswordRequestToJson(this);

  @override
  List<Object> get props => [oldPassword, newPassword];
}

@JsonSerializable()
class AdminChangePasswordRequest extends Equatable {
  final String userId;
  final String newPassword;

  const AdminChangePasswordRequest({
    required this.userId,
    required this.newPassword,
  });

  factory AdminChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$AdminChangePasswordRequestFromJson(json);
  Map<String, dynamic> toJson() => _$AdminChangePasswordRequestToJson(this);

  @override
  List<Object> get props => [userId, newPassword];
}

@JsonSerializable()
class ForgotPasswordRequest extends Equatable {
  final String email;

  const ForgotPasswordRequest({
    required this.email,
  });

  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ForgotPasswordRequestToJson(this);

  @override
  List<Object> get props => [email];
}

@JsonSerializable()
class ResetPasswordRequest extends Equatable {
  final String token;
  final String newPassword;

  const ResetPasswordRequest({
    required this.token,
    required this.newPassword,
  });

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);

  @override
  List<Object> get props => [token, newPassword];
}

@JsonSerializable()
class TokenResponse extends Equatable {
  final String accessToken;
  final String refreshToken;
  final String tokenType;

  const TokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TokenResponseToJson(this);

  @override
  List<Object> get props => [accessToken, refreshToken, tokenType];
}

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> extends Equatable {
  final bool success;
  final String message;
  final T? data;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$ApiResponseFromJson(json, fromJsonT);
  
  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);

  @override
  List<Object?> get props => [success, message, data];
}
