import 'package:flutter/material.dart';
import 'package:post_app/core/app_export.dart';
import 'package:post_app/services/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LoginPage extends StatefulWidget {
  final Function? onResult;

  const LoginPage({super.key, this.onResult});
  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                 //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                  padding: getPadding(
                    left:15.0,
                    right: 15.0,
                    top: 60.0,
                    bottom: 20,
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter email',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: getPadding(
                    left:15.0,
                    right: 15.0,
                    top: 20.0,
                    bottom: 10.0,
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter password',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: getVerticalSize(16)),
                if(_errorMessage.isNotEmpty)
                  Container(
                    padding: getPadding(
                      left:14,
                    ),
                    child: Text(
                      _errorMessage,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: getFontSize(16),
                      ),
                    ),
                  ),
                TextButton(
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: getFontSize(15),
                    ),
                  ),
                  onPressed: () async {
                    const String url = '${Env.baseUrl}/forgot-password';
                    if (await canLaunchUrlString(url)) {
                      await launchUrlString(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
                Container(
                  height: getVerticalSize(50),
                  width: getHorizontalSize(230),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(getHorizontalSize(20)),
                  ),
                  child: TextButton(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: getFontSize(25),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Provider.of<AuthProvider>(context, listen:false).login(
                          email: _emailController.text,
                          password: _passwordController.text,
                        ).then((Map<String, dynamic> result ) {
                          if(result['success'] == false){
                            setState(() {
                              _errorMessage = result['errors'];
                            });
                          } else if (result['success'] == true){
                            if(widget.onResult != null){
                              widget.onResult!(true);
                            } else {
                              Navigator.pushNamed(context, AppRoutes.authProfile);
                            }
                          }
                        });
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: getVerticalSize(130),
                ),
                InkWell(
                  child: Text(
                    'New User? Create Account',
                    style: TextStyle(
                      fontSize: getFontSize(15),
                    ),
                  ),
                  onTap: () async {
                    const String url = '${Env.baseUrl}/register';
                    if (await canLaunchUrlString(url)) {
                      await launchUrlString(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
              ],
            ),
        ),
      ),
    );
  }
}