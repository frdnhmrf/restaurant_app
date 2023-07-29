import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:restaurant_app/data/models/responses/gmap_model.dart';
import 'package:restaurant_app/data/remote_datasources/gmap_datasource.dart';

part 'gmap_event.dart';
part 'gmap_state.dart';
part 'gmap_bloc.freezed.dart';

class GmapBloc extends Bloc<GmapEvent, GmapState> {
  final GmapDataSource dataSource;
  GmapBloc(this.dataSource) : super(const _Initial()) {
    on<_GetCurrentLocation>((event, emit) async {
      emit(const _Loading());
      final result = await dataSource.getCurrentPosition();
      result.fold(
        (l) => emit(_Error(l)),
        (r) => emit(_Loaded(r)),
      );
    });
  }
}
