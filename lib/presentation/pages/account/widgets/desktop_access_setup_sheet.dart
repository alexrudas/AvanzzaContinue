// ============================================================================
// lib/presentation/pages/account/widgets/desktop_access_setup_sheet.dart
// Sheet/dialog para activar el acceso de escritorio (username + password).
//
// Resolución técnica (auditada): vincula una credencial password al UID
// Firebase vigente vía linkWithCredential — NO crea cuenta nueva. Preserva
// memberships y todo el grafo de identidad del usuario OTP.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/platform/platform_capabilities.dart';
import '../../../../domain/entities/account/desktop_access_status.dart';
import '../../../controllers/account/desktop_access_controller.dart';

/// Abre el setup. Devuelve el [DesktopAccessStatus] final si se completó.
Future<DesktopAccessStatus?> openDesktopAccessSetupSheet(
  BuildContext context,
) async {
  if (PlatformCapabilities.isDesktop) {
    return showDialog<DesktopAccessStatus?>(
      context: context,
      builder: (ctx) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: const _DesktopAccessSetupForm(),
        ),
      ),
    );
  }
  return showModalBottomSheet<DesktopAccessStatus?>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(ctx).viewInsets.bottom,
      ),
      child: const _DesktopAccessSetupForm(),
    ),
  );
}

class _DesktopAccessSetupForm extends StatefulWidget {
  const _DesktopAccessSetupForm();

  @override
  State<_DesktopAccessSetupForm> createState() =>
      _DesktopAccessSetupFormState();
}

class _DesktopAccessSetupFormState extends State<_DesktopAccessSetupForm> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool _obscure = true;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<DesktopAccessController>();

    return SafeArea(
      top: false,
      // SingleChildScrollView: cuando sube el teclado el viewInsets.bottom del
      // builder empuja la sheet, pero el contenido de la columna mantiene su
      // altura intrínseca. Sin scroll interno desborda en pantallas pequeñas.
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Activar acceso para escritorio',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'Define un usuario y contraseña para iniciar sesión desde '
                'Windows sin código SMS.',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.hintColor),
              ),
              const SizedBox(height: 16),
              Obx(() {
                final err = controller.usernameError.value;
                return TextFormField(
                  controller: _username,
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Nombre de usuario',
                    helperText: 'Solo letras y números, mínimo 3 caracteres.',
                    border: const OutlineInputBorder(),
                    errorText: err,
                  ),
                  validator: (v) {
                    final s = (v ?? '').trim();
                    if (s.length < 3) return 'Mínimo 3 caracteres';
                    if (!RegExp(r'^[a-zA-Z0-9_.-]+$').hasMatch(s)) {
                      return 'Solo letras, números, "_", "-" o "."';
                    }
                    return null;
                  },
                );
              }),
              const SizedBox(height: 12),
              Obx(() {
                final err = controller.passwordError.value;
                return TextFormField(
                  controller: _password,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    helperText: 'Mínimo 8 caracteres.',
                    border: const OutlineInputBorder(),
                    errorText: err,
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(_obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined),
                    ),
                  ),
                  validator: (v) =>
                      (v == null || v.length < 8) ? 'Mínimo 8 caracteres' : null,
                );
              }),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirm,
                obscureText: _obscure,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Confirmar contraseña',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v != _password.text) ? 'No coincide' : null,
              ),
              const SizedBox(height: 8),
              Obx(() {
                final err = controller.formError.value;
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
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 8),
                  Obx(() {
                    final submitting = controller.submitting.value;
                    return FilledButton(
                      onPressed: submitting
                          ? null
                          : () async {
                              if (!_form.currentState!.validate()) return;
                              final res = await controller.submit(
                                username: _username.text,
                                password: _password.text,
                                passwordConfirm: _confirm.text,
                              );
                              if (res != null && context.mounted) {
                                Navigator.of(context).pop(res);
                              }
                            },
                      child: submitting
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Activar'),
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
