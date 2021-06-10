import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meishi_v1/mixins/validation_mixins.dart';
import 'package:meishi_v1/services/authentication.dart';
import 'package:meishi_v1/widgets/app_error_message.dart';
import 'package:meishi_v1/widgets/meishi_createuserfields.dart';
import 'package:meishi_v1/widgets/meishi_textfield.dart';

class LoginUserScreen extends StatefulWidget with ValidationMixins {
  static const String routename = "/loginuser_screen";

  LoginUserScreen({Key key}) : super(key: key);

  _LoginUserScreenState createState() => _LoginUserScreenState();
}

class _LoginUserScreenState extends State<LoginUserScreen>
    with ValidationMixins {
  FocusNode _focusNode;
  bool _autoValidate = false;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailUserController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _errorMessage = "";

  Widget build(BuildContext context) {
    return Material(
        color: const Color(0xff141b21),
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 50.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          _irAtras(),
                        ],
                      )
                    ],
                  ),
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      Container(
                        child: _loginIcon(),
                      ),
                      Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                child: _textEmail(),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.005),
                              Container(
                                child: _emailField(),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                child: _textPassword(),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.005),
                              Container(
                                child: _fieldPassword(),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              SizedBox(height: 30),
                              _forgotPassword(),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.02),
                              _showErrorMessage(),
                              _registrarBoton()
                            ],
                          )
                        ],
                      )),
                    ],
                  )),
                  Column(
                    children: [_footerText()],
                  )
                ]),
          ),
        ));
  }

  Widget _irAtras() {
    return FlatButton(
        textColor: Colors.white,
        onPressed: () {
          Navigator.pop(context);
        },
        child:
            Icon(Icons.chevron_left_rounded, size: 25.0, color: Colors.white));
  }

  Widget _loginIcon() {
    return Image(
      width: 100,
      height: 100,
      image: AssetImage('images/sin_fondo_meishi.png'),
    );
  }

  Widget _textEmail() {
    return Text("Email",
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15.0,
        ));
  }

  Widget _emailField() {
    return AppUserTextEmailField(
      inputText: "Escribe tu email aquì",
      focusNode: _focusNode,
      autoValidate: _autoValidate,
      validator: validateEmail,
      controller: _emailUserController,
      onSaved: (value) {},
    );
  }

  Widget _textPassword() {
    return Text("Contraseña",
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15.0,
        ));
  }

  Widget _fieldPassword() {
    return AppTextEmailField(
      inputText: "Escribe tu contraseña aquì",
      controller: _passwordController,
      autoValidate: _autoValidate,
      validator: validatePassword,
      obscureText: true,
      onSaved: (value) {},
    );
  }

  String email = "";

  var _formState = GlobalKey<FormState>();

  Widget _forgotPassword() {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () async {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => AlertDialog(
                  titlePadding: EdgeInsets.only(top: 60),
                  title: Text('Recuperar contraseña',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  content: Text(
                    'Ingresa tu correo para recuperar tu contraseña. Recibirás un mail con un link para cambiar de clave.',
                    textAlign: TextAlign.center,
                  ),
                  actions: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          height: 100,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Form(
                            key: _formState,
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Porfavor escribir un correo";
                                } else {
                                  email = value;
                                }
                              },
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 1,
                              decoration: InputDecoration(
                                  hintText: "Escribe tu email aquí",
                                  hintStyle: TextStyle(),
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black))),
                            ),
                          ),
                        ),
                        ButtonTheme(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            height: 50,
                            minWidth: MediaQuery.of(context).size.width * 0.7,
                            child: RaisedButton(
                              color: Colors.pink,
                              child: Text(
                                'Enviar',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () {
                                if (_formState.currentState.validate()) {
                                  FirebaseAuth.instance
                                      .sendPasswordResetEmail(email: email)
                                      .then(
                                          (value) => print('Mensaje enviado'));
                                }

                                Navigator.pop(context);
                              },
                            )),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    )
                  ]),
            );
          },
          child: Text("¿Olvidaste tu contraseña?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              )),
        ),
      ],
    );
  }

  Widget _registrarBoton() {
    return ButtonTheme(
        minWidth: 350.0,
        height: 40,
        child: FlatButton(
            color: const Color(0xff788d9b),
            textColor: Colors.white,
            padding: EdgeInsets.all(10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                var auth = await Authentication().loginUser(
                    email: _emailUserController.text.trim(),
                    password: _passwordController.text.trim());
                if (auth.success) {
                  FocusScope.of(context).requestFocus(_focusNode);
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/principal_screen', (route) => false);
                  _emailUserController.text = "";
                  _passwordController.text = "";
                } else {
                  setState(() {
                    _errorMessage = auth.errorMessage;
                  });
                }
              } else {
                setState(() => _autoValidate = true);
              }
            },
            child: Text(
              "Ingresar",
              style: TextStyle(color: Colors.white, fontSize: 18),
            )));
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return ErrorMessage(errorMessage: _errorMessage);
    } else {
      return Container(
        height: 0.0,
      );
    }
  }

  Widget _footerText() {
    return Container(
        margin: const EdgeInsets.only(bottom: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Siempre protegeremos y respetaremos\ntus datos y privacidad",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.0,
                ))
          ],
        ));
  }
}
