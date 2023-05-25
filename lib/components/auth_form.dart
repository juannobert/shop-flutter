import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/auth.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

enum AuthMode { signUp, login }

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  AuthMode authMode = AuthMode.login;
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  void _showDialog(String msg){
    showDialog(
      context: context, 
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreu um erro'),
        content:  Text(msg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            }, 
            child: const Text('Ok')
          )
        ],
      ));
  }
  Future<void> submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();

    Auth auth = Provider.of(context, listen: false);
    try {
      if (_isSignup()) {
        await auth.signup(_authData['email']!, _authData['password']!);
      } else {
        await auth.login(_authData['email']!, _authData['password']!);
      }
    } catch (error) {
      _showDialog(error.toString());
    }

    setState(() => _isLoading = false);
  }

  final _authData = <String, String>{'email': '', 'password': ''};

  bool _isLogin() => authMode == AuthMode.login;
  bool _isSignup() => authMode == AuthMode.signUp;
  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        authMode = AuthMode.signUp;
      } else {
        authMode = AuthMode.login;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: const EdgeInsets.all(16),
          height: _isLogin() ? 310 : 400,
          width: deviceWidth * 0.75,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (email) => _authData['email'] = email ?? '',
                  validator: (_email) {
                    String email = _email ?? '';
                    if (email.trim().isEmpty || !email.contains('@')) {
                      return 'Digite um email válido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Senha'),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  onSaved: (password) => _authData['password'] = password ?? '',
                  controller: _passwordController,
                  validator: (_senha) {
                    String senha = _senha ?? '';
                    if (senha.trim().isEmpty) {
                      return "Digite uma senha válida";
                    } else if (senha.length < 5) {
                      return 'Sua senha precisa ter 5 ou mais caracteres';
                    }
                    return null;
                  },
                ),
                if (_isSignup())
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Confirmar Senha'),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    validator: _isLogin()
                        ? null
                        : (_passwordConfirmation) {
                            String passwordConfirmation =
                                _passwordConfirmation ?? '';
                            if (passwordConfirmation !=
                                _passwordController.text) {
                              return "As senha não conferem";
                            }
                            return null;
                          },
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: submit,
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 8),
                        backgroundColor: Colors.purple),
                    child: Text(_isLogin() ? 'Entrar' : "Registrar"),
                  ),
                Spacer(),
                TextButton(
                    onPressed: () => _switchAuthMode(),
                    child: Text(
                        _isLogin() ? 'DESEJA REGISTRAR?' : 'DESEJA ENTRAR?'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
