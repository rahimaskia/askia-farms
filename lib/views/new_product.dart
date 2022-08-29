import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/product.dart';
import '../widgets/custom_snackbar.dart';

class NewProduct extends StatefulWidget {
  const NewProduct({Key? key}) : super(key: key);

  @override
  _NewProductState createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  final _categories = ['Egg', 'Fowl', 'Manure'];

  late String _category = _categories[0];
  final _formKey = GlobalKey<FormState>();
  final _dropdownFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isProgress = false;
  String? _error;
  List<XFile> images = [];
  String title = 'New Product';

  List<String> imageUrls = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            if (_isProgress)
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                ),
              ),
            const SizedBox(height: 30.0),
            Container(child: _buildForm())
          ]),
        ));
  }

  Widget _buildForm() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (_error != null && _error!.isNotEmpty && !_isProgress)
                  Container(
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red, fontSize: 17),
                      softWrap: true,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 20),
                  ),
                TextFormField(
                  controller: _nameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Product name'),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Product name is required';
                    } else if (value.length < 3) {
                      return 'Invalid name for product';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15.0),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  maxLines: null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: 'Product price',
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Price is required';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Invalid value for product price';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15.0,
                ),
                DropdownButtonFormField(
                  key: _dropdownFormKey,
                  decoration: const InputDecoration(
                    labelText: 'Product type',
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _category = value!;
                    });
                  },
                  validator: (val) {
                    if (_category.isEmpty) {
                      return 'Product type is required';
                    }
                    return null;
                  },
                  items: _categories
                      .map((e) => DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          ))
                      .toList(),
                ),
                Container(
                  height: images.length > 3 ? 380 : 180,
                  child: buildGridView(),
                  margin: const EdgeInsets.only(top: 15),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  onPressed: () => submitForm(),
                  child: const Text('Publish'),
                )
              ],
            )));
  }

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate() && images.isNotEmpty) {
      setState(() {
        _isProgress = true;
      });
      imageUrls =
          await uploadImages(_nameController.text.replaceAll(' ', '_'), images);

      final product = Product(
          name: _nameController.text,
          type: _category,
          unitCost: double.tryParse(_priceController.text) ?? 0,
          images: imageUrls,
          stock: 1);
      await FirebaseFirestore.instance
          .collection('products')
          .add(product.toMap())
          .then((value) {
        setState(() {
          _isProgress = false;
          _priceController.text = '';
          _nameController.text = '';
          images.clear();
          imageUrls.clear();
        });
        CustomSnackBar.snackBar(context,
            text: 'Product has been published', message: Message.success);
      }).onError((error, stackTrace) {
        setState(() {
          _isProgress = false;
          error.toString();
        });
      });
    } else {
      final msg = images.isEmpty
          ? 'No images selected'
          : 'Please enter all product details';
      CustomSnackBar.snackBar(context, text: msg, message: Message.error);
    }
  }

  Widget buildGridView() {
    return Column(
      children: [
        Expanded(
          child: GridView.count(
            physics: const ClampingScrollPhysics(),
            crossAxisCount: 3,
            children: uploadedImages(),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => loadAssets(),
          icon: const Icon(Icons.add_a_photo),
          label: Text(images.length == 0 ? 'Add images' : 'Add more images'),
        )
      ],
    );
  }

  Future<List<String>> uploadImages(String fileName, List<XFile> assets) async {
    final uploadUrls = <String>[];

    await Future.wait(
        assets.map((XFile asset) async {
          final byteData = await asset.readAsBytes();
          final imageData = byteData.buffer.asUint8List();
          final i = Random().nextInt(20000);
          final name = fileName + '$i';
          final reference =
              FirebaseStorage.instance.ref().child('products/images/$name');
          final uploadTask = reference.putData(imageData);
          TaskSnapshot storageTaskSnapshot;

          final snapshot = await uploadTask;

          storageTaskSnapshot = snapshot;
          final downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
          uploadUrls.add(downloadUrl);
        }),
        eagerError: true,
        cleanUp: (_) {
          debugPrint('eager cleaned up');
        });

    return uploadUrls;
  }

  List<Widget> uploadedImages() {
    final list = List.generate(images.length, (index) {
      final asset = images[index].path;
      return Stack(
        alignment: Alignment.topRight,
        children: [
          Card(
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(18)),
              child: Image.file(
                File(asset),
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width * 0.28,
                height: 180,
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                images.removeAt(index);
                setState(() {
                  images = images;
                });
              },
              icon: const Icon(
                Icons.clear,
                size: 20,
              ))
        ],
      );
    });
    return list;
  }

  Future<void> loadAssets() async {
    List<XFile>? resultList;
    String? _err;

    try {
      final picker = ImagePicker();
      resultList = await picker.pickMultiImage();
    } on Exception catch (e) {
      _err = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList!;
      _error = _err;
    });
  }

  // Future<void> saveImage(Asset asset, String name) async {
  //   ByteData byteData =
  //       await asset.getByteData(); // requestOriginal is being deprecated
  //   final imageData = byteData.buffer.asUint8List();

  //   FirebaseStorage storage = FirebaseStorage.instance;
  //   final folder = _nameController.text;
  //   Reference ref = storage.ref().child("products/images/$folder/$name");
  //   final task = ref.putData(imageData);
  //   task.then((task) async {
  //     final url = await task.ref.getDownloadURL();
  //     imageUrls.add(url);
  //     setState(() {
  //       imageUrls = imageUrls;
  //     });
  //   });
  // }
}
