import 'package:go_router/go_router.dart';
import 'package:restaurant_app/data/local_datasources/auth_local_datasource.dart';
import 'package:restaurant_app/presentation/pages/add_restaurant_page.dart';
import 'package:restaurant_app/presentation/pages/home_page.dart';
import 'package:restaurant_app/presentation/pages/login_page.dart';
import 'package:restaurant_app/presentation/pages/my_restaurant_page.dart';
import 'package:restaurant_app/presentation/pages/resgister_page.dart';

final goRouter = GoRouter(
  initialLocation: HomePage.routeName,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: LoginPage.routeName,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: HomePage.routeName,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: RegisterPage.routeName,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: AddRestaurantPage.routeName,
      builder: (context, state) => const AddRestaurantPage(),
      redirect: ((context, state) async {
        final isLogin = await AuthLocalDataSource().isLogin();
        if (isLogin) {
          return null;
        } else {
          return LoginPage.routeName;
        }
      }),
    ),
    GoRoute(
      path: MyRestaurantPage.routeName,
      builder: (context, state) => const MyRestaurantPage(),
      redirect: (context, state) async {
        final isLogin = await AuthLocalDataSource().isLogin();
        if (isLogin) {
          return null;
        } else {
          return LoginPage.routeName;
        }
      },
    )
  ],
);
