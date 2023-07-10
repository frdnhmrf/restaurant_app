import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:restaurant_app/data/models/requests/login_request_model.dart';
import 'package:restaurant_app/data/models/responses/auth_response_model.dart';
import 'package:restaurant_app/data/remote_datasources/auth_datasource.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthDataSource dataSource;
  LoginBloc(this.dataSource) : super(const _Initial()) {
    on<_Add>((event, emit) async {
      emit(const _Loading());
      final result = await dataSource.login(event.model);
      result.fold(
        (l) => emit(_Error(l)),
        (data) => emit(_Loaded(data)),
      );
    });
  }
}
