
import 'geo.dart';

// Categorías de los lugares turísticos.
enum Categoria {
  historia,
  museo,
  plaza,
  musica,
  gastronomia,
}

// Modelo de un lugar turístico.
class Lugar {
  final String id;
  final String nombre;
  final String emoji;
  final Categoria categoria;
  final String descripcion;
  final String datoCurioso;
  final Coordenada coordenada;

  const Lugar({
    required this.id,
    required this.nombre,
    required this.emoji,
    required this.categoria,
    required this.descripcion,
    required this.datoCurioso,
    required this.coordenada,
  });
}
