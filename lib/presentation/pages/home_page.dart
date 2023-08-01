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
  void initState() {
    context.read<GetAllProductBloc>().add(const GetAllProductEvent.get());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Home'),
      ),
      body: BlocBuilder<GetAllProductBloc, GetAllProductState>(
        builder: (context, state) {
          return state.when(
            error: () {
              return const Center(
                child: Text('Belum ada data'),
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
                  if (restaurant == null) {
                    return const Column(
                      children: [
                        SizedBox(height: 100),
                        Center(
                          child: Text('Belum ada data'),
                        ),
                      ],
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
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
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          if (value == 1) {
            context
                .read<GetAllProductBloc>()
                .add(const GetAllProductEvent.getByUserId());
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
            label: 'My Restaurant',
          ),
        ],
      ),
    );
  }
}
