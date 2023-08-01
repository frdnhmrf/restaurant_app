import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_app/bloc/get_all_product/get_all_product_bloc.dart';
import 'package:restaurant_app/data/local_datasources/auth_local_datasource.dart';
import 'package:restaurant_app/presentation/pages/add_restaurant_page.dart';
import 'package:restaurant_app/presentation/pages/home_page.dart';
import 'package:restaurant_app/presentation/pages/login_page.dart';
import 'package:restaurant_app/presentation/widgets/restaurant_card.dart';

class MyRestaurantPage extends StatefulWidget {
  static const routeName = '/my-restaurant';
  const MyRestaurantPage({super.key});

  @override
  State<MyRestaurantPage> createState() => _MyRestaurantPageState();
}

class _MyRestaurantPageState extends State<MyRestaurantPage> {
  @override
  void initState() {
    context
        .read<GetAllProductBloc>()
        .add(const GetAllProductEvent.getByUserId());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "My Restaurant",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await AuthLocalDataSource().removeAuthData();
              context.go(LoginPage.routeName);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: BlocBuilder<GetAllProductBloc, GetAllProductState>(
        builder: (context, state) {
          return state.when(
            error: () {
              return const Center(
                child: Text('Error'),
              );
            },
            initial: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            loaded: (data) {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: data.data.length,
                itemBuilder: (context, index) {
                  final restaurant = data.data[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: RestaurantCard(
                      data: restaurant,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(AddRestaurantPage.routeName);
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          if (value == 0) {
            context
                .read<GetAllProductBloc>()
                .add(const GetAllProductEvent.get());
            context.push(HomePage.routeName);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My Restaurant',
          ),
        ],
      ),
    );
  }
}
