import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Start the background offline static server
  startLocalServer();
  
  runApp(const SajnaWebViewApp());
}

HttpServer? _localServer;

void startLocalServer() async {
  try {
    // Bind to the local loopback address
    _localServer = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
    print("Offline loopback server listening on http://localhost:8080");
    
    await for (HttpRequest request in _localServer!) {
      final path = request.uri.path == '/' ? '/index.html' : request.uri.path;
      final assetPath = 'assets/web$path';
      
      try {
        final byteData = await rootBundle.load(assetPath);
        final bytes = byteData.buffer.asUint8List();
        
        request.response.headers.add(HttpHeaders.contentTypeHeader, _getContentType(path));
        request.response.add(bytes);
      } catch (e) {
        request.response.statusCode = HttpStatus.notFound;
        request.response.write("File Not Found: $path");
      } finally {
        await request.response.close();
      }
    }
  } catch (e) {
    print("Local Server startup error: $e");
  }
}

String _getContentType(String path) {
  if (path.endsWith('.html')) return 'text/html; charset=utf-8';
  if (path.endsWith('.css')) return 'text/css; charset=utf-8';
  if (path.endsWith('.js')) return 'application/javascript; charset=utf-8';
  if (path.endsWith('.png')) return 'image/png';
  if (path.endsWith('.woff2')) return 'font/woff2';
  if (path.endsWith('.json')) return 'application/json';
  return 'application/octet-stream';
}

class SajnaWebViewApp extends StatelessWidget {
  const SajnaWebViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAJNA AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const WebViewScreen(),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _initWebView();
  }

  Future<void> _requestPermissions() async {
    // System-level mic permissions check
    await Permission.microphone.request();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      );

    // Auto-grant permission requests (such as audio capture) on localhost origin
    if (_controller.platform is AndroidWebViewController) {
      (_controller.platform as AndroidWebViewController).setOnPlatformPermissionRequest(
        (request) {
          request.grant();
        },
      );
    }

    _controller.loadRequest(Uri.parse("http://localhost:8080/index.html"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(color: Color(0xFFE50914)),
              ),
          ],
        ),
      ),
    );
  }
}
