import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:restaurant_app/data/models/requests/add_product_request_model.dart';
import 'package:restaurant_app/data/models/responses/add_product_response_model.dart';
import 'package:restaurant_app/data/remote_datasources/restaurant_datasource.dart';

part 'add_product_event.dart';
part 'add_product_state.dart';
part 'add_product_bloc.freezed.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  final RestaurantDataSource dataSource;
  AddProductBloc(this.dataSource) : super(_Initial()) {
    on<_Add>((event, emit) async{
      emit(const _Loading());
      final result = await dataSource.addProduct(event.model);
      result.fold(
        (l) => emit(_Error(l)),
        (data) => emit(_Loaded(data)),
      );
    });
  }
}
