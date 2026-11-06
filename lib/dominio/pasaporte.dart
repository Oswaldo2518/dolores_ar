
import 'lugar.dart';

// Pasaporte turístico.
// El visitante gana un sello cuando llega
// a 40 metros o menos de un lugar.
class Pasaporte {
  // Distancia máxima para recibir un sello.
  static const double radioSello = 40;

  // Conjunto de identificadores de lugares visitados.
  final Set<String> _visitados = {};

  // Registra un sello cuando el usuario está cerca.
  // Devuelve true únicamente cuando gana
  // el sello por primera vez.
  bool registrarSiCerca(
    Lugar lugar,
    double distanciaMetros,
  ) {
    if (distanciaMetros > radioSello) {
      return false;
    }

    return _visitados.add(lugar.id);
  }

  // Verifica si un lugar ya fue visitado.
  bool visitado(String id) {
    return _visitados.contains(id);
  }

  // Cantidad total de sellos obtenidos.
  int get total => _visitados.length;

  // Calcula el porcentaje de lugares visitados.
  double progreso(int totalLugares) {
    return totalLugares == 0
        ? 0
        : total / totalLugares;
  }
}
