import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:collection/collection.dart'; // Import for firstWhereOrNull

import '../../app/resources/color_manager.dart';
import '../../app/resources/routes_manager.dart';
import '../../app/resources/values.dart';

class SupportAppPage extends StatefulWidget {
  @override
  _SupportAppPageState createState() => _SupportAppPageState();
}

class _SupportAppPageState extends State<SupportAppPage> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  bool _isAvailable = false;
  List<ProductDetails> _products = [];
  bool _purchasePending = false;
  String? _queryProductError;
  String selectedProductId = "donation_999"; // Default to 9.99 product
  String selectedPaymentType = 'مرة واحدة';

  // Product IDs
  final List<String> _donationProductIds = [
    "donation_999",
    "donation_1999",
    "donation_4999",
    "donation_9999"
  ];

  @override
  void initState() {
    super.initState();
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
          (purchaseDetailsList) {
        _handlePurchaseUpdates(purchaseDetailsList);
      },
      onDone: () {
        _subscription.cancel();
      },
      onError: (error) {
        print("Purchase Stream Error: $error");
      },
    );
    _initStore();
  }

  Future<void> _initStore() async {
    _isAvailable = await _inAppPurchase.isAvailable();
    if (!_isAvailable) {
      setState(() {});
      return;
    }

    final ProductDetailsResponse response =
    await _inAppPurchase.queryProductDetails(_donationProductIds.toSet());

    if (response.error != null) {
      setState(() {
        _queryProductError = response.error!.message;
      });
      return;
    }

    setState(() {
      _products = response.productDetails;
    });
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    for (final purchaseDetails in purchaseDetailsList) {
      print("🔄 Processing purchase: ${purchaseDetails.productID}");

      if (purchaseDetails.status == PurchaseStatus.pending) {
        print("⏳ Purchase pending...");
        setState(() {
          _purchasePending = true;
        });
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        print("✅ Purchase successful: ${purchaseDetails.productID}");
        _verifyPurchase(purchaseDetails);
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        print("❌ Purchase error: ${purchaseDetails.error?.message}");
        setState(() {
          _purchasePending = false;
        });
      }

      if (purchaseDetails.pendingCompletePurchase) {
        print("🔄 Completing purchase...");
        _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  Future<void> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    print("Purchase Verified: ${purchaseDetails.productID}");
    setState(() {
      _purchasePending = false;
    });
  }

  void _purchaseProduct(String productId) {
    final product = _products.firstWhereOrNull((p) => p.id == selectedProductId);

    if (product == null) {
      print("⚠ No products available.");
      return;
    }

    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "دعم التطبيق ",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: ColorManager.primary),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset(
            'assets/images/logoico.svg',
            width: AppSize.s20.r,
            height: AppSize.s20.r,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, Routes.homeRoute),
            icon: Icon(FluentIcons.chevron_left_48_regular, color: ColorManager.iconPrimary),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset(
                'assets/images/pay.svg',
                width: AppSize.s200.r,
                height: AppSize.s200.r,
              ),
            ),
            SizedBox(height: AppSize.s20.r),
            Text(
              'قم بدعم تطبيق مؤمن الآن',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSize.s12.r),
            Text(
              'ساهم بعطائك في دعم التطبيق لنشر كتاب الله وليكن لك\nبكل حرف يأتي أجر وثواب.',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSize.s35.r),
            Text(
              'اختر المبلغ الذي تريده',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            _isAvailable
                ? Column(
              children: [
                if (_queryProductError != null)
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(_queryProductError!,
                        style: TextStyle(color: Colors.red)),
                  ),
                Wrap(
                  spacing: 10,
                  children: _products.map((product) {
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedProductId = product.id;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedProductId == product.id
                            ? ColorManager.primary
                            : Colors.white,
                        side: BorderSide(color: ColorManager.primary, width: 1),
                        foregroundColor: selectedProductId == product.id
                            ? Colors.white
                            : ColorManager.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: Text(
                        product.price,
                        style: GoogleFonts.tajawal(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                ),
                if (_purchasePending) CircularProgressIndicator(),
              ],
            )
                : Center(child: Text('Store not available')),
            SizedBox(height: AppSize.s50.r),
            Center(
              child: SizedBox(
                width: AppSize.s250.r,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    _purchaseProduct(selectedProductId);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: ColorManager.primary,
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text("دعم التطبيق "),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
