import 'package:flutter/material.dart';
import 'package:personalmanager/services/auth.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  
  static const String id = 'login_screen';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  bool signInForm;
  @override
  void initState() {
    super.initState();
    signInForm = true;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context);
    return WillPopScope(
      onWillPop: () async {
        if (!signInForm) {
          setState(() {
            signInForm = true;
          });
          return false;
        } else {
          return true;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color(0xffbeebe9),
                Color(0xfff4dada),
                Color(0xffffb6b9),
                Color(0xfff6eec7)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          ),
        ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            key: _key,
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: kToolbarHeight),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      width: 80.0,
                      height: 80.0,
                    ),
                    SizedBox(height: 30.0),
                    AnimatedSwitcher(
                      child: signInForm ? LoginForm(showError: (message) => showMessage(message: message),) : SignUpForm(showError: (message) => showMessage(message: message),),
                      duration: Duration(milliseconds: 200),
                    ),
                    SizedBox(height: 30.0),
//                    user.status == Status.Authenticating ?
//                    Center(child: CircularProgressIndicator(backgroundColor: Colors.white,)) :
//                    RaisedButton(
//                      textColor: Colors.white,
//                      color: Colors.red,
//                      child: Text("Continue with Google"),
//                      onPressed: () async {
//                        if (!await user.signInWithGoogle())
//                          showMessage();
//                      },
//                    ),
//                    SizedBox(height: 20.0),
                    OutlineButton(
                      textColor: Colors.black,
                      child: signInForm
                          ? Text(
                        "New User? Sign Up Here",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      )
                          : Icon(Icons.arrow_back),
                      onPressed: () {
                        setState(() {
                          signInForm = !signInForm;
                        });
                      },
                      color: Colors.white,
                      borderSide: BorderSide(color: Colors.white),
                      highlightColor: Colors.white,
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
  void showMessage({String message = "Something is wrong"}) {
    _key.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}

class LoginForm extends StatefulWidget {
  final Function showError;

  LoginForm({Key key, this.showError}) : super(key: key);
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final FocusNode passwordField = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _email;
  TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context);
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Text(
              "Login",
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              // ignore: missing_return
              validator: (val) {
                if (val.isEmpty) {
                  return "Email is required";
                }
              },
              controller: _email,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "email address"),
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(passwordField);
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              // ignore: missing_return
              validator: (val) {
                if (val.isEmpty) return "password is required";
              },
              obscureText: true,
              controller: _password,
              focusNode: passwordField,
              decoration: InputDecoration(labelText: "password"),
            ),
            SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
              ),
              child: user.status == Status.Authenticating ?
              Center(child: CircularProgressIndicator()) : RaisedButton(
                textColor: Colors.white,
                child: Text("Login"),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    if(!await user.signIn(_email.text, _password.text))
                      widget.showError();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  final Function showError;

  const SignUpForm({Key key, this.showError}) : super(key: key);
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final FocusNode passwordField = FocusNode();
  final FocusNode confirmPasswordField = FocusNode();
  TextEditingController _email;
  TextEditingController _password;
  TextEditingController _confirmPassword;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context);
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Text(
              "Sign up",
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _email,
              // ignore: missing_return
              validator: (val) {
                if (val.isEmpty) return "Email is required";
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "email address"),
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(passwordField);
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              // ignore: missing_return
              validator: (val) {
                if (val.isEmpty) return "Password is required";
              },
              obscureText: true,
              controller: _password,
              focusNode: passwordField,
              decoration: InputDecoration(labelText: "password"),
              onEditingComplete: () =>
                  FocusScope.of(context).requestFocus(confirmPasswordField),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              obscureText: true,
              controller: _confirmPassword,
              // ignore: missing_return
              validator: (val) {
                if (val.isEmpty) return "Confirm password is required";
              },
              focusNode: confirmPasswordField,
              decoration: InputDecoration(labelText: "confirm password"),
            ),
            SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 32.0,
              ),
              child: user.status == Status.Authenticating ?
              Center(child: CircularProgressIndicator()) : RaisedButton(
                textColor: Colors.white,
                child: Text("Create Account"),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    if (_confirmPassword.text == _password.text) {
                      if(!await user.signUp(_email.text, _password.text))
                        widget.showError();
                    }
                    else
                      widget.showError("Password and confirm password does not match");
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
