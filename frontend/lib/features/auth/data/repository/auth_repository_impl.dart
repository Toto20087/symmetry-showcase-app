import '../../domain/entities/user_entity.dart';
import '../../domain/repository/auth_repository.dart';
import '../data_sources/firebase_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<UserEntity> signInWithEmail(String email, String password) async {
    return await _dataSource.signInWithEmail(email, password);
  }

  @override
  Future<UserEntity> signUpWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    return await _dataSource.signUpWithEmail(email, password, displayName);
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    return await _dataSource.signInWithGoogle();
  }

  @override
  Future<void> signOut() async {
    return await _dataSource.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return await _dataSource.getCurrentUser();
  }

  @override
  Stream<UserEntity?> get authStateChanges => _dataSource.authStateChanges;
}
