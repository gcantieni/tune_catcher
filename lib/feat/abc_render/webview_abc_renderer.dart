import 'dart:async';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:tune_catcher/feat/abc_render/abc_renderer.dart';

/// Headless flutter_inappwebview that hosts a tiny HTML shim bundled
/// at `assets/abcjs/render.html`. The shim loads abcjs and exposes
/// `window.renderAbcToSvg(abc)` which returns SVG markup. We call it
/// via JS evaluation and pull the string back.
///
/// Lifecycle: lazy — the webview is spun up on the first [render]
/// call and reused for the rest of the app's lifetime. Concurrent
/// calls are serialized so abcjs sees one render at a time.
class WebViewAbcRenderer implements AbcRenderer {
  HeadlessInAppWebView? _headless;
  InAppWebViewController? _controller;
  Completer<void>? _ready;
  Future<String?>? _inFlight;

  Future<void> _ensureReady() {
    final existing = _ready;
    if (existing != null) return existing.future;

    final ready = Completer<void>();
    _ready = ready;

    final headless = HeadlessInAppWebView(
      initialFile: 'assets/abcjs/render.html',
      onWebViewCreated: (c) => _controller = c,
      onLoadStop: (c, _) {
        if (!ready.isCompleted) ready.complete();
      },
      onReceivedError: (c, req, err) {
        if (!ready.isCompleted) ready.completeError(err);
      },
    );
    _headless = headless;

    headless.run().catchError((Object e) {
      if (!ready.isCompleted) ready.completeError(e);
    });

    return ready.future;
  }

  @override
  Future<String?> render(String abc) async {
    if (abc.trim().isEmpty) return null;
    // Serialize: abcjs writes into a single shared <div>, so concurrent
    // calls would clobber each other.
    final previous = _inFlight;
    final completer = Completer<String?>();
    _inFlight = completer.future;
    try {
      if (previous != null) {
        await previous;
      }
      await _ensureReady();
      final encoded = jsonEncodeString(abc);
      final result = await _controller?.evaluateJavascript(
        source: 'window.renderAbcToSvg($encoded);',
      );
      final svg = result is String && result.isNotEmpty ? result : null;
      completer.complete(svg);
      return svg;
    } catch (_) {
      // Reset readiness so a future render attempt can retry the
      // webview load (e.g. after first-launch flake).
      _ready = null;
      completer.complete(null);
      return null;
    } finally {
      if (identical(_inFlight, completer.future)) _inFlight = null;
    }
  }

  @override
  Future<void> dispose() async {
    await _headless?.dispose();
    _headless = null;
    _controller = null;
    _ready = null;
  }
}

/// Quote a Dart string as a JSON string literal for safe interpolation
/// into JS source. Avoids pulling in dart:convert just for this.
String jsonEncodeString(String s) {
  final buf = StringBuffer('"');
  for (final rune in s.runes) {
    switch (rune) {
      case 0x22: // "
        buf.write(r'\"');
      case 0x5c: // \
        buf.write(r'\\');
      case 0x08:
        buf.write(r'\b');
      case 0x09:
        buf.write(r'\t');
      case 0x0a:
        buf.write(r'\n');
      case 0x0c:
        buf.write(r'\f');
      case 0x0d:
        buf.write(r'\r');
      default:
        if (rune < 0x20 || rune == 0x2028 || rune == 0x2029) {
          buf.write('\\u${rune.toRadixString(16).padLeft(4, '0')}');
        } else {
          buf.writeCharCode(rune);
        }
    }
  }
  buf.write('"');
  return buf.toString();
}
