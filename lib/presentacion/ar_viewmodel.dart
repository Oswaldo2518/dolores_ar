
import 'dart:async';

import 'package:flutter/foundation.dart';

import '../dominio/excepciones.dart';
import '../dominio/fuentes.dart';
import '../dominio/geo.dart';
import '../dominio/lugar.dart';
import '../dominio/motor_ar.dart';
import '../dominio/pasaporte.dart';

class ArViewModel extends ChangeNotifier {
  final FuentePosicion _posicion;
  final FuenteBrujula _brujula;

  final List<Lugar> lugares;
  final Pasaporte pasaporte;

  final double campoVision;
  final double radioMax;

  ArViewModel({
    required FuentePosicion posicion,
    required FuenteBrujula brujula,
    required this.lugares,
    required this.pasaporte,
    this.campoVision = 60,
    this.radioMax = 2000,
  })  : _posicion = posicion,
        _brujula = brujula;

  // Posición actual del usuario.
  Coordenada? usuario;

  // Dirección actual de la brújula.
  double? rumbo;

  // Lugares visibles en la cámara.
  List<LugarVisible> visibles = [];

  // Mensaje de error seguro.
  String? error;

  // Último sello turístico conseguido.
  Lugar? ultimoSello;

  // Suscripciones a sensores.
  StreamSubscription<Coordenada>? _subPosicion;
  StreamSubscription<double>? _subBrujula;

  // Indica si falta información de algún sensor.
  bool get esperando =>
      usuario == null || rumbo == null;

  // Inicia la lectura de GPS y brújula.
  void iniciar() {
    _subPosicion = _posicion.posiciones.listen(
      (p) {
        usuario = p;
        _recalcular();
      },
      onError: _alFallar,
    );

    _subBrujula = _brujula.rumbos.listen(
      (g) {
        // La primera lectura se acepta directamente.
        // Las siguientes se suavizan.
        rumbo = rumbo == null
            ? g
            : suavizarAngulo(rumbo!, g);

        _recalcular();
      },
      onError: _alFallar,
    );
  }

  // Gestiona los errores de los sensores.
  void _alFallar(Object e) {
    error = mensajeSeguro(e);
    notifyListeners();
  }

  // Actualiza los lugares visibles y los sellos.
  void _recalcular() {
    final u = usuario;
    final r = rumbo;

    if (u != null && r != null) {
      visibles = calcularVisibles(
        usuario: u,
        rumbo: r,
        lugares: lugares,
        campoVision: campoVision,
        radioMax: radioMax,
      );

      // Revisar si ganó un sello turístico.
      for (final l in lugares) {
        final distancia = distanciaMetros(
          u,
          l.coordenada,
        );

        if (pasaporte.registrarSiCerca(
          l,
          distancia,
        )) {
          ultimoSello = l;
        }
      }
    }

    // Avisar a la pantalla que hubo cambios.
    notifyListeners();
  }

  // Permite mostrar el aviso del sello solo una vez.
  Lugar? consumirSello() {
    final l = ultimoSello;
    ultimoSello = null;
    return l;
  }

  // Cancela las suscripciones al cerrar la pantalla.
  @override
  void dispose() {
    _subPosicion?.cancel();
    _subBrujula?.cancel();
    super.dispose();
  }
}
