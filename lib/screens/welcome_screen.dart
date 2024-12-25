import '../components/rounded_button.dart';
import '../screens/login_screen.dart';
import '../screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {

  AnimationController? controller;
  Animation? animation;

  @override
  void initState() {

      super.initState();
        controller = AnimationController(
          duration: Duration(seconds: 1),
          vsync: this,
      );

      animation = CurvedAnimation(parent: controller!, curve: Curves.decelerate);

      controller!.forward();
      
      controller!.addListener(() {
        setState(() {
          
        });
      });
  }

  void dispose (){
    controller!.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: animation!.value * 60
                  ),
                ),

                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Flash Chat',
                      textStyle: TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.black
                      ),
                      speed: Duration(milliseconds: 200),
                    ),
                  ],
                )
              ],
            ),

            SizedBox(
              height: 48.0,
            ),

            RoundedButton(
              colour: Colors.lightBlueAccent, 
              title: 'Iniciar sesion', 
              onPressed: () {
              Navigator.pushNamed(context, LoginScreen.id);
            }),


            RoundedButton(
              colour: Colors.blueAccent,
              title: 'Registro', 
              onPressed: () {
              Navigator.pushNamed(context, RegistrationScreen.id);
            }),
           
          ],
        ),
      ),
    );
  }
}
