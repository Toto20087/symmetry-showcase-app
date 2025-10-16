import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repository/auth_repository.dart';

class SignInWithEmailParams {
  final String email;
  final String password;

  SignInWithEmailParams({required this.email, required this.password});
}

class SignInWithEmailUseCase implements UseCase<UserEntity, SignInWithEmailParams> {
  final AuthRepository _repository;

  SignInWithEmailUseCase(this._repository);

  @override
  Future<UserEntity> call({SignInWithEmailParams? params}) async {
    return await _repository.signInWithEmail(params!.email, params.password);
  }
}
