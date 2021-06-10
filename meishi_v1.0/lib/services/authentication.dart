import 'package:firebase_auth/firebase_auth.dart';
import 'package:meishi_v1/model/auth_request.dart';

class Authentication {
  final _auth = FirebaseAuth.instance;

  Future<AuthenticationRequest> createUser(
      {String email = "", String password = ""}) async {
    AuthenticationRequest authRequest = AuthenticationRequest();
    try {
      var user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        authRequest.success = true;
      }
    } catch (e) {
      _mapErrorMessage(authRequest, e.code);
    }
    return authRequest;
  }

  Future<User> getCurrentUser() async {
    try {
      return await _auth.currentUser;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<AuthenticationRequest> loginUser(
      {String email = "", String password = ""}) async {
    AuthenticationRequest authRequest = AuthenticationRequest();
    try {
      var user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      if (user != null) {
        authRequest.success = true;
      }
    } catch (e) {
      _mapErrorMessage(authRequest, e.code);
    }
    return authRequest;
  }

  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e);
    }
    return null;
  }

  void _mapErrorMessage(AuthenticationRequest authRequest, String code) {
    switch (code) {
      case "user-not-found":
        authRequest.errorMessage = "Usuario no encontrado";
        break;
      case "wrong-password":
        authRequest.errorMessage = "Contraseña inválida";
        break;
      case "network-request-failed":
        authRequest.errorMessage = "Error de red";
        break;
      case "email-already-in-use":
        authRequest.errorMessage = "El usuario ya esta registrado";
        break;
      case "email-already-in-use":
        authRequest.errorMessage = "El usuario ya esta registrado";
        break;
      case "too-many-requests":
        authRequest.errorMessage = "Muchas solicitudes... espere";
        break;
      default:
        authRequest.errorMessage = code;
    }
  }
}
