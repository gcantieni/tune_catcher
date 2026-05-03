import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Renders cached ABC sheet music if [svg] is available; otherwise
/// falls back to the plaintext block. Kept tiny and self-contained so
/// callers don't need to know about flutter_svg or the renderer.
class AbcView extends StatelessWidget {
  final String? abc;
  final String? svg;

  const AbcView({required this.abc, required this.svg, super.key});

  @override
  Widget build(BuildContext context) {
    final hasSvg = svg != null && svg!.isNotEmpty;
    if (hasSvg) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: SvgPicture.string(
          svg!,
          alignment: Alignment.topLeft,
        ),
      );
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: SelectableText(
        (abc == null || abc!.isEmpty) ? '—' : abc!,
        style: const TextStyle(fontFamily: 'monospace'),
      ),
    );
  }
}
