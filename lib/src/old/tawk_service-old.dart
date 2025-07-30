// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'event_bus.dart';
// import 'tawk_visitor.dart';
// import 'tawk.dart';
//
// class TawkService {
//   static final TawkService _instance = TawkService._internal();
//   factory TawkService() => _instance;
//   TawkService._internal();
//
//   HeadlessInAppWebView? _headlessWebView;
//   InAppWebViewController? _webViewController;
//   TawkController? _tawkController;
//   bool _isInitialized = false;
//   CookieManager cookieManager = CookieManager.instance();
//
//   Future<void> initialize({
//     required String directChatLink,
//     TawkVisitor? visitor,
//     int? maxChatCacheDuration,
//     Function? onLoad,
//     Function(String)? onLinkTap,
//     Function(String)? onAgentMessage,
//   }) async {
//     if (_isInitialized) return;
//
//     // Create a HeadlessInAppWebView for background operation
//     _headlessWebView = HeadlessInAppWebView(
//       initialUrlRequest: URLRequest(url: WebUri(directChatLink)),
//       initialSettings: InAppWebViewSettings(
//         supportZoom: false,
//         javaScriptEnabled: true,
//         javaScriptCanOpenWindowsAutomatically: true,
//       ),
//       onWebViewCreated: (controller) async {
//         _webViewController = controller;
//         _tawkController = TawkController(this);
//
//         // Set up JavaScript handlers
//         _webViewController!.addJavaScriptHandler(
//           handlerName: 'onAgentMessage',
//           callback: (args) {
//             var data = args[0];
//             String message = data['message'];
//             print('Received message from agent: $message');
//             // Publish to event bus
//             eventBus.fire(AgentMessageEvent(message));
//             // Call provided callback if any
//             if (onAgentMessage != null) {
//               onAgentMessage(message);
//             }
//           },
//         );
//
//         // Inject user scripts
//         await _webViewController!.addUserScript(
//           userScript: UserScript(
//             source: '''
//             window.Tawk_API = window.Tawk_API || {};
//             window.Tawk_API.onChatMessageAgent = function(message) {
//               window.flutter_inappwebview.callHandler('onAgentMessage', { message: message });
//             };
//             ''',
//             injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
//           ),
//         );
//       },
//       onReceivedServerTrustAuthRequest: (controller, challenge) async {
//         return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
//       },
//       shouldOverrideUrlLoading: (controller, navigationAction) async {
//         URLRequest request = navigationAction.request;
//         if (request.url == null ||
//             request.url.toString() == 'about:blank' ||
//             request.url!.toString().contains('tawk.to/chat')) {
//           return NavigationActionPolicy.ALLOW;
//         }
//         if (onLinkTap != null) {
//           onLinkTap(request.url.toString());
//         }
//         return NavigationActionPolicy.CANCEL;
//       },
//       onLoadStop: (controller, url) async {
//         if (visitor != null) {
//           String javascriptString = '''
//             setTimeout(function () {
//               if (typeof Tawk_API !== "undefined") {
//                 Tawk_API.setAttributes(${jsonEncode(visitor.toJson())}, function (error) {
//                   if (error) {
//                     console.log("TAWKERROR: " + error);
//                   } else {
//                     console.log("Attributes set successfully");
//                   }
//                 });
//               } else {
//                 console.error("Tawk_API is not defined even after delay.");
//               }
//             }, 3000);
//           ''';
//           await _webViewController!.evaluateJavascript(source: javascriptString);
//         }
//         if (onLoad != null) {
//           onLoad();
//         }
//         _isInitialized = true;
//       },
//     );
//
//     // Start the headless WebView
//     await _headlessWebView!.run();
//
//     // Optionally handle cache duration
//     if (maxChatCacheDuration != null) {
//       // Implement cache clearing logic if needed
//       // e.g., cookieManager.deleteAllCookies() after maxChatCacheDuration
//     }
//   }
//
//   // Get the WebView widget for embedding
//   Widget getWebViewWidget({Widget? placeholder}) {
//     return Stack(
//       children: [
//         InAppWebView(
//           initialUrlRequest: _webViewController != null
//               ? null
//               : URLRequest(url: WebUri('about:blank')), // Fallback if not initialized
//           initialSettings: InAppWebViewSettings(
//             supportZoom: false,
//             javaScriptEnabled: true,
//             javaScriptCanOpenWindowsAutomatically: true,
//           ),
//           onWebViewCreated: (controller) async {
//             if (_webViewController != null) {
//               // Reuse the existing controller
//               controller.loadUrl(urlRequest: URLRequest(url: WebUri('about:blank')));
//               // Sync settings and scripts if needed
//             }
//           },
//         ),
//         if (!_isInitialized)
//           placeholder ?? const Center(child: CircularProgressIndicator()),
//       ],
//     );
//   }
//
//   // Get the TawkController for controlling the chat
//   TawkController? getController() => _tawkController;
//
//   // Clean up resources
//   void dispose() {
//     _headlessWebView?.dispose();
//     _webViewController = null;
//     _tawkController = null;
//     _isInitialized = false;
//   }
// }


// tawk_service.dart
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../event_bus.dart';
import '../tawk_visitor.dart';

class TawkService {
  static final TawkService _instance = TawkService._internal();
  factory TawkService() => _instance;
  TawkService._internal();

  HeadlessInAppWebView? _headlessWebView;
  InAppWebViewController? _webViewController;
  bool _isInitialized = false;
  CookieManager cookieManager = CookieManager.instance();

  Future<void> initialize({
    required String directChatLink,
    TawkVisitor? visitor,
    int? maxChatCacheDuration,
    Function? onLoad,
    Function(String)? onLinkTap,
    Function(String)? onAgentMessage,
  }) async {
    if (_isInitialized) return;

    // Create a HeadlessInAppWebView for background operation
    _headlessWebView = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(directChatLink)),
      initialSettings: InAppWebViewSettings(
        supportZoom: false,
        javaScriptEnabled: true,
        javaScriptCanOpenWindowsAutomatically: true,
      ),
      onWebViewCreated: (controller) async {
        _webViewController = controller;

        // Set up JavaScript handlers
        _webViewController!.addJavaScriptHandler(
          handlerName: 'onAgentMessage',
          callback: (args) {
            var data = args[0];
            print(data);
            String message = data['message'];
            print('Received message from agent: $message');
            // Publish to event bus
            eventBus.fire(AgentMessageEvent(message));
            // Call provided callback if any
            if (onAgentMessage != null) {
              onAgentMessage(message);
            }
          },
        );

        // Inject user scripts
        await _webViewController!.addUserScript(
          userScript: UserScript(
            source: '''
            window.Tawk_API = window.Tawk_API || {};
            window.Tawk_API.onChatMessageAgent = function(message) {
              window.flutter_inappwebview.callHandler('onAgentMessage', message);
            };
            ''',
            injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
          ),
        );
      },
      onReceivedServerTrustAuthRequest: (controller, challenge) async {
        return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        URLRequest request = navigationAction.request;
        if (request.url == null ||
            request.url.toString() == 'about:blank' ||
            request.url!.toString().contains('tawk.to/chat')) {
          return NavigationActionPolicy.ALLOW;
        }
        if (onLinkTap != null) {
          onLinkTap(request.url.toString());
        }
        return NavigationActionPolicy.CANCEL;
      },
      onLoadStop: (controller, url) async {
        if (visitor != null) {
          String javascriptString = '''
            setTimeout(function () {
              if (typeof Tawk_API !== "undefined") {
                Tawk_API.setAttributes(${jsonEncode(visitor.toJson())}, function (error) {
                  if (error) {
                    console.log("TAWKERROR: " + error);
                  } else {
                    console.log("Attributes set successfully");
                  }
                });
              } else {
                console.error("Tawk_API is not defined even after delay.");
              }
            }, 3000);
          ''';
          await _webViewController!.evaluateJavascript(source: javascriptString);
        }
        if (onLoad != null) {
          onLoad();
        }
        _isInitialized = true;
      },
    );

    // Start the headless WebView
    await _headlessWebView!.run();

    // Optionally handle cache duration
    if (maxChatCacheDuration != null) {
      // Implement cache clearing logic if needed
      // e.g., cookieManager.deleteAllCookies() after maxChatCacheDuration
    }
  }

  // Get the WebView widget for embedding
  Widget getWebViewWidget({Widget? placeholder}) {
    // Create a copy of the headless WebView for display
    return Stack(
      children: [
        InAppWebView(
          headlessWebView: _headlessWebView,
        ),
        if (!_isInitialized)
          placeholder ?? const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  // Get the InAppWebViewController directly
  InAppWebViewController? getWebViewController() => _webViewController;

  // Clean up resources
  void dispose() {
    _headlessWebView?.dispose();
    _webViewController = null;
    _isInitialized = false;
  }
}