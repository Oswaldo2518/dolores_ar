
import 'geo.dart';

// Contrato para obtener posiciones.
// Puede utilizar GPS real, simulado o falso.
abstract class FuentePosicion {
  Stream<Coordenada> get posiciones;
}

// Contrato para obtener rumbos de brújula.
// 0 grados significa norte.
abstract class FuenteBrujula {
  Stream<double> get rumbos;
}
