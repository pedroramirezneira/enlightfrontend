import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PaymentPage extends StatefulWidget {
  final String url;
  const PaymentPage({super.key,  required this.url});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;

  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              key: webViewKey,
              initialUrlRequest: URLRequest(url: WebUri(Uri.parse(widget.url).toString())),
              onUpdateVisitedHistory: (controller, url, androidIsReload){
                if (url.toString().contains("https://www.enlight.com/success")) {
                  webViewController?.goBack();
                  Navigator.pop(
                    context,
                    true,
                  );
                  return;
                } else if (url.toString().contains("https://www.enlight.com/failure")) {
                  webViewController?.goBack();
                  Navigator.pop(
                    context,
                    false,
                  );
                  return;
                } else if (url.toString().contains("https://www.enlight.com/pending")) {
                  webViewController?.goBack();
                  Navigator.pop(
                    context,
                    null,
                  );
                  return;
                }
              }
            )
          ],
        ),
      )
   );
  }
}