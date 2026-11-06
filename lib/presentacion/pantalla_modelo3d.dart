
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

// Pantalla para visualizar un modelo 3D.
// En dispositivos compatibles permite usar
// realidad aumentada sobre superficies.
class PantallaModelo3D extends StatelessWidget {
  // Modelo de práctica proporcionado por model-viewer.
  static const modeloDePractica =
      'https://modelviewer.dev/shared-assets/models/Astronaut.glb';

  const PantallaModelo3D({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Modelo 3D en tu espacio',
        ),
      ),

      body: const ModelViewer(
        src: modeloDePractica,
        alt: 'Modelo 3D de práctica',

        // Permitir realidad aumentada.
        ar: true,

        // Tecnologías compatibles.
        arModes: [
          'scene-viewer',
          'webxr',
          'quick-look',
        ],

        // Rotación automática del modelo.
        autoRotate: true,

        // Permitir girarlo y acercarlo.
        cameraControls: true,
      ),
    );
  }
}
