import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  var _isLogin =true;
  var _enteredEmail = '';
  var _enteredPassword = '';

  void _submit() async {
    final isValid = _form.currentState!.validate();
    if(isValid) {
      _form.currentState!.save();

      if (_isLogin) {} else {
        try {
          final userCrededentials = await _firebase
              .createUserWithEmailAndPassword(
              email: _enteredEmail, password: _enteredPassword);
          print(userCrededentials);
        } on FirebaseAuthException catch (error){
          if(error.code == 'email-already-in-use'){
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message ?? 'Authentication failed')));
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                child: Image.asset('assets/images/chat_image.png'),
              ),
              Card(
                margin: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(padding: EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email Address'
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty || !value.contains('@')){
                              return 'Please enter valid email address';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredEmail = value!;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Password'
                          ),
                          obscureText: true,
                          validator: (value) {
                            if(value == null || value.trim().length <8){
                              return 'Please enter password atleast 8 characters';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredPassword = value!;
                          },
                        ),
                        SizedBox(height: 12,),
                        ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          ),
                          child: Text(_isLogin?'Login' : "Signup"),),
                        TextButton(
                            onPressed: (){
                              setState(() {
                                _isLogin= !_isLogin;
                              });
                            },
                            child: Text(_isLogin?"Create a Account" : 'Already I have an Account'))
                      ],
                    )),

                  ),
                ),
              )
            ],
          ),
        ),
      ),

    );
  }
}
