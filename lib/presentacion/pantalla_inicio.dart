import 'package:flutter/material.dart';

import '../datos/fuentes_reales.dart';
import '../datos/fuentes_simuladas.dart';
import '../dominio/catalogo.dart';
import '../dominio/geo.dart';
import '../dominio/pasaporte.dart';
import 'ar_viewmodel.dart';
import 'pantalla_ar.dart';
import 'pantalla_modelo3d.dart';

class PantallaInicio extends StatefulWidget {
  final Pasaporte pasaporte;

  const PantallaInicio({super.key, required this.pasaporte});

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  // Abre la realidad aumentada con sensores reales.
  Future<void> _irReal(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => PantallaAr(
          crearVm: () => ArViewModel(
            posicion: PosicionGps(),
            brujula: BrujulaReal(),
            lugares: catalogoDolores,
            pasaporte: widget.pasaporte,
          ),
        ),
      ),
    );

    // Actualiza los sellos al regresar.
    if (mounted) {
      setState(() {});
    }
  }

  // Abre la realidad aumentada en modo DEMO.
  Future<void> _irDemo(BuildContext context) async {
    final brujula = BrujulaSimulada();

    try {
      await Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (_) => PantallaAr(
            crearVm: () => ArViewModel(
              posicion: PosicionSimulada(
                const Coordenada(21.15600, -100.93175),
              ),
              brujula: brujula,
              lugares: catalogoDolores,
              pasaporte: widget.pasaporte,
            ),
            controlesDemo: _DeslizadorRumbo(brujula: brujula),
          ),
        ),
      );
    } finally {
      brujula.cerrar();
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dolores AR')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Descubre Dolores Hidalgo con realidad aumentada',
            style: Theme.of(context).textTheme.headlineSmall,
          ),

          const SizedBox(height: 12),

          const Card(
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.deepOrange,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Seguridad y privacidad',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  Text(
                    'Mira a tu alrededor, cuida tu paso y '
                    'no cruces la calle viendo el teléfono.',
                  ),

                  SizedBox(height: 8),

                  Text(
                    'La ubicación se utiliza mientras exploras '
                    'para calcular distancias y mostrar lugares '
                    'turísticos cercanos. Esta aplicación no envía '
                    'tu ubicación GPS a un servidor.',
                  ),

                  SizedBox(height: 8),

                  Text(
                    'También puedes utilizar el modo DEMO '
                    'sin compartir tu ubicación real.',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Apunta tu teléfono y mira qué lugares históricos te rodean.',
          ),

          const SizedBox(height: 20),

          FilledButton.icon(
            onPressed: () => _irReal(context),
            icon: const Icon(Icons.explore),
            label: const Text('Explorar con GPS real'),
          ),

          const SizedBox(height: 10),

          const SizedBox(height: 10),

          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const PantallaModelo3D(),
                ),
              );
            },
            icon: const Icon(Icons.view_in_ar),
            label: const Text('Modelo 3D en tu espacio'),
          ),

          const SizedBox(height: 24),

          Text(
            'Lugares del recorrido',
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const SizedBox(height: 8),

          // Mostrar los siete lugares del catálogo.
          for (final l in catalogoDolores)
            ListTile(
              leading: Text(l.emoji, style: const TextStyle(fontSize: 26)),
              title: Text(l.nombre),
              trailing: Icon(
                widget.pasaporte.visitado(l.id)
                    ? Icons.verified
                    : Icons.circle_outlined,
                color: widget.pasaporte.visitado(l.id) ? Colors.green : null,
              ),
            ),
        ],
      ),
    );
  }
}

// Deslizador para girar la brújula simulada.
class _DeslizadorRumbo extends StatefulWidget {
  final BrujulaSimulada brujula;

  const _DeslizadorRumbo({required this.brujula});

  @override
  State<_DeslizadorRumbo> createState() => _DeslizadorRumboState();
}

class _DeslizadorRumboState extends State<_DeslizadorRumbo> {
  double _grados = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Text('Gira:', style: TextStyle(color: Colors.white)),

          Expanded(
            child: Slider(
              min: 0,
              max: 359,
              value: _grados,
              onChanged: (g) {
                setState(() {
                  _grados = g;
                });

                widget.brujula.girar(g);
              },
            ),
          ),

          Text(
            '${_grados.round()}°',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
