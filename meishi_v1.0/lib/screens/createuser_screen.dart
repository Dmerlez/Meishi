import 'package:flutter/material.dart';
import 'package:meishi_v1/mixins/validation_mixins.dart';
import 'package:meishi_v1/services/authentication.dart';
import 'package:meishi_v1/widgets/app_error_message.dart';
import 'package:meishi_v1/widgets/meishi_textfield.dart';

class CreateUserScreen extends StatefulWidget with ValidationMixins {
  static const String routename = "/createuser_screen";

  CreateUserScreen({Key key}) : super(key: key);

  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen>
    with ValidationMixins {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirm = TextEditingController();
  FocusNode _focusNode;
  bool _autoValidate = false;
  bool showSpinner = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  void dispose() {
    super.dispose();
    _focusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff141b21),
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _irAtras(),
                  ],
                ),
                Column(
                  children: <Widget>[
                    _loginIcon(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Container(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _firstText(),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            _secondText(),
                          ]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                  padding: EdgeInsets.only(left: 5),
                                  child: _textEmail()),
                              SizedBox(height: 5),
                              Container(
                                child: _fieldEmail(),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Container(
                                  padding: EdgeInsets.only(left: 5),
                                  child: _textPassword()),
                              SizedBox(
                                height: 5,
                              ),
                              _fieldPassword(),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Container(
                                  padding: EdgeInsets.only(left: 5),
                                  child: _textPassword2()),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              _fieldRepeatPassword(),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[_crearCuenta()],
                    )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    _showErrorMessage(),
                    _registrarBoton()
                  ],
                ),
                Column(
                  children: [
                    _footerText(),
                  ],
                )
              ],
            ),
          ),
        )));
  }

  Widget _irAtras() {
    return FlatButton(
        textColor: Colors.white,
        onPressed: () {
          Navigator.pop(context);
          //Navigator.pushNamed(context, '/login_screen');
        },
        child:
            Icon(Icons.chevron_left_rounded, size: 25.0, color: Colors.white));
  }

  Widget _loginIcon() {
    return Image(
      width: 59,
      height: 59,
      image: AssetImage('images/Meishi.PNG'),
    );
  }

  Widget _firstText() {
    return Text("¡Comencemos!",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ));
  }

  Widget _secondText() {
    return Text("Ingresa tu correo electrónico y crea\nuna contraseña",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.0,
        ));
  }

  Widget _textEmail() {
    return Text("Email",
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Colors.white,
          fontSize: 11.0,
        ));
  }

  Widget _fieldEmail() {
    return AppTextEmailField(
      inputText: "Escribe tu email aquí",
      focusNode: _focusNode,
      autoValidate: _autoValidate,
      validator: validateEmail,
      controller: _emailController,
      onSaved: (value) {},
    );
  }

  Widget _textPassword() {
    return Text("Contraseña",
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Colors.white,
          fontSize: 11.0,
        ));
  }

  Widget _textPassword2() {
    return Text("Reingresar Contraseña",
        textAlign: TextAlign.left,
        style: TextStyle(
          color: Colors.white,
          fontSize: 11.0,
        ));
  }

  Widget _fieldPassword() {
    return AppTextEmailField(
      inputText: "Escriba aquí su contraseña",
      controller: _passwordController,
      autoValidate: _autoValidate,
      validator: validatePassword,
      obscureText: true,
      onSaved: (value) {},
    );
  }

  Widget _fieldRepeatPassword() {
    return AppTextEmailField(
      inputText: "Vuelve a escribir tu contraseña aquí",
      controller: _passwordConfirm,
      autoValidate: _autoValidate,
      validator: (val) {
        if (val != _passwordController.text) {
          return "contraseñas no coinciden";
          return null;
        }
      },
      obscureText: true,
      onSaved: (value) {},
    );
  }

  Widget _crearCuenta() {
    return Column(
      children: <Widget>[
        Text("¿Ya tienes una cuenta?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            )),
        InkWell(
          onTap: () => Navigator.pushNamed(context, '/loginuser_screen'),
          child: Text("Ingresa aquí",
              style: TextStyle(
                color: Colors.lightBlueAccent,
                fontSize: 11,
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
            padding: EdgeInsets.all(5.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                var auth = await Authentication().createUser(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim());
                if (auth.success) {
                  Navigator.pushNamed(context, '/createuserprofile_screen');
                  _emailController.text = "";
                  _passwordController.text = "";
                  FocusScope.of(context).requestFocus(_focusNode);
                } else {
                  setState(() {
                    _errorMessage = auth.errorMessage;
                  });
                }
              }
            },
            child: Text(
              "Siguiente",
              style: TextStyle(color: Colors.white, fontSize: 16),
            )));
  }

  Widget _footerText() {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Siempre protegeremos y respetaremos\ntus datos y privacidad",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.0,
            ))
      ],
    ));
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
}
