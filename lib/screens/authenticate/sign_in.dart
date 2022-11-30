import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iftar/services/auth.dart';
import 'package:iftar/resources/resources.dart';

class SignIn extends StatefulWidget {
  final Function toggler;
  const SignIn({Key? key, required this.toggler}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  // Textfields state
  String email = '';
  String password = '';
  String error = '';

  bool signing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text('تسجيل الدخول'),
        // backgroundColor: Colors.blue,
        elevation: 7,
        actions: [
          TextButton.icon(
            onPressed: () {
              widget.toggler();
            },
            icon: const Icon(
              Icons.person_add,
              color: Colors.white70,
            ),
            label:
                const Text('إنشاء حساب', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: Center(
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
            // color: Colors.white70,
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: fieldDecor(label: 'البريد الإلكتروني', hint: 'example@dom.com'),
                    textDirection: TextDirection.ltr,
                    validator: (value) => value!.isEmpty ? 'أدخل بريدا' : null,
                    onChanged: (value) {
                      setState(() {
                        email = value.trim();
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: fieldDecor(label: 'كلمة المرور'),
                    textDirection: TextDirection.ltr,
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: (error.isEmpty) ? 0 : 20,
                  ),
                  Center(
                    child: (error.isEmpty)
                        ? const SizedBox(
                            height: 0,
                          )
                        : Text(
                            error,
                            style:
                                const TextStyle(color: Colors.red, fontSize: 12),
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  signing
                      ? const Loading()
                      : ElevatedButton(
                          style: const ButtonStyle(),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => signing = true);
                              try {
                                await _authService.signInWithEmail(
                                    email, password);
                              } on FirebaseAuthException catch (e) {
                                print('*************\n${e.code}\n***********');
                                String specialError = '';
                                if (e.code == 'user-not-found') {
                                  specialError = 'هذا المستخدم غير مسجل';
                                } else if (e.code == 'wrong-password') {
                                  specialError = 'كلمة سر خاطئة';
                                }
                                setState(() {
                                  error = (specialError.isNotEmpty)
                                      ? specialError
                                      : 'عذرا لم تنجح عملية الدخول';
                                  signing = false;
                                });
                              }
                            }
                          },
                          // style: ButtonStyle(),
                          child: const Text(
                            'سجّل دخولك',
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    child: TextButton.icon(
                        onPressed: () {
                          _authService.signInWithGoogle();
                        },
                        label: const Text('ادخل بحساب جوجل', style: TextStyle(fontSize: 18),),
                        icon: CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.g_mobiledata, size: 40, color: Colors.deepOrange[400],)),
                      ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
