import 'package:flutter/material.dart';

class ProviderArticlesProfilePage extends StatelessWidget {
  const ProviderArticlesProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Text('Perfil', style: TextStyle(fontSize: 18)),
        SizedBox(height: 12),
        ListTile(
          leading: Icon(Icons.badge_outlined),
          title: Text('Datos del proveedor'),
          subtitle: Text('Nombre, documento, contacto'),
        ),
        ListTile(
          leading: Icon(Icons.place_outlined),
          title: Text('Cobertura'),
          subtitle: Text('País / Región / Ciudad'),
        ),
        ListTile(
          leading: Icon(Icons.settings_outlined),
          title: Text('Preferencias'),
          subtitle: Text('Configuraciones y notificaciones'),
        ),
      ],
    );
  }
}
