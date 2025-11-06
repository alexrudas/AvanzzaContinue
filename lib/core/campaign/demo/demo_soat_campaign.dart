import 'package:flutter/material.dart';

/// Vista de campaña SOAT (muestra información y CTA)
/// Se usa como destino al tocar la mini-card de la campaña "demo_insurance_soat".
class DemoSoatCampaignPage extends StatelessWidget {
  const DemoSoatCampaignPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('HDI Seguros te cuida'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/campaign/campaign_insurance.png',
                width: 160,
                height: 160,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.shield_moon,
                  size: 80,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Tienes un SOAT vencido',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              '✅ Evita gastos por inmovilización del vehículo\n'
              '✅ Evita gastos por multas innecesarias\n\n'
              '🛡️ Tranquilo, HDI Seguros te cuida.\n'
              'Renueva tu SOAT en minutos desde la app.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF475569),
                height: 1.5,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Aquí pones la navegación real a la compra de SOAT
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B82F6),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Renovar SOAT Ahora',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
