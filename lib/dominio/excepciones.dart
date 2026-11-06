
abstract class ErrorDeApp implements Exception {
  const ErrorDeApp();
}

// Error cuando no se concede el permiso de ubicación.
class PermisoUbicacionException extends ErrorDeApp {
  const PermisoUbicacionException();

  @override
  String toString() =>
      'Necesito el permiso de ubicación para mostrarte '
      'los lugares cercanos. Actívalo en Ajustes.';
}

// Error cuando el GPS está apagado.
class UbicacionApagadaException extends ErrorDeApp {
  const UbicacionApagadaException();

  @override
  String toString() =>
      'El GPS está apagado. Actívalo para usar '
      'la realidad aumentada.';
}

// Error cuando el dispositivo no tiene brújula.
class SinBrujulaException extends ErrorDeApp {
  const SinBrujulaException();

  @override
  String toString() =>
      'Este dispositivo no tiene brújula '
      '(magnetómetro). Usa el modo demo.';
}

// Muestra mensajes seguros al usuario.
String mensajeSeguro(Object error) {
  return error is ErrorDeApp
      ? error.toString()
      : 'Ocurrió un error inesperado. Intenta de nuevo.';
}
