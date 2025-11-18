import 'package:auth/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  LogoutUseCase(this.repository);

  final AuthRepository repository;

  Future<void> call() async {
    await repository.logout();
  }
}

