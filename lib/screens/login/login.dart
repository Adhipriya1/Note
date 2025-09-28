import 'package:flutter/material.dart';
import 'package:sahayak_ui/screens/bottomnav.dart';
import 'package:sahayak_ui/widgets/uihelper.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30,),
              const CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xFF472AF0),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(height: 20),
              Uihelper.CustomText(text: 'Sign In', color: Color(0xFF7946ED), fontweight: FontWeight.w800, fontsize: 22),
              SizedBox(height: 30),
              Uihelper.CustomTextField(controller: TextEditingController()),
              const SizedBox(height: 20),
              Uihelper.CustomPasswordField(controller: TextEditingController()),
              const SizedBox(height: 50),
              Uihelper.CustomButton(() {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavScreen(),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}