import 'package:equatable/equatable.dart';
import 'package:vgv/users/model/user.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

final class LoadUsers extends UserEvent {
  const LoadUsers();
}

final class AddUser extends UserEvent {
  const AddUser(this.user);

  final User user;

  @override
  List<Object?> get props => [user];
}

final class UpdateUser extends UserEvent {
  const UpdateUser(this.user);

  final User user;

  @override
  List<Object?> get props => [user];
}

final class DeleteUser extends UserEvent {
  const DeleteUser(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}
