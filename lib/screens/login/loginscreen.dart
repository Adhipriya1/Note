import 'package:flutter/material.dart';
import 'package:sahayak_ui/screens/login/login.dart';
import 'package:sahayak_ui/screens/login/account.dart';
import 'package:sahayak_ui/widgets/uihelper.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF20182F),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 40),
                  child: Row(
                    children: [
                      Uihelper.CustomText(
                    text: "Synap",
                    color: Color(0xFFD3BDE3),
                    fontweight: FontWeight.w400,
                    fontsize: 35,
                    fontFamily: 'Libre_Baskerville',
                  ),
                  Uihelper.CustomText(text: '-', color: Color(0xFF2DD8CF), fontweight: FontWeight.w500, fontsize: 50,fontFamily: 'Libre_Baskerville'),
                  Uihelper.CustomText(text: 'Note', color: Color(0xFFC22EB3), fontweight: FontWeight.w500, fontsize: 35,fontFamily: 'Libre_Baskerville'),
                    ],
                  
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/book1.png',
                    height: 210,
                    width: 200,
                    fit: BoxFit.cover,)
                  ],
                ),
                SizedBox(height: 40),
                Uihelper.CustomText(
                  text: "Write less, remember more",
                  color: Colors.white,
                  fontweight: FontWeight.w700,
                  fontsize: 16,
                ),
                SizedBox(height: 70),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Icon(Icons.circle,
                size: 10,
                color: Color(0xFFD9D9D9),),
                Icon(Icons.circle,
                size: 10,
                color: Color(0xFFD9D9D9),),
                Icon(Icons.circle,
                size: 10,
                color: Color(0xFFD9D9D9),),
                Icon(Icons.circle,
                size: 10,
                color: Color(0xFF472AF0),),
                  ],
                ),

                SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Account()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7846EC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  ),
                  child: Uihelper.CustomText(
                    text: "Create Account",
                    color: Colors.white,
                    fontweight: FontWeight.w500,
                    fontsize: 15,
                  ),
                ),
                SizedBox(height: 50),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Row(
                    
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Uihelper.CustomText(
                    text: "Have a Account?",
                    color: Color(0xFFFFFFFF),
                    fontweight: FontWeight.w500,
                    fontsize: 12,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login()), 
                      );
                    },
                    child: Uihelper.CustomText(
                      text: "Log in",
                      color: Color(0xFFADAAB1),
                      fontweight: FontWeight.w500,
                      fontsize: 12,
                    ),
                  ),
                    ],  
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}