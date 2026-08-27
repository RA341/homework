import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:homework/generated/sdk/user/v1/user.pb.dart';

part 'user.state.freezed.dart';

@freezed
abstract class UserState with _$UserState {
  const factory UserState({User? user, @Default(false) bool isAuthed}) =
      _UserState;
}
