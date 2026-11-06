
import 'geo.dart';
import 'lugar.dart';

// Representa un lugar turístico visible
// dentro de la pantalla de realidad aumentada.
class LugarVisible {
  final Lugar lugar;

  // Distancia del usuario al lugar en metros.
  final double distancia;

  // Posición horizontal entre 0 y 1.
  final double x;

  // Profundidad entre 0 y 1.
  final double profundidad;

  // Tamaño visual del lugar.
  final double escala;

  const LugarVisible(
    this.lugar,
    this.distancia,
    this.x,
    this.profundidad,
    this.escala,
  );
}

// Calcula los lugares que deben aparecer
// según la ubicación y rumbo del usuario.
List<LugarVisible> calcularVisibles({
  required Coordenada usuario,
  required double rumbo,
  required List<Lugar> lugares,
  double campoVision = 60,
  double radioMax = 2000,
}) {
  final resultado = <LugarVisible>[];

  for (final l in lugares) {
    // Calcular la distancia hasta el lugar.
    final d = distanciaMetros(
      usuario,
      l.coordenada,
    );

    // Descartar lugares demasiado lejanos.
    if (d > radioMax) {
      continue;
    }

    // Calcular hacia dónde está el lugar.
    final rumboLugar = rumboGrados(
      usuario,
      l.coordenada,
    );

    // Calcular su diferencia con la brújula.
    final dif = diferenciaAngular(
      rumboLugar,
      rumbo,
    );

    // Obtener su posición horizontal.
    final x = posicionHorizontal(
      dif,
      campoVision: campoVision,
    );

    // Descartar lugares fuera de la cámara.
    if (x == null) {
      continue;
    }

    // Calcular profundidad entre 0 y 1.
    final profundidad = (d / radioMax)
        .clamp(0.0, 1.0)
        .toDouble();

    // Los lugares cercanos se ven más grandes.
    final escala = 1.2 - 0.6 * profundidad;

    resultado.add(
      LugarVisible(
        l,
        d,
        x,
        profundidad,
        escala,
      ),
    );
  }

  // Ordenar de lejos a cerca.
  // Los lugares cercanos se dibujarán encima.
  resultado.sort(
    (a, b) => b.distancia.compareTo(a.distancia),
  );

  return resultado;
}
