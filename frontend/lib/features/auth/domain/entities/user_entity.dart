import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;

  const UserEntity({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
  });

  @override
  List<Object?> get props => [uid, email, displayName, photoURL];
}
