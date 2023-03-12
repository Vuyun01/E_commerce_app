import 'package:ec_shop_app/providers/product.dart';
import 'package:ec_shop_app/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/edit-product';
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageURLFocusNode = FocusNode();
  final _imageURLController = TextEditingController();

  final _formState =
      GlobalKey<FormState>(); //create a Global key of form state object

  var _newProduct =
      Product(id: '', name: '', description: '', price: 0, imageURL: '');

  var _initData = {
    'id': '',
    'title': '',
    'price': '',
    'description': '',
  };
  var _firstInitData = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageURLFocusNode.addListener(_updateScreen);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_firstInitData) {
      final _getProduct = ModalRoute.of(context)?.settings.arguments;
      if (_getProduct != null) {
        _newProduct = _getProduct as Product;
        _initData = {
          'id': _newProduct.id,
          'title': _newProduct.name,
          'price': _newProduct.price.toString(),
          'description': _newProduct.description,
        };
        _imageURLController.text = _newProduct.imageURL;
        print('Data is set');
      }
    }
    _firstInitData = false;
    super.didChangeDependencies();
  }

  void _updateScreen() {
    if (!_imageURLFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveFormData() async {
    var check = _formState.currentState?.validate();
    var navigator = Navigator.of(context);
    final data = Provider.of<Products>(context, listen: false);
    if (check == false) {
      return;
    }
    _formState.currentState?.save(); // save the form data
    setState(() {
      _isLoading = true;
    });
    if (_newProduct.id.isNotEmpty) {
      // print('_current id: ${_newProduct.id}');
      await data.updateProduct(_newProduct);
    } else {
      try {
        await data.addProduct(Product(
            id: data.getProducts.length.toString(),
            name: _newProduct.name,
            description: _newProduct.description,
            price: _newProduct.price,
            imageURL: _newProduct.imageURL));
      } catch (error) {
        await showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text('An error occurred'),
                  content: const Text('Something went wrong.'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'))
                  ],
                ));
      }
    }
    setState(() {
      _isLoading = false;
    });
    navigator.pop();
  }

  @override
  void dispose() {
    _imageURLFocusNode.removeListener(_updateScreen);
    _imageURLController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print('Rebuild');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit product'),
        actions: [
          IconButton(onPressed: _saveFormData, icon: const Icon(Icons.save))
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Padding(
              padding: const EdgeInsets.all(8),
              child: Form(
                key: _formState,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _initData['title'],
                        decoration: const InputDecoration(label: Text('Title')),
                        textInputAction: TextInputAction.next,
                        autofocus: true,
                        validator: ((value) {
                          if (value!.isEmpty) {
                            return "Please input a title";
                          }
                          if (value.length < 5) {
                            return "Please input a title at least 5 characters long";
                          }
                          return null;
                        }),
                        onSaved: ((newValue) {
                          _newProduct = Product(
                              id: _newProduct.id,
                              name: newValue ?? '',
                              description: _newProduct.description,
                              price: _newProduct.price,
                              imageURL: _newProduct.imageURL,
                              isFavorite: _newProduct.isFavorite);
                        }),
                      ),
                      TextFormField(
                        initialValue: _initData['price'],
                        decoration: const InputDecoration(label: Text('Price')),
                        textInputAction: TextInputAction.next,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        onSaved: ((newValue) {
                          _newProduct = Product(
                              id: _newProduct.id,
                              name: _newProduct.name,
                              description: _newProduct.description,
                              price: double.parse((newValue as String)),
                              imageURL: _newProduct.imageURL,
                              isFavorite: _newProduct.isFavorite);
                        }),
                        validator: ((value) {
                          if (value!.isEmpty) {
                            return "Please set a price";
                          }
                          if (double.tryParse(value) == null) {
                            return "Please enter a correct number";
                          }
                          if (double.tryParse(value)! <= 0) {
                            return "Please enter a number greater than 0";
                          }
                          return null;
                        }),
                      ),
                      TextFormField(
                        initialValue: _initData['description'],
                        decoration:
                            const InputDecoration(label: Text('Description')),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        onSaved: ((newValue) {
                          _newProduct = Product(
                              id: _newProduct.id,
                              name: _newProduct.name,
                              description: newValue ?? '',
                              price: _newProduct.price,
                              imageURL: _newProduct.imageURL,
                              isFavorite: _newProduct.isFavorite);
                        }),
                        validator: ((value) {
                          if (value!.isEmpty) {
                            return "Please input a description for the new product";
                          }
                          if (value.length < 5) {
                            return "The description must be at least 5 characters long";
                          }
                          return null;
                        }),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                              width: 150,
                              height: 150,
                              margin: const EdgeInsets.only(top: 20, right: 10),
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  border: Border.all(
                                      width: 2, color: Colors.black26)),
                              child: _imageURLController.text.isEmpty
                                  ? Center(
                                      child: Text(
                                      'Image URL',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ))
                                  : Image.network(
                                      _imageURLController.text,
                                      fit: BoxFit.fill,
                                    )),
                          Expanded(
                              child: TextFormField(
                            decoration:
                                const InputDecoration(label: Text('Image URL')),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.url,
                            controller: _imageURLController,
                            focusNode: _imageURLFocusNode,
                            onEditingComplete: () {
                              _imageURLFocusNode.unfocus();
                            },
                            onFieldSubmitted: (_) {
                              _saveFormData();
                            },
                            onSaved: ((newValue) {
                              _newProduct = Product(
                                  id: _newProduct.id,
                                  name: _newProduct.name,
                                  description: _newProduct.description,
                                  price: _newProduct.price,
                                  imageURL: newValue ?? '',
                                  isFavorite: _newProduct.isFavorite);
                            }),
                            validator: ((value) {
                              if (value!.isEmpty) {
                                return "Please enter a image URL.";
                              }
                              if (!value.startsWith('https://') ||
                                  !value.startsWith('http://') &&
                                      !value.endsWith('.jpg') &&
                                      !value.endsWith('.png') &&
                                      !value.endsWith('.jpeg')) {
                                return "Please enter a correct image URL";
                              }
                              return null;
                            }),
                          ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
