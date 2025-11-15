import 'package:flutter/material.dart';

/// AuthMethodButton - Botón para método de autenticación con logo
///
/// Características UI PRO 2025:
/// - Diseño minimalista con logo + texto
/// - Animación de press/hover
/// - Bordes suaves (12px radius)
/// - Altura estándar 56px
/// - Soporte para modo outlined o filled
class AuthMethodButton extends StatefulWidget {
  final String label;
  final Widget icon;
  final VoidCallback onPressed;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLoading;

  const AuthMethodButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isOutlined = true,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
  });

  @override
  State<AuthMethodButton> createState() => _AuthMethodButtonState();
}

class _AuthMethodButtonState extends State<AuthMethodButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: widget.isLoading ? null : _onTapDown,
            onTapUp: widget.isLoading ? null : _onTapUp,
            onTapCancel: widget.isLoading ? null : _onTapCancel,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: widget.isOutlined
                    ? Colors.transparent
                    : (widget.backgroundColor ?? colorScheme.primaryContainer),
                border: widget.isOutlined
                    ? Border.all(
                        color: colorScheme.outlineVariant,
                        width: 1.5,
                      )
                    : null,
                borderRadius: BorderRadius.circular(12),
                boxShadow: _isPressed
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.isLoading ? null : widget.onPressed,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo del proveedor
                        if (!widget.isLoading)
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: widget.icon,
                          ),

                        if (!widget.isLoading) const SizedBox(width: 12),

                        // Loading indicator o texto
                        if (widget.isLoading)
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: widget.textColor ?? colorScheme.primary,
                            ),
                          )
                        else
                          Flexible(
                            child: Text(
                              widget.label,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: widget.textColor ??
                                    colorScheme.onSurfaceVariant,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
