import 'dart:convert';

import 'package:equatable/equatable.dart';

class AuthorizationResult extends Equatable {
  final String tokenType;
  final String accessToken;
  final String refreshToken;
  final String role;

  const AuthorizationResult({
    required this.tokenType,
    required this.accessToken,
    required this.refreshToken,
    required this.role,
  });

  factory AuthorizationResult.fromMap(Map<String, dynamic> data) {
    return AuthorizationResult(
      tokenType: data['token_type'] as String,
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String,
      role: data['role'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
    'token_type': tokenType,
    'access_token': accessToken,
    'refresh_token': refreshToken,
    'role': role,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [AuthorizationResult].
  factory AuthorizationResult.fromJson(String data) {
    return AuthorizationResult.fromMap(
      json.decode(data) as Map<String, dynamic>,
    );
  }

  /// `dart:convert`
  ///
  /// Converts [AuthorizationResult] to a JSON string.
  String toJson() => json.encode(toMap());

  AuthorizationResult copyWith({
    String? tokenType,
    String? accessToken,
    String? refreshToken,
    String? role,
  }) {
    return AuthorizationResult(
      tokenType: tokenType ?? this.tokenType,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      role: role ?? this.role,
    );
  }

  @override
  List<Object?> get props => [tokenType, accessToken, refreshToken, role];
}
