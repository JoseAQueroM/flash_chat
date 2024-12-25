import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_prueba/components/text_field.dart';
import 'package:firebase_prueba/screens/chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../components/rounded_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  String? email;
  String? password;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextFieldInputs(
                  textInput: 'Ingresa tu email',
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  isPassword: false),
              SizedBox(
                height: 8.0,
              ),
              TextFieldInputs(
                  textInput: 'Ingresa tu contraseña',
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                  isPassword: true),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  colour: Colors.lightBlue,
                  title: 'Ingresar',
                  onPressed: () async {
                    if (email != null &&
                        email!.isNotEmpty &&
                        password != null &&
                        password!.isNotEmpty) {
                      try {
                        
                        final userCredential =
                            await _auth.signInWithEmailAndPassword(
                                email: email!, password: password!);
                        if (userCredential.user != null) {
                          setState(() {
                          showSpinner = true;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.green,
                            content: Text(
                              'Has iniciado sesion correctamente',
                              textAlign: TextAlign.center,
                            ),
                            duration: Duration(seconds: 2),
                          ));

                          Future.delayed(Duration(seconds: 2), () {
                            showSpinner = false;
                            Navigator.pushNamed(context, ChatScreen.id);
                          });
                        }
                        print(userCredential.user);
                      } catch (e) {
                        print(e);
                      }
                    } else {
                      showSpinner = false;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.redAccent,
                        content:
                            Center(child: Text('Por favor ingrese los datos')),
                        duration: Duration(seconds: 2),
                      ));
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
