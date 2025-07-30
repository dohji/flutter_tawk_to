// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'event_bus.dart';
// import 'tawk_visitor.dart';
//
// class TawkService {
//   static final TawkService _instance = TawkService._internal();
//   factory TawkService() => _instance;
//   TawkService._internal();
//
//   HeadlessInAppWebView? _headlessWebView;
//   InAppWebViewController? _webViewController;
//   bool _isInitialized = false;
//   CookieManager cookieManager = CookieManager.instance();
//   String? _directChatLink;
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
//     _directChatLink = directChatLink;
//
//     // Create a HeadlessInAppWebView for background operation
//     _headlessWebView = HeadlessInAppWebView(
//       initialUrlRequest: URLRequest(url: WebUri(directChatLink)),
//       initialSettings: InAppWebViewSettings(
//         supportZoom: false,
//         javaScriptEnabled: true,
//         javaScriptCanOpenWindowsAutomatically: true,
//         clearCache: false,
//       ),
//       onWebViewCreated: (controller) async {
//         _webViewController = controller;
//
//         // Inject user scripts for agent messages
//         await _webViewController!.addUserScript(
//           userScript: UserScript(
//             source: '''
//             window.Tawk_API = window.Tawk_API || {};
//             window.Tawk_API.onChatMessageAgent = function(message) {
//               window.flutter_inappwebview.callHandler('onAgentMessage', message);
//             };
//             ''',
//             injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
//           ),
//         );
//
//         // Set up JavaScript handler for agent messages
//         _webViewController!.addJavaScriptHandler(
//           handlerName: 'onAgentMessage',
//           callback: (args) {
//             var data = args[0];
//             String message = data['message'] ?? '';
//             print('Received message from agent: $message');
//             // Publish to event bus
//             eventBus.fire(AgentMessageEvent(message));
//             // Call provided callback if any
//             if (onAgentMessage != null) {
//               onAgentMessage(message);
//             }
//           },
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
//   }
//
//   // Get the WebView widget for embedding
//   Widget getWebViewWidget({Widget? placeholder}) {
//     bool showPlaceholder = true;
//     return StatefulBuilder(
//       builder: (context, setState) {
//         return Stack(
//           children: [
//             InAppWebView(
//               initialUrlRequest: URLRequest(url: WebUri(_directChatLink ?? 'about:blank')),
//               initialSettings: InAppWebViewSettings(
//                 supportZoom: false,
//                 javaScriptEnabled: true,
//                 javaScriptCanOpenWindowsAutomatically: true,
//                 clearCache: false,
//               ),
//               onWebViewCreated: (controller) async {
//                 if (_webViewController == null) {
//                   _webViewController = controller;
//                   await _webViewController!.addUserScript(
//                     userScript: UserScript(
//                       source: '''
//                     window.Tawk_API = window.Tawk_API || {};
//                     window.Tawk_API.onChatMessageAgent = function(message) {
//                       window.flutter_inappwebview.callHandler('onAgentMessage', message);
//                     };
//                     ''',
//                       injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
//                     ),
//                   );
//                   _webViewController!.addJavaScriptHandler(
//                     handlerName: 'onAgentMessage',
//                     callback: (args) {
//                       var data = args[0];
//                       String message = data['message'] ?? '';
//                       print('Received message from agent (UI): $message');
//                       eventBus.fire(AgentMessageEvent(message));
//                     },
//                   );
//                 }
//               },
//               onReceivedServerTrustAuthRequest: (controller, challenge) async {
//                 return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
//               },
//               shouldOverrideUrlLoading: (controller, navigationAction) async {
//                 URLRequest request = navigationAction.request;
//                 if (request.url == null ||
//                     request.url.toString() == 'about:blank' ||
//                     request.url!.toString().contains('tawk.to/chat')) {
//                   return NavigationActionPolicy.ALLOW;
//                 }
//                 return NavigationActionPolicy.CANCEL;
//               },
//               onLoadStop: (controller, url) async {
//                 Future.delayed(Duration(seconds: 2), () {
//                   setState(() {
//                     showPlaceholder = false;
//                   });
//                 });
//               },
//             ),
//             // Show placeholder for 3 seconds and then hide it
//             if (showPlaceholder == true)...[
//               placeholder ??
//               Container(
//                     width: double.infinity,
//                     height: double.infinity,
//                     color: Colors.white,
//                     child: Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           CircularProgressIndicator(),
//                           SizedBox(height: 16),
//                           Text(
//                             'Loading Chat...',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//             ],
//           ],
//         );
//       },
//     );
//   }
//
//   // Get the InAppWebViewController directly
//   InAppWebViewController? getWebViewController() => _webViewController;
//
//   // Clean up resources
//   void dispose() {
//     _headlessWebView?.dispose();
//     _webViewController = null;
//     _isInitialized = false;
//   }
// }


/// A singleton service class for managing Tawk.to chat integration in a Flutter application.
/// This class handles the initialization and management of a headless WebView for background
/// chat operations and provides a WebView widget for embedding the chat UI.
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'event_bus.dart';
import 'tawk_visitor.dart';

class TawkService {
  /// Private singleton instance of the TawkService.
  static final TawkService _instance = TawkService._internal();

  /// Factory constructor to access the singleton instance.
  factory TawkService() => _instance;

  /// Private constructor for internal initialization.
  TawkService._internal();

  /// Headless WebView for running Tawk.to chat in the background.
  HeadlessInAppWebView? _headlessWebView;

  /// Controller for managing WebView interactions.
  InAppWebViewController? _webViewController;

  /// Flag to track initialization status.
  bool _isInitialized = false;

  /// Cookie manager for handling WebView cookies.
  CookieManager cookieManager = CookieManager.instance();

  /// Stores the direct chat link for Tawk.to.
  String? _directChatLink;

  /// Initializes the Tawk.to chat service with the provided configuration.
  ///
  /// Parameters:
  /// - `directChatLink`: The URL for the Tawk.to chat widget.
  /// - `visitor`: Optional visitor information to set Tawk.to attributes.
  /// - `maxChatCacheDuration`: Optional duration for caching chat data (not currently used).
  /// - `onLoad`: Optional callback triggered when the WebView finishes loading.
  /// - `onLinkTap`: Optional callback for handling link taps outside Tawk.to domain.
  /// - `onAgentMessage`: Optional callback for handling messages from Tawk.to agents.
  Future<void> initialize({
    required String directChatLink,
    TawkVisitor? visitor,
    int? maxChatCacheDuration,
    Function? onLoad,
    Function(String)? onLinkTap,
    Function(String)? onAgentMessage,
  }) async {
    if (_isInitialized) return;

    _directChatLink = directChatLink;

    // Create a HeadlessInAppWebView for background operation
    _headlessWebView = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(directChatLink)),
      initialSettings: InAppWebViewSettings(
        supportZoom: false,
        javaScriptEnabled: true,
        javaScriptCanOpenWindowsAutomatically: true,
        clearCache: false,
      ),
      onWebViewCreated: (controller) async {
        _webViewController = controller;

        // Inject user scripts for agent messages
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

        // Set up JavaScript handler for agent messages
        _webViewController!.addJavaScriptHandler(
          handlerName: 'onAgentMessage',
          callback: (args) {
            var data = args[0];
            String message = data['message'] ?? '';
            print('Received message from agent: $message');
            // Publish to event bus
            eventBus.fire(AgentMessageEvent(message));
            // Call provided callback if any
            if (onAgentMessage != null) {
              onAgentMessage(message);
            }
          },
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
  }

  /// Returns a WebView widget for embedding the Tawk.to chat UI.
  ///
  /// Parameters:
  /// - `placeholder`: Optional widget to display while the chat is loading.
  ///
  /// Returns a `Widget` containing the chat WebView with an optional placeholder.
  Widget getWebViewWidget({Widget? placeholder}) {
    bool showPlaceholder = true;
    return StatefulBuilder(
      builder: (context, setState) {
        return Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(_directChatLink ?? 'about:blank')),
              initialSettings: InAppWebViewSettings(
                supportZoom: false,
                javaScriptEnabled: true,
                javaScriptCanOpenWindowsAutomatically: true,
                clearCache: false,
              ),
              onWebViewCreated: (controller) async {
                if (_webViewController == null) {
                  _webViewController = controller;
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
                  _webViewController!.addJavaScriptHandler(
                    handlerName: 'onAgentMessage',
                    callback: (args) {
                      var data = args[0];
                      String message = data['message'] ?? '';
                      print('Received message from agent (UI): $message');
                      eventBus.fire(AgentMessageEvent(message));
                    },
                  );
                }
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
                return NavigationActionPolicy.CANCEL;
              },
              onLoadStop: (controller, url) async {
                Future.delayed(Duration(seconds: 2), () {
                  setState(() {
                    showPlaceholder = false;
                  });
                });
              },
            ),
            // Show placeholder for 3 seconds and then hide it
            if (showPlaceholder == true)...[
              placeholder ??
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.white,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            'Loading Chat...',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            ],
          ],
        );
      },
    );
  }

  /// Returns the current WebView controller for direct manipulation.
  ///
  /// Returns the `InAppWebViewController` if available, otherwise null.
  InAppWebViewController? getWebViewController() => _webViewController;

  /// Disposes of the WebView resources and resets the initialization state.
  void dispose() {
    _headlessWebView?.dispose();
    _webViewController = null;
    _isInitialized = false;
  }
}