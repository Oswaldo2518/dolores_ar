
import 'dart:async';

import '../dominio/fuentes.dart';
import '../dominio/geo.dart';

// Simula una ubicación GPS fija.
class PosicionSimulada implements FuentePosicion {
  final Coordenada punto;

  PosicionSimulada(this.punto);

  @override
  Stream<Coordenada> get posiciones =>
      Stream<Coordenada>.value(punto);
}

// Permite simular los movimientos de una brújula.
class BrujulaSimulada implements FuenteBrujula {
  final _controlador =
      StreamController<double>.broadcast();

  double _ultimo = 0;

  @override
  Stream<double> get rumbos async* {
    yield _ultimo;
    yield* _controlador.stream;
  }

  // Cambia el rumbo simulado.
  // Después lo controlaremos con un deslizador.
  void girar(double grados) {
    _ultimo = grados;
    _controlador.add(grados);
  }

  // Cierra el controlador de la brújula.
  void cerrar() {
    _controlador.close();
  }
}
