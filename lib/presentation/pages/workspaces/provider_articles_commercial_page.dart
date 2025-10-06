import 'package:flutter/material.dart';

class ProviderArticlesCommercialPage extends StatelessWidget {
  const ProviderArticlesCommercialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Text('Comercial', style: TextStyle(fontSize: 18)),
        SizedBox(height: 12),
        ListTile(
          leading: Icon(Icons.campaign_outlined),
          title: Text('Publicaciones / Ofertas'),
          subtitle: Text('Gestiona tus publicaciones y ofertas activas'),
        ),
        ListTile(
          leading: Icon(Icons.campaign_outlined),
          title: Text('Campañas promocionales'),
          subtitle: Text('Crea y administra campañas'),
        ),
        ListTile(
          leading: Icon(Icons.people_outline),
          title: Text('CRM (Clientes)'),
          subtitle: Text('Gestiona tus clientes y prospectos'),
        ),
        ListTile(
          leading: Icon(Icons.groups_outlined),
          title: Text('Equipo de ventas'),
          subtitle: Text('Gestiona roles y desempeño'),
        ),
      ],
    );
  }
}
