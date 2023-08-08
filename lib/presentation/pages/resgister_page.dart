import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:restaurant_app/bloc/register_bloc/register_bloc.dart';
import 'package:restaurant_app/data/local_datasources/auth_local_datasource.dart';
import 'package:restaurant_app/data/models/requests/register_request_model.dart';
import 'package:restaurant_app/presentation/pages/login_page.dart';
import 'package:restaurant_app/presentation/pages/my_restaurant_page.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = '/register';
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController? _nameController;
  TextEditingController? _usernameController;
  TextEditingController? _emailController;
  TextEditingController? _passwordController;
  bool isHide = true;

  @override
  void initState() {
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController!.dispose();
    _nameController!.dispose();
    _usernameController!.dispose();
    _passwordController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              const Text(
                'Register Page',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: _passwordController,
                obscureText: isHide,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      isHide
                          ? Icons.remove_red_eye
                          : Icons.remove_red_eye_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        isHide = !isHide;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              BlocConsumer<RegisterBloc, RegisterState>(
                listener: (context, state) {
                  state.maybeWhen(
                    orElse: () {},
                    error: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Register Failed'),
                        ),
                      );
                    },
                    loaded: (model) async {
                      await AuthLocalDataSource().saveAuthData(model);
                      context.go(MyRestaurantPage.routeName);
                    },
                  );
                },
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () {
                      return ElevatedButton(
                          onPressed: () {
                            final requestModel = RegisterRequestModel(
                              name: _nameController!.text,
                              password: _passwordController!.text,
                              email: _emailController!.text,
                              username: _usernameController!.text,
                            );
                            context
                                .read<RegisterBloc>()
                                .add(RegisterEvent.add(requestModel));
                          },
                          child: const Text('Register'));
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                onPressed: () {
                  context.go(LoginPage.routeName);
                },
                child: const Text("You have an account?"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
