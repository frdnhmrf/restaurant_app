import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_app/bloc/get_all_product/get_all_product_bloc.dart';
import 'package:restaurant_app/presentation/pages/my_restaurant_page.dart';
import 'package:restaurant_app/presentation/widgets/restaurant_card.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          BlocBuilder<GetAllProductBloc, GetAllProductState>(
            builder: (context, state) {
              print(state);
              return state.maybeWhen(
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
                loaded: (data) {
                  return ListView.builder(
                    itemCount: data.data.length,
                    itemBuilder: (context, index) {
                      final restaurant = data.data[index];
                      return RestaurantCard(
                        data: restaurant,
                      );
                    },
                  );
                },
                orElse: () {
                  return const SizedBox();
                },
              );
            },
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Go to Add Restaurant Page'),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          if (value == 1) {
            context.push(MyRestaurantPage.routeName);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My Account',
          ),
        ],
      ),
    );
  }
}
