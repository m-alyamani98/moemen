import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class IAPScreen extends StatefulWidget {
  @override
  _IAPScreenState createState() => _IAPScreenState();
}

class _IAPScreenState extends State<IAPScreen> {
  final iap = InAppPurchase.instance;
  List<ProductDetails> products = [];
  StreamSubscription? purchaseSubscription;

  @override
  void initState() {
    super.initState();
    initializeIAP();
  }

  Future<void> initializeIAP() async {
    bool available = await iap.isAvailable();
    if (!available) return;

    await fetchProducts();
    listenToPurchases();
  }

  Future<void> fetchProducts() async {
    Set<String> productIds = {'com.example.premium'};
    ProductDetailsResponse response = await iap.queryProductDetails(productIds);
    setState(() => products = response.productDetails);
  }

  void listenToPurchases() {
    purchaseSubscription = iap.purchaseStream.listen((purchases) {
      for (PurchaseDetails purchase in purchases) {
        if (purchase.status == PurchaseStatus.purchased) {
          _verifyAndDeliver(purchase);
        }
      }
    });
  }

  Future<void> _verifyAndDeliver(PurchaseDetails purchase) async {
    if (await _verifyPurchase(purchase)) {
      iap.completePurchase(purchase);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Purchase successful!')),
      );
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchase) async {
    // Use Google's API to verify the purchase.
    // For local testing, return `true` temporarily.
    return true;
  }

  @override
  void dispose() {
    purchaseSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          ProductDetails product = products[index];
          return ListTile(
            title: Text(product.title),
            subtitle: Text(product.price),
            onTap: () => iap.buyNonConsumable(
              purchaseParam: PurchaseParam(productDetails: product),
            ),
          );
        },
      ),
    );
  }
}