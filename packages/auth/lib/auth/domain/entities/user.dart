import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.userId,
    required this.fullName,
    this.token,
    this.tokenType,
  });

  final String userId;
  final String fullName;
  final String? token;
  final String? tokenType;

  @override
  List<Object?> get props => [userId, fullName, token, tokenType];
}

