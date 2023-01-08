import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_counter/providers/product.dart';
import 'package:shop_counter/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static String routeName = '/edit-product';
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final TextEditingController _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  Product _editedProduct =
      Product(id: '', title: '', description: '', imageUrl: '', price: 0);
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  bool _isInit = true;
  bool _isLoading = false;
  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)!.settings.arguments;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context).findById(productId as String);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          (!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    bool isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_editedProduct.id.isEmpty) {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } else {
        await Provider.of<Products>(context, listen: false)
            .editProduct(_editedProduct.id, _editedProduct);
      }
    } catch (e) {
      await showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('An error occured!'),
              content: const Text('Something went wrong'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Okay'))
              ],
            );
          });
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add product'),
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save))
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: const InputDecoration(labelText: "Title"),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field is mandatory';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: value as String,
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl,
                              price: _editedProduct.price,
                              isFavorite: _editedProduct.isFavorite);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: const InputDecoration(labelText: "Price"),
                        textInputAction: TextInputAction.next,
                        focusNode: _priceFocusNode,
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field is mandatory.';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Provide a valid number.';
                          }
                          if (double.tryParse(value)! < 0) {
                            return 'Provide price more than or equal to 0.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              isFavorite: _editedProduct.isFavorite,
                              imageUrl: _editedProduct.imageUrl,
                              price: double.parse(value as String));
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration:
                            const InputDecoration(labelText: "Description"),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'This field is mandatory.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: value as String,
                              isFavorite: _editedProduct.isFavorite,
                              imageUrl: _editedProduct.imageUrl,
                              price: _editedProduct.price);
                        },
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              margin: const EdgeInsets.only(top: 8, right: 10),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.grey)),
                              child: SizedBox(
                                  width: 100,
                                  child: _imageUrlController.text.isEmpty
                                      ? const Text('Enter a Url')
                                      : Image.network(
                                          _imageUrlController.text,
                                          fit: BoxFit.cover,
                                        )),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    labelText: "Image Url"),
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: _imageUrlController,
                                onEditingComplete: () {
                                  setState(() {});
                                },
                                focusNode: _imageUrlFocusNode,
                                onFieldSubmitted: (_) {
                                  _saveForm();
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'This field is mandatory.';
                                  }
                                  if ((!_imageUrlController.text
                                              .startsWith('http') &&
                                          !_imageUrlController.text
                                              .startsWith('https')) ||
                                      (!_imageUrlController.text
                                              .endsWith('.png') &&
                                          !_imageUrlController.text
                                              .endsWith('.jpg') &&
                                          !_imageUrlController.text
                                              .endsWith('.jpeg'))) {
                                    return 'Provide a valid image Url.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedProduct = Product(
                                      id: _editedProduct.id,
                                      title: _editedProduct.title,
                                      description: _editedProduct.description,
                                      isFavorite: _editedProduct.isFavorite,
                                      imageUrl: value as String,
                                      price: _editedProduct.price);
                                },
                              ),
                            ),
                          ]),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
