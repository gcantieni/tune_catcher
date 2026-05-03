import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tune_catcher/feat/abc_render/webview_abc_renderer.dart';

/// Renders ABC notation to an SVG string. The implementation is
/// deliberately hidden behind this interface so the abc_render module
/// can be swapped (or removed) in one place. Today the only impl is
/// [WebViewAbcRenderer], which spins up a headless flutter_inappwebview
/// instance bundled with abcjs.
///
/// Returns the SVG markup on success, or null on any failure (offline
/// first-load, malformed ABC, abcjs error). Callers should fall back
/// to plaintext on null.
abstract class AbcRenderer {
  Future<String?> render(String abc);

  /// Frees the underlying resources (webview, JS context). Safe to
  /// call multiple times.
  Future<void> dispose();
}

final abcRendererProvider = Provider<AbcRenderer>((ref) {
  final renderer = WebViewAbcRenderer();
  ref.onDispose(renderer.dispose);
  return renderer;
});
