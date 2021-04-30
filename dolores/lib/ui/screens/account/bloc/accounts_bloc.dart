import 'package:dolores/helpers/dolores_error.dart';
import 'package:dolores/helpers/status_enum.dart';
import 'package:dolores/services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../locator.dart';
import 'accounts_event.dart';
import 'accounts_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AuthService _authService = locator<AuthService>();

  AccountBloc() : super(AccountState(fetchingUserStatus: Status.Loading)) {
    add(FetchUser());
  }

  @override
  Stream<AccountState> mapEventToState(AccountEvent event) async* {
    if (event is ChangePassword) {
      yield* _mapChangePasswordToState(event);
    } else if (event is FetchUser) {
      yield* _mapFetchUserToState(event);
    }
  }

  Stream<AccountState> _mapFetchUserToState(FetchUser event) async* {
    yield state.copyWith(fetchingUserStatus: Status.Loading);
    final user = await _authService.user;

    ///TODO if user == null => force logout??
    yield state.copyWith(fetchingUserStatus: Status.Success, user: user);
  }

  Stream<AccountState> _mapChangePasswordToState(ChangePassword event) async* {
    yield state.copyWith(changePassStatus: Status.Loading);
    try {
      await _authService.changePassword(state.user.email, event.oldPassword,
          event.password, event.rePassword);
      yield state.copyWith(
          changePassStatus: Status.Success,
          oldPassword: "",
          rePassword: "",
          password: "");
    } on DoloresError catch (error) {
      yield state.copyWith(changePassStatus: Status.Fail, error: error);
    } catch (error) {
      throw error;
    }
  }
}
