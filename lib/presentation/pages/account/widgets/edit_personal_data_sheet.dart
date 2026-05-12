// ============================================================================
// lib/presentation/pages/account/widgets/edit_personal_data_sheet.dart
// Sheet/dialog para editar datos personales (Nombre + Email).
// Decide presentación según PlatformCapabilities.isDesktop:
//   - mobile  → showModalBottomSheet (full-width, draggable)
//   - desktop → showDialog (AlertDialog, ancho contenido)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/platform/platform_capabilities.dart';
import '../../../../domain/entities/user/user_entity.dart';
import '../../../controllers/account/account_profile_controller.dart';

/// Abre el editor de datos personales. Devuelve `true` si el usuario guardó.
Future<bool> openEditPersonalDataSheet(
  BuildContext context, {
  required UserEntity current,
}) async {
  if (PlatformCapabilities.isDesktop) {
    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: _EditPersonalDataForm(current: current),
        ),
      ),
    );
    return res ?? false;
  }
  final res = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(ctx).viewInsets.bottom,
      ),
      child: _EditPersonalDataForm(current: current),
    ),
  );
  return res ?? false;
}

class _EditPersonalDataForm extends StatefulWidget {
  final UserEntity current;
  const _EditPersonalDataForm({required this.current});

  @override
  State<_EditPersonalDataForm> createState() => _EditPersonalDataFormState();
}

class _EditPersonalDataFormState extends State<_EditPersonalDataForm> {
  late final TextEditingController _name;
  late final TextEditingController _email;
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.current.name);
    _email = TextEditingController(text: widget.current.email);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<AccountProfileController>();

    return SafeArea(
      top: false,
      // SingleChildScrollView: el viewInsets.bottom del builder empuja la
      // sheet sobre el teclado, pero el contenido necesita scroll propio para
      // no desbordar en pantallas pequeñas cuando el teclado está abierto.
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Datos personales', style: theme.textTheme.titleLarge),
              const SizedBox(height: 16),
              TextFormField(
                controller: _name,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Nombre completo',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'El nombre es obligatorio'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final s = (v ?? '').trim();
                  if (s.isEmpty) return null; // opcional
                  if (!s.contains('@') || !s.contains('.')) {
                    return 'Email inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Obx(() {
                final err = controller.personalError.value;
                if (err == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 4),
                  child: Text(
                    err,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.error),
                  ),
                );
              }),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 8),
                  Obx(() {
                    final saving = controller.savingPersonal.value;
                    return FilledButton(
                      onPressed: saving
                          ? null
                          : () async {
                              if (!_form.currentState!.validate()) return;
                              final ok = await controller.savePersonalData(
                                name: _name.text,
                                email: _email.text,
                              );
                              if (ok && context.mounted) {
                                Navigator.of(context).pop(true);
                              }
                            },
                      child: saving
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Guardar'),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
