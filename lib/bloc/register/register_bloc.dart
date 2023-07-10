import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:restaurant_app/data/models/requests/register_request_model.dart';
import 'package:restaurant_app/data/models/responses/auth_response_model.dart';
import 'package:restaurant_app/data/remote_datasources/auth_datasource.dart';

part 'register_event.dart';
part 'register_state.dart';
part 'register_bloc.freezed.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthDataSource dataSource;
  RegisterBloc(this.dataSource) : super(const _Initial()) {
    on<_Add>((event, emit) async {
      emit(const _Loading());
      final result = await dataSource.register(event.model);
      result.fold(
        (l) => emit(const _Error()),
        (data) => emit(_Loaded(data)),
      );
    });
  }
}
