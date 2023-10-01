import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/common_widgets/common_background.dart';
import 'package:weather_app/common_widgets/common_button.dart';
import 'package:weather_app/helper/authentication_helper.dart';
import 'package:weather_app/utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  String? email;
  String? password;
  bool showSpinner = false;
  bool obscureTextValue = true;

  bool isLogin = true;

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Email',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            onChanged: (value) {
              email = value;
            },
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Password',
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            onChanged: (value) {
              password = value;
            },
            obscureText: obscureTextValue,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: const Icon(
                Icons.lock,
                color: Colors.white,
              ),
              suffixIcon: Visibility(
                visible: obscureTextValue,
                replacement: IconButton(
                  onPressed: () {
                    setState(() {
                      obscureTextValue = !obscureTextValue;
                    });
                  },
                  icon: const Icon(
                    Icons.visibility,
                    color: Colors.white,
                  ),
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      obscureTextValue = !obscureTextValue;
                    });
                  },
                  icon: const Icon(
                    Icons.visibility_off,
                    color: Colors.white,
                  ),
                ),
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Theme(
          data: ThemeData(unselectedWidgetColor: Colors.white),
          child: Checkbox(
            value: _rememberMe,
            visualDensity: VisualDensity.compact,
            checkColor: Colors.green,
            activeColor: Colors.white,
            onChanged: (value) async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool("isSessionActive", true);
              setState(() {
                _rememberMe = value!;
              });
            },
          ),
        ),
        const Text(
          'Remember me',
          style: kLabelStyle,
        ),
      ],
    );
  }

  Widget _buildLoginBtn() {
    return Visibility(
      visible: !showSpinner,
      replacement: const Center(child: CircularProgressIndicator()),
      child: CommonButton(
        color: const Color.fromARGB(255, 164, 197, 255),
        title: isLogin ? 'Login' : 'Register',
        onPressed: () async {
          // Get username and password from the user.Pass the data to helper method
          setState(() {
            showSpinner = true;
          });
          AuthenticationHelper()
              .signInOrSignUp(
                  isSignIn: isLogin, email: email!, password: password!)
              .then(
            (result) {
              setState(() {
                showSpinner = false;
              });
              if (result == null) {
                Navigator.pushReplacementNamed(context, 'home_screen');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    result,
                    style: const TextStyle(fontSize: 16),
                  ),
                ));
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildSignupBtn() {
    return InkWell(
      onTap: () => setState(() {
        isLogin = !isLogin;
      }),
      child: Visibility(
        visible: isLogin,
        replacement: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Already have an Account? ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: 'Sign In',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        child: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Don\'t have an Account? ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: 'Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              const CommonBackground(),
              SizedBox(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        isLogin ? 'Sign In' : 'Sign Up',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      _buildEmailTF(),
                      const SizedBox(
                        height: 30.0,
                      ),
                      _buildPasswordTF(),
                      const SizedBox(
                        height: 10.0,
                      ),
                      _buildRememberMeCheckbox(),
                      _buildLoginBtn(),
                      const SizedBox(
                        height: 10.0,
                      ),
                      _buildSignupBtn(),
                    ],
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
