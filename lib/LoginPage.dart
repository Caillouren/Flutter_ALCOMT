import 'package:alcomt_puro/MenuPage.dart';
import 'package:flutter/material.dart';
import 'package:alcomt_puro/cadastro_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:alcomt_puro/recuperarSenhaPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.auth}) : super(key: key);

  final FirebaseAuth auth;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _email = '';
  String _password = '';

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    try {
      await widget.auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => MenuPage(auth: FirebaseAuth.instance),
      ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('Nenhum usuário encontrado para esse e-mail.');
      } else if (e.code == 'wrong-password') {
        print('Senha incorreta.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset('assets/logo_alcomt.png'),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'E-mail',
                      hintText: 'nome@email.com',
                      labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),                      
                      filled: true, // ativa o background
                      fillColor: Colors.white.withOpacity(
                          0.2), // define o background da caixa de texto com transparência
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),                    
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um e-mail válido.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  SizedBox(height: 12),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      hintText: 'Digite sua senha',
                      labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),                      
                      filled: true, // ativa o background
                      fillColor: Colors.white.withOpacity(
                          0.2), // define o background da caixa de texto com transparência
                    ),
                    obscureText: true,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),                    
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma senha válida.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          var scaffoldContext = ScaffoldMessenger.of(context);
                          await widget.auth.signInWithEmailAndPassword(
                            email: _email,
                            password: _password,
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MenuPage(auth: FirebaseAuth.instance)),
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Usuário não encontrado')),
                            );
                          } else if (e.code == 'wrong-password') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Senha incorreta')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Erro ao realizar login')),
                            );
                          }
                        } catch (e) {
                          print(e);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erro ao realizar login')),
                          );
                        }
                      }
                    },
                    child: Text(
                      'ENTRAR',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 15),
                      ),
                      textStyle: MaterialStateProperty.all(
                        TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          //botão Recuperar Senha
                          onPressed: () {
                            Navigator.push(
                              //Navega para a página
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RecuperarSenha()),
                            );
                          },
                          child: Text(
                            'Recuperar a Senha',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              //Navega para a página
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CadastroPage()),
                            );
                          },
                          child: Text(
                            'Cadastrar',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
