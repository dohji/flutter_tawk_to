// import 'dart:collection';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'tawk_visitor.dart';
// import 'package:flutter_tawk/src/event_bus.dart';
//
// class TawkController {
//   final InAppWebViewController _controller;
//   TawkController(this._controller);
//
//   Future<bool> isChatOngoing() async {
//     String script = '''
// var Tawk_API = Tawk_API || {};
// Tawk_API.isChatOngoing();
// ''';
//     return await _controller.evaluateJavascript(source: script);
//   }
//
//   Future<bool> isVisitorEngaged() async {
//     String script = '''
// var Tawk_API = Tawk_API || {};
// Tawk_API.isVisitorEngaged();
// ''';
//     return await _controller.evaluateJavascript(source: script);
//   }
//
//   void endChat() {
//     String script = '''
// var Tawk_API = Tawk_API || {};
// Tawk_API.endChat();
// ''';
//     _controller.evaluateJavascript(source: script);
//   }
//
//   Future<bool> canGoBack() => _controller.canGoBack();
//   Future<void> goBack() => _controller.goBack();
// }
//
// /// [Tawk] Widget.
// class Tawk extends StatefulWidget {
//   /// Tawk direct chat link.
//   final String directChatLink;
//
//   /// Object used to set the visitor name and email.
//   final TawkVisitor? visitor;
//
//   /// Max chat cache duration in milliseconds.   E.g. (8 * 60 * 60 * 1000) for 8 hours
//   final int? maxChatCacheDuration;
//
//   /// Called right after the widget is rendered.
//   final Function? onLoad;
//
//   /// Called when a link pressed.
//   final Function(String)? onLinkTap;
//
//   /// Called when a message is received from the agent.
//   final Function(String)? onAgentMessage;
//
//   /// Render your own loading widget.
//   final Widget? placeholder;
//   final ValueChanged<TawkController?>? onControllerChanged;
//
//   const Tawk({
//     Key? key,
//     required this.directChatLink,
//     this.visitor,
//     this.maxChatCacheDuration,
//     this.onLoad,
//     this.onLinkTap,
//     this.placeholder,
//     this.onControllerChanged,
//     this.onAgentMessage,
//   }) : super(key: key);
//
//   @override
//   _TawkState createState() => _TawkState();
// }
//
// class _TawkState extends State<Tawk> with AutomaticKeepAliveClientMixin{
//
//   @override
//   bool get wantKeepAlive => true;
//
//
//   bool _isLoading = true;
//   late CookieManager cookieManager;
//   TawkController? _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     cookieManager = CookieManager.instance();
//   }
//
//   Future<void> _setUser(TawkVisitor visitor) async {
//     String javascriptString = '''
//       setTimeout(function () {
//       if (typeof Tawk_API !== "undefined") {
//         Tawk_API.setAttributes(${jsonEncode(visitor.toJson())}, function (error) {
//           if (error) {
//             console.log("TAWKERROR: " + error);
//           } else {
//             console.log("Attributes set successfully");
//           }
//         });
//       } else {
//         console.error("Tawk_API is not defined even after delay.");
//       }
//       }, 3000);
//       ''';
//     await _controller?._controller.evaluateJavascript(source: javascriptString);
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return ColoredBox(
//       color: Colors.white,
//       child: SafeArea(
//         child: Stack(
//           children: [
//             InAppWebView(
//               initialUrlRequest: URLRequest(url: WebUri(widget.directChatLink)),
//               initialSettings: InAppWebViewSettings(
//                 supportZoom: false,
//                 javaScriptEnabled: true,
//                 javaScriptCanOpenWindowsAutomatically: true,
//               ),
//               onReceivedServerTrustAuthRequest: (controller, challenge) async {
//                 return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
//               },
//               initialUserScripts: UnmodifiableListView<UserScript>([
//               UserScript(
//                   source: '''
//                   window.Tawk_API = window.Tawk_API || {};
//                   window.Tawk_API.onChatMessageAgent = function(message) {
//                     window.flutter_inappwebview.callHandler('onAgentMessage', message);
//                   };
//                   ''',
//                   injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END),
//               ]),
//               onWebViewCreated: (InAppWebViewController webViewController) async {
//                 setState(() {
//                   _controller = TawkController(webViewController);
//                 });
//                 if (widget.onControllerChanged != null) {
//                   widget.onControllerChanged!(_controller);
//                 }
//
//                 _controller?._controller.addJavaScriptHandler(
//                   handlerName: 'onAgentMessage',
//                   callback: (args) {
//                     var data = args[0];
//                     String message = data['message'] ?? "New message from agent";
//                     print('Received message from agent: $message');
//                     // Publish the message to the event bus
//                     eventBus.fire(AgentMessageEvent(message));
//                     // Call the existing onAgentMessage callback if provided
//                     if (widget.onAgentMessage != null) {
//                       widget.onAgentMessage!(message);
//                     }
//                   },
//                 );
//
//               },
//               shouldOverrideUrlLoading: (controller, navigationAction) async {
//                 URLRequest request = navigationAction.request;
//                 if (request.url == null ||
//                     request.url.toString() == 'about:blank' ||
//                     request.url!.toString().contains('tawk.to/chat')) {
//                   return NavigationActionPolicy.ALLOW;
//                 }
//
//                 if (widget.onLinkTap != null) {
//                   widget.onLinkTap!(request.url.toString());
//                 }
//
//                 return NavigationActionPolicy.CANCEL;
//               },
//               onLoadStop: (controller, url) async {
//                 if (widget.visitor != null) {
//                     _setUser(widget.visitor!);
//                 }
//                 if (widget.onLoad != null) {
//                   widget.onLoad!();
//                 }
//
//                 setState(() {
//                   _isLoading = false;
//                 });
//               },
//             ),
//             _isLoading
//                 ? widget.placeholder ??
//                     const Center(
//                       child: CircularProgressIndicator(),
//                     )
//                 : Container(),
//           ],
//         ),
//       ),
//     );
//   }
// }