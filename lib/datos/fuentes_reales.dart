
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

import '../dominio/excepciones.dart';
import '../dominio/fuentes.dart';
import '../dominio/geo.dart';

// Obtiene posiciones desde el GPS real.
class PosicionGps implements FuentePosicion {
  @override
  Stream<Coordenada> get posiciones async* {
    // Comprobar si el GPS está encendido.
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const UbicacionApagadaException();
    }

    // Comprobar permiso de ubicación.
    var permiso = await Geolocator.checkPermission();

    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }

    if (permiso == LocationPermission.denied ||
        permiso == LocationPermission.deniedForever) {
      throw const PermisoUbicacionException();
    }

    // Obtener posiciones del GPS.
    yield* Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 2,
      ),
    ).map(
      (p) => Coordenada(
        p.latitude,
        p.longitude,
      ),
    );
  }
}

// Obtiene el rumbo de la brújula real.
class BrujulaReal implements FuenteBrujula {
  @override
  Stream<double> get rumbos {
    final eventos = FlutterCompass.events;

    if (eventos == null) {
      return Stream.error(
        const SinBrujulaException(),
      );
    }

    return eventos
        .where((e) => e.heading != null)
        .map(
          (e) => normalizar360(e.heading!),
        );
  }
}
