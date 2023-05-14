import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';

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

  //è chamado quando o estado de uma depedência muda
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(_formData.isEmpty){
      final arg = ModalRoute.of(context)?.settings.arguments;

      if(arg != null){
        final product = arg as Product;

        _formData['id'] = product.id as String;
        _formData['title'] = product.title;
        _formData['description'] = product.description;
        _formData['imgUrl'] = product.imageUrl;
        _formData['price'] = product.price;

        _imgUrlController.text = _formData['imgUrl'] as String;

      }
    }
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
    
    Provider.of<ProductList>(context,listen: false).addProductFromData(_formData);
    Navigator.of(context).pop();
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
                initialValue: _formData['title']?.toString(),
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
                initialValue:  _formData['price']?.toString(),
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
                initialValue:  _formData['description']?.toString(),
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
