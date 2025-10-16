import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repository/auth_repository.dart';

class SignInWithGoogleUseCase implements UseCase<UserEntity, void> {
  final AuthRepository _repository;

  SignInWithGoogleUseCase(this._repository);

  @override
  Future<UserEntity> call({void params}) async {
    return await _repository.signInWithGoogle();
  }
}
