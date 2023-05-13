import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shop/models/product.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _imgUrlController = TextEditingController();
  final _imageFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _formData = <String,Object>{};

  @override
  void initState() {
    super.initState();
    _imageFocus.addListener(atualizar);
  }

  @override
  void dispose() {
    super.dispose();
    _imageFocus.removeListener(atualizar);
  }

  void atualizar() {
    setState(() {}); //Atualiza o estado da aplicação fazendo a imagem aparecer
  }

    bool _isValidImageUrl(String url){
      bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
      bool isValidPath = url.endsWith('.png') || url.endsWith('.jpg') || url.endsWith('.jpeg');

    return isValidPath & isValidUrl;
  }

  void _submitForm(){
    final isValid = _formKey.currentState?.validate() ?? false;

    if(!isValid){
      return;
    }


    _formKey.currentState?.save();
    final newProduct = Product(
      id: Random().nextInt(99999).toString(), 
      title: _formData['title'] as String, 
      description: _formData['description'] as String, 
      imageUrl: _formData['imgUrl'] as String, 
      price: _formData['price'] as double
    );

    print(newProduct.id);
    print(newProduct.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulário de Produto"),
        actions: [
          IconButton(
            onPressed: () => _submitForm(), 
            icon: const Icon(Icons.save)
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(label: Text('Nome')),
                textInputAction: TextInputAction.next,
                onSaved: (title) => _formData['title'] = title as String,
                validator: (_title){
                  final title = _title ?? '';
                  if(title.trim().isEmpty){
                    return "O nome é obrigatorio";
                  }

                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(label: Text('Preço')),
                textInputAction: TextInputAction.next,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onSaved: (price) => _formData['price'] = double.parse(price as String),
                 validator: (_price){
                  String priceString = _price ?? '';
                  double price = double.tryParse(priceString) ?? -1;
                  if(price < 0){
                    return "Informe um preço válido";
                  }
                 

                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(label: Text('Descrição')),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onSaved: (description) => _formData['description'] = description as String,
                validator: (_description){
                  final description = _description ?? '';
                  if(description.trim().isEmpty){
                    return "A descrição é obrigatoria";
                  }
                  if(description.trim().length < 5){
                    return "A descrição precisa ter mais de 5 caracteres";
                  }

                  return null;
                },

              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(label: Text('Url')),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.url,
                        controller: _imgUrlController,
                        focusNode: _imageFocus,
                        onFieldSubmitted: (_) => _submitForm(),
                        onSaved: (imgUrl) => _formData['imgUrl'] = imgUrl as String,
                        /*validator: (url){
                          if(!_isValidImageUrl(url!)){
                            return "Informe uma URL válida";

                          }

                          return null;
                       },*/

                      ),
                    ),
                    Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1)),
                        alignment: Alignment.center,
                        child: _imgUrlController.text.isNotEmpty
                            ? Image.network(
                                _imgUrlController.text,
                                fit: BoxFit.cover,
                              )
                            : const Text("Informe a url"))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
