import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bangunin_id/services/auth.dart';
import 'package:bangunin_id/shared/decorations.dart';
import 'package:bangunin_id/screens/transition/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({
    @required this.toggleView,
  });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool _hidePass = true;

  //text field state
  String email = '';
  String password = '';
  String error = '';

  Future<String> _getEmailFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final lastEmail = prefs.getString('lastEmail');
    if (lastEmail == null) {
      return null;
    } else {
      return lastEmail;
    }
  }

  Future<void> _removeEmail() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastEmail', null);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return LoadingScreen();
    } else {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: transparentAppbarAndNavbar(),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: AppColors().accent1,
          body: Container(
            decoration: loginBground(),
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      loginLogo(),
                      SizedBox(height: 40.0),
                      TextFormField(
                        decoration:
                            inputBoxBorder().copyWith(hintText: 'Email'),
                        validator: (val) => (val.isEmpty | !val.contains('@'))
                            ? 'Masukkan email yang valid'
                            : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: inputBoxBorder().copyWith(
                            hintText: 'Password',
                            suffixIcon: togglePassVisibility()),
                        obscureText: _hidePass,
                        validator: (val) => val.length < 6
                            ? 'Masukkan password (6 huruf atau lebih)'
                            : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      SizedBox(height: 10.0),
                      InkWell(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Lupa password?',
                            style: TextStyle(
                              color: AppColors().accent2,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () async {
                          //Belum jadi, harusnya ada screen ganti password
                        },
                      ),
                      SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          color: AppColors().primary,
                          child: Text(
                            'Masuk',
                            style: TextStyle(color: AppColors().accent1),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                loading = true;
                              });
                              dynamic result =
                                  await _auth.signInWithEmail(email, password);
                              if (result == null) {
                                setState(() {
                                  error =
                                      'Login tidak berhasil. Periksa kembali email, password, dan koneksi internet anda.';
                                  loading = false;
                                });
                              }
                            }
                          },
                        ),
                      ),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                      SizedBox(height: 20.0),
                      InkWell(
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Belum memiliki akun? ",
                                style: TextStyle(
                                  color: AppColors().accent2,
                                ),
                              ),
                              Text(
                                "Daftar di sini.",
                                style: TextStyle(
                                  color: AppColors().accent2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          widget.toggleView();
                        },
                      ),
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

  GestureDetector togglePassVisibility() {
    return GestureDetector(
      child: Icon(
        (_hidePass ? Icons.visibility : Icons.visibility_off),
        color: Colors.grey,
      ),
      onTap: () {
        setState(() {
          _hidePass = !_hidePass;
        });
      },
    );
  }
}
