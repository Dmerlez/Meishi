class Slide {
  final title;
  final title2;
  final cuerpo;
  final descripcion;

  Slide({
    this.title,
    this.title2,
    this.cuerpo,
    this.descripcion,
  });
}

final slideList = [
  Slide(
    title: 'Adiós papel  ',
    title2: '  ¡Hola Meishi!',
    cuerpo:
        '¡Deshazte de todas las tarjetas de contacto guardadas en tu bolsillo!',
    descripcion:
        'Meishi es una app que te permite guardar tus contactos profesionales de manera muy simple, cómoda y en un solo lugar.',
  ),
  Slide(
    title: '',
    title2: '',
    cuerpo: '¡Comienza a organizar tu agenda de contactos!',
    descripcion:
        'Agrega contactos manualmente o a través de código QR para acceder a su información de contacto profesional, recomendaciones y links de interés.',
  ),
  Slide(
    title: '',
    title2: '',
    cuerpo: 'Nunca más te quedarás sin tarjeta de presentación',
    descripcion:
        'Siempre podrás llevar contigo tu Meishi y compartirla con otros usuarios o a quién tu quieras a través de tu propio código QR.',
  ),
  Slide(
    title: '',
    title2: '',
    cuerpo: 'Personaliza tu perfil y tus contactos',
    descripcion:
        'Agrega notas y etiquetas personalizadas a tus contactos, envía y recibe recomendaciones profesionales y añade links de interés para hacer tu tarjeta mucho mas atractiva.',
  ),
];
