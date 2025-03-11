import 'dart:core';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../utils/config.dart';
import '../../widgets/api/custom_loading_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/plan_controller.dart';
import '../../services/paypal_service.dart';



class PaypalPayment extends StatefulWidget {
  final Function onFinish;

  const PaypalPayment({super.key, required this.onFinish});

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  final controller = Get.put(PlanController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? checkoutUrl;
  String? executeUrl;
  String? accessToken;
  PaypalServices services = PaypalServices();

  // you can change default currency according to your need
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "USD",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "USD"
  };

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.getAccessToken();

        final transactions = getOrderParams();
        final res =
        await services.createPaypalPayment(transactions, accessToken);
        setState(() {
          checkoutUrl = res["approvalUrl"]!;
          executeUrl = res["executeUrl"]!;
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  int quantity = 1;

  Map<String, dynamic> getOrderParams() {

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": ApiConfig.premiumSubscriptionFee.toString(),
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": ApiConfig.premiumSubscriptionFee.toString(),
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },

        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

  // ignore_for_file: deprecated_member_use
  @override
  Widget build(BuildContext context) {
    if (checkoutUrl != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          leading: GestureDetector(
            child: Icon(
                Icons.arrow_back_ios,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () => Navigator.pop(context),
          ),
        ),

        body: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse(checkoutUrl!)), // Replace with your checkout URL
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              javaScriptEnabled: true,
            ),
          ),
          onWebViewCreated: (InAppWebViewController controller) {
            // You can use the controller to interact with the WebView
          },
          onLoadStart: (InAppWebViewController controller, Uri? url) {
            if (url != null && url.toString().contains(returnURL)) {
              final payerID = url.queryParameters['PayerID'];
              if (payerID != null) {
                services.executePayment(executeUrl, payerID, accessToken).then((id) {
                  widget.onFinish(id);
                  Navigator.of(context).pop();
                });
              } else {
                Navigator.of(context).pop();
              }
            } else if (url != null && url.toString().contains(cancelURL)) {
              Navigator.of(context).pop();
            }
          },
        )

        // body: WebViewWidget(
        //   controller: WebViewController()
        //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
        //     ..setNavigationDelegate(
        //         NavigationDelegate(
        //             onNavigationRequest: (NavigationRequest request){
        //               if (request.url.contains(returnURL)) {
        //                 final uri = Uri.parse(request.url);
        //                 final payerID = uri.queryParameters['PayerID'];
        //                 if (payerID != null) {
        //                   services
        //                       .executePayment(executeUrl, payerID, accessToken)
        //                       .then((id) {
        //                     widget.onFinish(id);
        //                     Navigator.of(context).pop();
        //                   });
        //                 } else {
        //                   Navigator.of(context).pop();
        //                 }
        //                 Navigator.of(context).pop();
        //               }
        //               if (request.url.contains(cancelURL)) {
        //                 Navigator.of(context).pop();
        //               }
        //               return NavigationDecision.navigate;
        //             }
        //         )
        //     )
        //     ..loadRequest(Uri.parse(checkoutUrl!)),
        // ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: const Center(child: CustomLoadingAPI()),
      );
    }
  }
}