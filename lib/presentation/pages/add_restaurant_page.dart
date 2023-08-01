import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_app/bloc/add_product/add_product_bloc.dart';
import 'package:restaurant_app/bloc/get_all_product/get_all_product_bloc.dart';
import 'package:restaurant_app/data/local_datasources/auth_local_datasource.dart';
import 'package:restaurant_app/data/models/requests/add_product_request_model.dart';

class AddRestaurantPage extends StatefulWidget {
  static const routeName = '/add-restaurant';
  const AddRestaurantPage({super.key});
  @override
  State<AddRestaurantPage> createState() => _AddRestaurantPageState();
}

class _AddRestaurantPageState extends State<AddRestaurantPage> {
  TextEditingController? _nameController;
  TextEditingController? _descriptionController;
  TextEditingController? _addressController;

  XFile? imageFile;
  List<XFile>? imageFiles;

  @override
  void initState() {
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _addressController = TextEditingController();
    super.initState();
  }

  Future<void> getImage(ImageSource imageSource) async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: imageSource,
      imageQuality: 50,
    );

    if (photo != null) {
      imageFile = photo;
      setState(() {});
    }
  }

  Future<void> getMultipleImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> photos = await picker.pickMultiImage();
    imageFiles = photos;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Restaurant'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        children: [
          imageFile != null
              ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  height: 200,
                  width: 200,
                  child: Image.file(File(imageFile!.path)))
              : Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(border: Border.all()),
                ),
          imageFiles != null
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    ...imageFiles!
                        .map((e) => SizedBox(
                              height: 100,
                              width: 120,
                              child: Image.file(File(e.path)),
                            ))
                        .toList(),
                  ]),
                )
              : const SizedBox(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () async {}, child: const Text("Camera")),
              ElevatedButton(
                  onPressed: () {
                    getImage(ImageSource.gallery);
                    // getMultipleImages();
                  },
                  child: const Text("Gallery")),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
                labelText: 'Name', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
                labelText: 'Description', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _addressController,
            decoration: const InputDecoration(
                labelText: 'Address', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10),
          BlocConsumer<AddProductBloc, AddProductState>(
            listener: (context, state) {
              state.maybeWhen(
                  error: (message) {
                    return ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error : $message'),
                      ),
                    );
                  },
                  orElse: () {},
                  loaded: (model) {
                    context
                        .read<GetAllProductBloc>()
                        .add(const GetAllProductEvent.getByUserId());
                    context.pop();
                  });
            },
            builder: (context, state) {
              print(state);
              return state.maybeWhen(
                orElse: () {
                  return ElevatedButton(
                      onPressed: () async {
                        final userId = await AuthLocalDataSource().getUserId();
                        final requestRestaurant = AddProductRequestModel(
                            data: Data(
                          name: _nameController!.text,
                          description: _descriptionController!.text,
                          latitude: '0',
                          longitude: '0',
                          photo: 'https://picsum.photos/200/300',
                          address: _addressController!.text,
                          userId: userId,
                        ));
                        context
                            .read<AddProductBloc>()
                            .add(AddProductEvent.add(requestRestaurant));
                      },
                      child: const Text('Submit'));
                },
              );
            },
          )
        ],
      ),
    );
  }
}
