import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repository/auth_repository.dart';

class SignUpWithEmailParams {
  final String email;
  final String password;
  final String displayName;

  SignUpWithEmailParams({
    required this.email,
    required this.password,
    required this.displayName,
  });
}

class SignUpWithEmailUseCase implements UseCase<UserEntity, SignUpWithEmailParams> {
  final AuthRepository _repository;

  SignUpWithEmailUseCase(this._repository);

  @override
  Future<UserEntity> call({SignUpWithEmailParams? params}) async {
    return await _repository.signUpWithEmail(
      params!.email,
      params.password,
      params.displayName,
    );
  }
}
