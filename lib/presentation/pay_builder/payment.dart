import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:moemen/app/resources/color_manager.dart';
import 'package:moemen/app/resources/routes_manager.dart';
import 'package:moemen/app/resources/values.dart';

class SupportAppPage extends StatefulWidget {
  @override
  _SupportAppPageState createState() => _SupportAppPageState();
}

class _SupportAppPageState extends State<SupportAppPage> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  List<ProductDetails> _products = [];
  String selectedAmount = '';
  String selectedPaymentType = 'اشتراك شهري';

  final Map<String, String> _productIdMap = {
    "\$9.99": "donation_9_99",
    "\$19.99": "donation_19_99",
    "\$49.99": "donation_49_99",
    "\$99.99": "donation_99_99",
  };

  @override
  void initState() {
    super.initState();
    _initializePurchase();
  }

  void _initializePurchase() async {
    final available = await _inAppPurchase.isAvailable();
    if (!available) {
      print("In-app purchases not available");
      return;
    }

    final productIds = _productIdMap.values.toSet();
    final response = await _inAppPurchase.queryProductDetails(productIds);

    if (response.error != null) {
      print("Error fetching products: ${response.error}");
    } else {
      setState(() {
        _products = response.productDetails;
      });
    }
  }

  void _makePurchase() async {
    if (selectedAmount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("يرجى اختيار مبلغ الدعم"),
          backgroundColor: ColorManager.primary,
        ),
      );
      return;
    }

    final productId = _productIdMap[selectedAmount] ?? "";
    final productDetails =
    _products.firstWhere(
          (product) => product.id == productId,
      orElse: () => ProductDetails(
          id: '',
          title: 'Unknown Product',
          description: 'No description available',
          price: '\$0.00',
          rawPrice: 0.0,
          currencyCode: 'USD'
      ),
    );


    if (productDetails.id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("لم يتم العثور على المنتج"),
          backgroundColor: ColorManager.primary,
        ),
      );
      return;
    }

    final purchaseParam = PurchaseParam(productDetails: productDetails);

    _inAppPurchase.buyConsumable(
      purchaseParam: purchaseParam,
      autoConsume: true,
    );
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
            icon: Icon(FluentIcons.chevron_left_48_regular, color: ColorManager.iconPrimary,),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSize.s12.r),
            Text(
              'ساهم بعطائك في دعم التطبيق لنشر كتاب الله وليكن لك\nبكل حرف يأتي أجر وثواب. قم بدعمنا ليستمر التطبيق\nودون إعلانات.\n\nكن جزءًا من هذا المشروع الذي يعين ملايين المسلمين على\nختم القرآن يوميًا.',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSize.s35.r),
            Text(
              'اختر المبلغ الذي تريده',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSize.s20.r),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildRadioButton('مرة واحدة'),
                SizedBox(width: 20),
                _buildRadioButton('اشتراك شهري'),
              ],
            ),
            SizedBox(height: AppSize.s20.r),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: _productIdMap.keys.map((price) => _buildDonationButton(price)).toList(),
            ),
            SizedBox(height: AppSize.s50.r),
            Center(
              child: SizedBox(
                width: AppSize.s250.r,
                height: 50,
                child: ElevatedButton(
                  onPressed: _makePurchase,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: ColorManager.primary,
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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

  Widget _buildDonationButton(String amount) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedAmount = amount;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedAmount == amount ? ColorManager.primary : Colors.white,
        side: BorderSide(color: ColorManager.primary, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(
        amount,
        style: TextStyle(
          fontSize: 16,
          color: selectedAmount == amount ? Colors.white : ColorManager.primary,
        ),
      ),
    );
  }

  Widget _buildRadioButton(String label) {
    return Row(
      children: [
        Radio<String>(
          value: label,
          groupValue: selectedPaymentType,
          onChanged: (value) {
            setState(() {
              selectedPaymentType = value!;
            });
          },
          activeColor: ColorManager.primary,
        ),
        Text(
          label,
          style: TextStyle(fontSize: 16, color: ColorManager.primary),
        ),
      ],
    );
  }
}
