import 'package:flutter/material.dart';
import 'package:todo_app/src/screens/login/auth_controller.dart';
import 'package:todo_app/src/screens/todos/todo_screen.dart';

class Wrapper extends StatelessWidget {
  Wrapper({Key? key}) : super(key: key);
  final AuthController _authController = AuthController();
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _authController,
        builder: (context, Widget? w) {
          if (_authController.currentUser == null) {
            return AuthScreen(_authController);
          } else {
            return TodoScreen(_authController);
          }
        });
  }
}

class AuthScreen extends StatefulWidget {
  final AuthController auth;
  const AuthScreen(
    this.auth, {
    Key? key,
  }) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _unCon = TextEditingController(),
      _passCon = TextEditingController();
  String prompts = '';
  AuthController get _auth => widget.auth;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('"Welcome zeo todo Apps"',style: TextStyle(fontSize: 30
          ),),
        ),
        backgroundColor:  Colors.redAccent,
        toolbarHeight: 150,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(6),
              child: Form(
                key: _formKey,
                onChanged: () {
                  _formKey.currentState?.validate();
                  if (mounted) {
                    setState(() {});
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(prompts),
                    ),
                    TextFormField(
                       style: TextStyle(fontSize: 25, color: Colors.red),
                    
                      decoration: const InputDecoration(hintText: 'User'),
                      controller: _unCon,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your username';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      style: TextStyle(fontSize: 25, color: Colors.red),
                      decoration: const InputDecoration(
                        hintText: 'Pass',
                      ),
                      controller: _passCon,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your password';
                        }
                        return null;
                      },
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed:
                                  (_formKey.currentState?.validate() ?? false)
                                      ? () {
                                          String result = _auth.register(
                                              _unCon.text, _passCon.text);
                                          setState(() {
                                            prompts = result;
                                          });
                                        }
                                      : null,
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(1.0),
                                  ),
                                  primary: (_formKey.currentState?.validate() ??
                                          false)
                                      ? Colors.redAccent
                                      : Colors.redAccent),
                              child:  Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text('Sign up',style: TextStyle(fontSize: 25),),
                              ),
                            ),
                            ElevatedButton(
                              onPressed:
                                  (_formKey.currentState?.validate() ?? false)
                                      ? () {
                                          bool result = _auth.login(
                                              _unCon.text, _passCon.text);
                                          if (!result) {
                                            setState(() {
                                              prompts =
                                                  'Error logging in, username or password may be incorrect or the user has not been registered yet.';
                                            });
                                          }
                                        }
                                      : null,
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(1.0),
                                  ),
                                  primary: (_formKey.currentState?.validate() ??
                                          false)
                                      ? Colors.redAccent
                                      : Colors.redAccent),
                              child:  Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text('Log in',style: TextStyle(fontSize: 25),),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
