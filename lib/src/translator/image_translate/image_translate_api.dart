import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:http/http.dart' as http;

class ImageTranslateApi {
  ImageTranslateApi() {
    _createIsolate();
  }

  Isolate? _isolate;

  SendPort? _isolatePort;

  late final ReceivePort _receivePort = ReceivePort();

  late final _ready = Completer();

  Completer<String>? _resultCompleter;

  static void _process(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    receivePort.listen(
      (message) async {
        if (message is _ImageTranslateRequest) {
          final bytes = await File(message.path).readAsBytes();
          final base64Decode = base64Encode(bytes);
          final uri = Uri.parse(
              "https://translate.google.com/_/TranslateWebserverUi/data/batchexecute?rpcids=WqWDPb&source-path=%2F&f.sid=8591101971087081393&bl=boq_translate-webserver_20240715.07_p0&hl=vi&soc-app=1&soc-platform=1&soc-device=1&_reqid=240430&rt=c");
          final contentRequest = [
            [base64Decode, "image/png"],
            message.sl,
            message.tl
          ];
          final req = [
            [
              ["WqWDPb", jsonEncode(contentRequest), null, "generic"]
            ]
          ];
          final bodyRequest = {"f.req": jsonEncode(req), "at":"AFS6QyhP2V-3o8M1DirXgeSP5sNd:${DateTime.now().millisecondsSinceEpoch}"};
          final response =
              await http.post(uri, body: bodyRequest);
          sendPort.send(response.body);
        }
      },
    );
  }

  Future<void> _createIsolate() async {
    _isolate = await Isolate.spawn(_process, _receivePort.sendPort);
    _receivePort.listen(
      (message) {
        if (message is SendPort) {
          _isolatePort = message;
          _ready.complete();
        } else if (message is String) {
          _resultCompleter?.complete(message);
        }
      },
    );
  }

  Future<String?> translate(String filePath, String sl, String tl) async {
    if (_resultCompleter?.isCompleted == false) return null;
    _resultCompleter = Completer();
    await _ready.future;
    _isolatePort?.send(_ImageTranslateRequest(filePath, sl, tl));
    return (await _resultCompleter?.future);
  }

  void dispose() {
    _isolate?.kill(priority: Isolate.immediate);
    _receivePort.close();
  }
}

class _ImageTranslateRequest {
  final String path;
  final String sl;
  final String tl;

  _ImageTranslateRequest(this.path, this.sl, this.tl);
}

// Future<void> main() async {
//   final api = ImageTranslateApi();
//   final r = await api.translate(
//       'lib/src/translator/image_translate/img.png', "vi", "zh-CN"
//   );
//   print(r);
// }
