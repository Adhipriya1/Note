import 'package:flutter/material.dart';
import 'package:sahayak_ui/screens/login/login.dart';
import 'package:sahayak_ui/widgets/uihelper.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState()  => _AccountState();

}

class _AccountState extends State<Account> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override 
  void dispose(){
      _nameController.dispose();
      _emailController.dispose();
      _passwordController.dispose();
      super.dispose();
  } 

  void _submitForm(){
    if(_formKey.currentState!.validate()){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account created for ${_emailController.text}')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 80,),
                  Uihelper.CustomText(text: 'Sign Up', color: Color(0xFF7846EC), fontweight: FontWeight.w800, fontsize: 40),
                  SizedBox(height: 10,),
                  Uihelper.CustomImage(img: 'book.jpeg'),
                  SizedBox(height: 30,),
                  TextFormField(
                    style: TextStyle(color: Colors.black),
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      labelStyle: TextStyle(color: Colors.black),
                      hintText: 'Enter Your Full Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if(value ==null || value.isEmpty) {
                        return 'Please Enter Your Name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      hintText: 'Enter Your Email ID',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty){
                        return 'Please Enter Your Email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    style: TextStyle(
                      color: Colors.black
                    ),
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      hintText: 'Enter Your Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return 'Please Enter your email';
                      }
                      if(value.length < 6){
                        return 'Password must be more than 8 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 40,),
                  ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7846EC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                  ), 
                  child: Uihelper.CustomText(text: 'Create Account', color: Colors.white, fontweight: FontWeight.w400, fontsize: 20),
                  ),
                  SizedBox(height: 20,),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login()), 
                      );
                    },
                    child: Uihelper.CustomText(
                      text: "Log in",
                      color: Color(0xFF7846EC),
                      fontweight: FontWeight.w500,
                      fontsize: 20,
                    ),
                  ),
                  SizedBox(height: 50,),
                ],
              ),
              ),
              ),
        ),
      ),
    );
  }
}