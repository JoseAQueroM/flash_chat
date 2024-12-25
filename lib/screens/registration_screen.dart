import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_prueba/screens/chat_screen.dart';
import '../components/rounded_button.dart';
import '../components/text_field.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  String? email;
  String? password;

  @override
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
                  textInput: 'Escribe un email',
                  isPassword: false,
                  onChanged: (value) {
                    email = value;
                  }),
              SizedBox(
                height: 8.0,
              ),
              TextFieldInputs(
                  textInput: 'Escribe una contraseña',
                  isPassword: true,
                  onChanged: (value) {
                    password = value;
                  }),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  colour: Colors.blueAccent,
                  title: 'Registrar',
                  onPressed: () async {
                    if (email != null &&
                        email!.isNotEmpty &&
                        password != null &&
                        password!.isNotEmpty) {
                      setState(() {
                        showSpinner = true;
                      });

                      try {
                        final userCredential =
                            await _auth.createUserWithEmailAndPassword(
                                email: email!, password: password!);
                        if (userCredential.user != null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.green,
                            content: Text(
                              'Cuenta creada correctamente',
                              textAlign: TextAlign.center,
                            ),
                            duration: Duration(seconds: 2),
                          ));

                          Future.delayed(Duration(seconds: 2), () {
                            setState(() {
                              showSpinner = false;
                            });
                            Navigator.pushNamed(context, ChatScreen.id);
                          });
                        }
                        print(userCredential.user);
                      } catch (e) {
                        print(e);
                      }
                    } else {
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
