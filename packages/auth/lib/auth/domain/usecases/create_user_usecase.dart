import 'package:auth/auth/domain/repositories/auth_repository.dart';

class CreateUserUseCase {
  CreateUserUseCase(this.repository);

  final AuthRepository repository;

  Future<void> call({
    required String userId,
    required String password,
    required String fullName,
    required DateTime birthDate,
  }) async {
    return await repository.createUser(
      userId: userId,
      password: password,
      fullName: fullName,
      birthDate: birthDate,
    );
  }
}

