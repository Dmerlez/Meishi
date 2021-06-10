class ValidationMixins {
  String validateEmail(String value) {
    if (!value.contains('@')) {
      return "Email Invalido";

      return null;
    }
  }

  String validatePassword(String value) {
    if (value.length < 8) {
      return "Debe tener al menos 8 caracteres";

      return null;
    }
  }

  String validatePhone(String value) {
    if (value.contains(' ')) {
      return "No debe tener espacios";

      return null;
    }
  }

  String validateName(String value) {
    if (value == null) {
      return "No Debe ser null";

      return null;
    }
  }

  String validateUserName(String value) {
    if (!value.contains('@')) {
      return "Nombre de usuario debe contener @";
    } else if (value.isEmpty) {
      return "Campo obligatorio";
    } else if (value.contains(' ')) {
      return "No puede tener espacios";
    } else if (value.length < 2) {
      return "Debe escribir algun caracter";
    }
  }

  String validateUrl(String value) {
    if (!value.contains('https://')) {
      return 'Enlace inválido, \ndebe comenzar con "https://"';
    } else if (value.contains(' ')) {
      return 'Enlace inválido, \nno debe tener espacios';
    } else if (!value.contains('.')) {
      return 'Enlace inválido';
    }
  }
}
