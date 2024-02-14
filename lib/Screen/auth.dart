import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
final _firebase=FirebaseAuth.instance;
class AuthScreen extends StatefulWidget{

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen>{
  final _form=GlobalKey<FormState>();
  var _enteredEmail='';
  var _enteredPassword='';
  var _enteredUsername='';
  final TextEditingController _emailController = TextEditingController();
  var _obscureText=true;
   var _isLogin=true;
    var _isAuthenticating=false;

    @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  void _submit()async{
    final isValid=_form.currentState!.validate();
    if(!isValid){
        return;
       }
    
     _form.currentState!.save();

    try{
       setState(() {
            _isAuthenticating=true;
          });
          if(_isLogin){
             await _firebase.signInWithEmailAndPassword(email: _enteredEmail, password: _enteredPassword);
          }
          else{
                final userCredentials=await _firebase.createUserWithEmailAndPassword(email: _enteredEmail, password: _enteredPassword);
     
        await FirebaseFirestore.instance
         .collection('users')
         .doc(userCredentials.user!.uid)
         .set({
          'username':_enteredUsername,
          'email':_enteredEmail,
         });

         

          }
    }
   on FirebaseAuthException catch(error){
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
         /* SnackBar(content: Text(error.message??'Authenication Failed',style:const  TextStyle(fontSize: 15,)),
          
          )*/
          SnackBar(
                  /// need to set following properties for best effect of awesome_snackbar_content
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: 'Oh Snap!',
                    message: error.message!,

                    /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                    contentType: ContentType.failure,
                  ),
                ),

        );
         setState(() {
                  _isAuthenticating=false;
                });
    }
    
  }

  
  @override
  Widget build(BuildContext context) {
  return Scaffold(
 // resizeToAvoidBottomInset: false,
  body: Container(
     decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Background/intro_page.jpg"),
                fit: BoxFit.fill
                ),
                
              ),
    child: Center(
      child:SingleChildScrollView(
        child: Card(
                    margin: const EdgeInsets.all(20),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _form,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 30),
                            Text(
                              _isLogin ? 'Login Account' : 'Sign In Account',
                              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10,),
                            TextFormField(
                              decoration: InputDecoration(
                                icon: const Icon(Icons.email),
                                iconColor: Theme.of(context).iconTheme.color,
                                labelText: 'Email Address',
                              ),
                              autocorrect: false,
                              keyboardType: TextInputType.emailAddress,
                              textCapitalization: TextCapitalization.none,
                              cursorColor: Theme.of(context).colorScheme.onBackground,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.contains('@')) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredEmail = value!;
                              },
                            ),
                            const SizedBox(height: 20,),
                            if (!_isLogin)
                            TextFormField(
                              decoration: InputDecoration(
                                icon: const Icon(Icons.person),
                                iconColor: Theme.of(context).iconTheme.color,
                                labelText: 'Username',
                              ),
                              cursorColor: Theme.of(context).colorScheme.onBackground,
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length < 4) {
                                  return 'Please enter at least 4 characters atleast';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredUsername = value!;
                              },
                            ),
                            const SizedBox(height: 20,),
                            TextFormField(
                            obscureText: _obscureText,
                            cursorColor: Theme.of(context).colorScheme.onBackground,
                            decoration: InputDecoration(
                              iconColor: Theme.of(context).iconTheme.color,
                              icon: const Icon(Icons.lock),
                              labelText: 'Password',
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: Icon(_obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Password must be at least 6 characters long';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                            const SizedBox(height: 40),
                            if (_isAuthenticating) const CircularProgressIndicator(),
                            if (!_isAuthenticating)
                              ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                               ),
                                child: Text(
                                  _isLogin ? 'Login' : 'Sign Up',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 20),
                            if (!_isAuthenticating)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child: Text(
                                  _isLogin
                                      ? 'New here? Sign Up'
                                      : 'I already have an account',
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            if(_isLogin)
                              // Add this button to the login form
                              TextButton(
                                 onPressed: () {
                                    _resetPassword();
                                       },
                                   child: Text(
                                        'Forgot Password?',
                                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                         color:Theme.of(context).colorScheme.onBackground,
                                         ),
                                      ),
                                    ),
        
                          ],
                        ),
                      ),
                    ),
                  ),
      ),
              
      ),
    ),
  );


  }

 void _resetPassword() async {
  // Show a dialog to get the user's email address
  String? email = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Reset Password'),
      content: TextFormField(
        controller: _emailController,  // Use the controller here
        decoration: const InputDecoration(labelText: 'Enter your email'),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.trim().isEmpty || !value.contains('@')) {
            return 'Please enter a valid email address';
          }
          return null;
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, null);
          },
          child:const  Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, _emailController.text);  // Use the controller here
          },
          child:const  Text('Reset'),
        ),
      ],
    ),
  );

  // If the user entered an email, check if it exists and then send a password reset email
  if (email != null) {
    try {
      // Check if the email exists in the authentication system
      // If the email exists, send a password reset email
      await _firebase.sendPasswordResetEmail(email: email);
      // Display a success message or navigate to a success screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
         // content: Text('Password reset email sent to $email'),
         elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: 'Success',
                    message: 'Password reset email sent to $email' ,
                    contentType: ContentType.success,
                  ),
        ),
      );
    } catch (error) {
      // Display an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          //content: Text('Error sending reset password email: $error'),
          elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: 'Try Again',
                    message: 'Error sending reset password email: $error' ,
                    contentType: ContentType.failure,
                  ),
        ),
      );
    }
  }
}



}