import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iftar/services/auth.dart';
import 'package:iftar/resources/resources.dart';

class SignUp extends StatefulWidget {
  final Function toggler;
  const SignUp({Key? key, required this.toggler}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  
   final AuthService _authService = AuthService();
   final _formKey = GlobalKey<FormState>();

  // Textfields state

  String email = '';
  String password = '';
   String name = '';
  String error = '';

  bool signing = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text('إنشاء حساب'),
        // backgroundColor: Colors.blue,
        elevation: 7,
        actions: [
          TextButton.icon(
            onPressed: () {
              widget.toggler();
            },
            icon: const Icon(Icons.login, color: Colors.white70,),
            label: const Text('تسجيل الدخول', style: TextStyle(color: Colors.white)),
          )
        ],
      ),

      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
          // color: Colors.white70,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20,),
                TextFormField(
                  decoration: fieldDecor(label: 'البريد الإلكتروني', hint: 'example@dom.com'),
                  validator: (value) => value!.isEmpty ? 'أدخل بريدا' : null,
                  onChanged: (value) {
                    setState(() {
                      email = value.trim();
                    });
                  },
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  decoration: fieldDecor(label: 'كلمة المرور'),
                  obscureText: true,
                  validator: (value) => value!.length < 4 ? 'لا تقبل كلمة سر أقصر من 4 أحرف' : null,
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  textDirection: TextDirection.rtl,
                  decoration: fieldDecor(label: 'الاسم',).copyWith(hintTextDirection: TextDirection.rtl),
                  validator: (value) => value!.isEmpty ? 'أدخل اسمك' : null,
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                (error.isEmpty)? const SizedBox(height: 0,) : const SizedBox(height: 20,),
                (error.isEmpty)? const SizedBox(height: 0,) : Text(
                  error,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
                const SizedBox(height: 20,),
                signing? const Loading() : ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()){
                        setState(() => signing = true);
                        try{
                                await _authService.signUpWithEmail(name, email, password);
                        } on FirebaseAuthException catch (e) {
                          print('*************\n${e.code}\n***********');
                          String specialError = '';
                                if (e.code == 'email-already-in-use'){
                                  specialError = 'هذا البريد مربوط بحساب في التطبيق';
                                } else if (e.code == 'invalid-email') {
                                  specialError = 'أدخل بريدا إلكترونيا صحيحا';
                                } else if(e.code == 'weak-password'){
                                  specialError = 'كلمة سر ضعيفة، قوها يزيادة طولها';
                                }
                          setState(() {
                            error = (specialError.isNotEmpty)
                                      ? specialError
                                      : 'عذرا لم ينجح إنشاء حسابك';
                            signing = false;
                          });
                        }
                        
                      }
                    },
                    // style: ButtonStyle(),
                    child: const Text(
                      'أنشئ حسابك',
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  )
              ],
            ),
          )
        ),
      ),
    );
  }
}