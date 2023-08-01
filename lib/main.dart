import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/bloc/add_product/add_product_bloc.dart';
import 'package:restaurant_app/bloc/detail_product/detail_product_bloc.dart';
import 'package:restaurant_app/bloc/get_all_product/get_all_product_bloc.dart';
import 'package:restaurant_app/bloc/gmap_bloc/gmap_bloc.dart';
import 'package:restaurant_app/bloc/login/login_bloc.dart';
import 'package:restaurant_app/bloc/register/register_bloc.dart';
import 'package:restaurant_app/data/remote_datasources/auth_datasource.dart';
import 'package:restaurant_app/data/remote_datasources/gmap_datasource.dart';
import 'package:restaurant_app/data/remote_datasources/restaurant_datasource.dart';
import 'package:restaurant_app/router/go_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetAllProductBloc(RestaurantDataSource()),
        ),
        BlocProvider(
          create: (context) => DetailProductBloc(RestaurantDataSource()),
        ),
        BlocProvider(
          create: (context) => GmapBloc(GmapDataSource()),
        ),
        BlocProvider(
          create: (context) => RegisterBloc(AuthDataSource()),
        ),
        BlocProvider(
          create: (context) => LoginBloc(AuthDataSource()),
        ),
        BlocProvider(
          create: (context) => AddProductBloc(RestaurantDataSource()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: goRouter,
      ),
    );
  }
}
