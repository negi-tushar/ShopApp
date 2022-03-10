import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/providers/products_provider.dart';

class EditProducts extends StatefulWidget {
  const EditProducts({Key? key}) : super(key: key);

  static String id = 'EditProducts';
  @override
  _EditProductsState createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageController = TextEditingController();
  final _imageUrlFocus = FocusNode();
  final _form = GlobalKey<FormState>();
  var _init = true;
  bool _isLoading = false;
  var _editedValue = Product(
    id: '',
    title: '',
    description: '',
    imageUrl: '',
    price: 0,
  );
  var _initValues = {
    'title': '',
    'description': '',
    'imageUrl': '',
    'price': ''
  };

  @override
  void initState() {
    _imageUrlFocus.addListener(_updateUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_init) {
      final productID = ModalRoute.of(context)?.settings.arguments as String;
      if (productID != null) {
        _editedValue =
            Provider.of<Products>(context, listen: false).findById(productID);
        _initValues = {
          'title': _editedValue.title,
          'description': _editedValue.description,
          'price': _editedValue.price.toString(),
        };
        _imageController.text = _editedValue.imageUrl;
      }
    }
    _init = false;
    super.didChangeDependencies();
    // print('didChangeDependencies');
  }

  void _updateUrl() {
    if (!_imageUrlFocus.hasFocus) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageUrlFocus.removeListener(_updateUrl);
    _descriptionFocus.dispose();
    _priceFocus.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    var validator = _form.currentState?.validate();
    if (!validator!) {
      return;
    }

    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedValue.id != '') {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedValue.id, _editedValue);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedValue);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An Error Occured'),
            content: Text(error.toString()),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  // print('im here');
                },
                child: const Text('Okay'),
              ),
            ],
          ),
        );
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.pop(context);
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        actions: [
          IconButton(
            onPressed: () {
              _saveForm();
            },
            icon: const Icon(
              Icons.save,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              ),
            )
          : Container(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _editedValue.title,
                      decoration: const InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter a Title";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _editedValue = Product(
                            id: _editedValue.id,
                            title: newValue!,
                            description: _editedValue.description,
                            imageUrl: _editedValue.imageUrl,
                            price: _editedValue.price,
                            isFavourite: _editedValue.isFavourite);
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocus);
                      },
                    ),
                    TextFormField(
                      initialValue: _editedValue.price.toString(),
                      decoration: const InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocus,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Pleae Enter a valid Price';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a Price greater than zero';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _editedValue = Product(
                          id: _editedValue.id,
                          title: _editedValue.title,
                          description: _editedValue.description,
                          imageUrl: _editedValue.imageUrl,
                          price: double.parse(newValue!),
                          isFavourite: _editedValue.isFavourite,
                        );
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionFocus);
                      },
                    ),
                    TextFormField(
                      initialValue: _editedValue.description,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocus,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Description';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _editedValue = Product(
                            id: _editedValue.id,
                            title: _editedValue.title,
                            description: newValue!,
                            imageUrl: _editedValue.imageUrl,
                            price: _editedValue.price,
                            isFavourite: _editedValue.isFavourite);
                      },
                    ),
                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(
                            top: 10,
                            right: 5,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.0,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageController.text.isEmpty
                              ? const Text('Enter URL')
                              : FittedBox(
                                  child: Image.network(_imageController.text,
                                      fit: BoxFit.cover),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            controller: _imageController,
                            focusNode: _imageUrlFocus,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Image Url';
                              }
                              if (!value.startsWith('http://') &&
                                  !value.startsWith('https://')) {
                                return 'Please enter a valid Email address';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _editedValue = Product(
                                  id: _editedValue.id,
                                  title: _editedValue.title,
                                  description: _editedValue.description,
                                  imageUrl: newValue!,
                                  price: _editedValue.price,
                                  isFavourite: _editedValue.isFavourite);
                            },
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
