import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:restaurant_app/data/models/responses/products_response_model.dart';
import 'package:restaurant_app/data/remote_datasources/restaurant_datasource.dart';

part 'get_all_product_event.dart';
part 'get_all_product_state.dart';
part 'get_all_product_bloc.freezed.dart';

class GetAllProductBloc extends Bloc<GetAllProductEvent, GetAllProductState> {
  final RestaurantDataSource dataSource;
  GetAllProductBloc(
    this.dataSource,
  ) : super(const _Initial()) {
    on<_Get>((event, emit) async {
      emit(const _Loading());
      final result = await dataSource.getAll();
      result.fold(
        (l) => emit(const _Error()),
        (data) => emit(_Loaded(data)),
      );
    });
  }
}
