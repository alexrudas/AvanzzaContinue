import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectorItem<T> {
  final T value;
  final String label;
  final String? subtitle;
  SelectorItem({required this.value, required this.label, this.subtitle});
}

class BottomSheetSelector<T> extends StatefulWidget {
  final String title;
  final List<SelectorItem<T>>? items;
  final Future<List<SelectorItem<T>>> Function(String query)? asyncLoader;
  final T? selectedValue;
  final ValueChanged<SelectorItem<T>> onSelect;
  final ValueChanged<String>? onSearch;
  final IconData? leadingIcon;
  final String emptyStateText;
  final Widget? header;
  final bool showSearch;

  const BottomSheetSelector({
    super.key,
    required this.title,
    this.items,
    this.asyncLoader,
    required this.selectedValue,
    required this.onSelect,
    this.onSearch,
    this.leadingIcon,
    this.emptyStateText = 'Sin resultados',
    this.header,
    this.showSearch = true,
  });

  @override
  State<BottomSheetSelector<T>> createState() => _BottomSheetSelectorState<T>();
}

class _BottomSheetSelectorState<T> extends State<BottomSheetSelector<T>> {
  final _searchCtrl = TextEditingController();
  List<SelectorItem<T>> _data = [];
  Timer? _debounce;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _load('');
  }

  @override
  void didUpdateWidget(covariant BottomSheetSelector<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si items cambió (ej: Obx reconstruye con datos de Firestore),
    // refrescar _data con el query actual del search.
    if (widget.items != oldWidget.items) {
      _load(_searchCtrl.text);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load(String q) async {
    if (!mounted) return;
    setState(() => _loading = true);

    List<SelectorItem<T>> result;
    if (widget.asyncLoader != null) {
      result = await widget.asyncLoader!(q);
    } else {
      // Siempre leer widget.items al momento de _load (no cachear stale)
      result = widget.items ?? [];
      if (q.isNotEmpty) {
        final query = q.toLowerCase();
        result = result
            .where((e) => e.label.toLowerCase().contains(query))
            .toList();
      }
    }

    if (!mounted) return;
    setState(() {
      _data = result;
      _loading = false;
    });
  }

  void _onQueryChanged(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () => _load(q));
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(widget.title,
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            if (widget.showSearch)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: TextField(
                  controller: _searchCtrl,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Buscar...',
                  ),
                  onChanged: _onQueryChanged,
                ),
              ),
            if (widget.header != null) widget.header!,
            if (_loading)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_data.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(widget.emptyStateText,
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
              )
            else
              ..._data.map((item) {
                final isSelected = widget.selectedValue == item.value;
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  leading: widget.leadingIcon != null
                      ? Icon(widget.leadingIcon)
                      : null,
                  title: Text(item.label),
                  subtitle: item.subtitle != null
                      ? Text(item.subtitle!,
                          style: TextStyle(color: Theme.of(context).hintColor))
                      : null,
                  trailing: isSelected
                      ? Icon(Icons.check,
                          color: Theme.of(context).colorScheme.primary)
                      : null,
                  minVerticalPadding: 12,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    widget.onSelect(item);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Seleccionado: ${item.label}'),
                          duration: const Duration(seconds: 1)),
                    );
                    Navigator.of(context).pop();
                  },
                );
              }),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
