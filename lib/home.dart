import 'package:flutter/material.dart';
import 'package:flutter_esewa/constants/constants.dart';
import 'package:flutter_esewa/models/esewa_payment_model.dart';
import 'package:flutter_esewa/services/esewa_service.dart';
import 'package:flutter_esewa/widgets/payment_button.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isLoading = false;
  final EsewaPaymentModel _paymentDetails = EsewaPaymentModel(
    productId: DateTime.now().millisecondsSinceEpoch.toString(),
    productName: "Blue Jeans",
    amount: "1000",
    callbackUrl: "https://your-server.com/callback",
  );

  Future<void> _initiatePayment() async {
    setState(() => _isLoading = true);

    await EsewaService.initiatePayment(
      payment: _paymentDetails,
      onSuccess: _handlePaymentSuccess,
      onFailure: _handlePaymentFailure,
      onCancellation: _handlePaymentCancellation,
    );

    setState(() => _isLoading = false);
  }

  void _handlePaymentSuccess(EsewaPaymentSuccessResult data) {
    debugPrint(":::SUCCESS::: => $data");
    _verifyTransactionOnServer(data.refId);
  }

  void _handlePaymentFailure(dynamic data) {
    debugPrint(":::FAILURE::: => $data");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment failed: $data'),
        backgroundColor: errorColor,
      ),
    );
  }

  void _handlePaymentCancellation(dynamic data) {
    debugPrint(":::CANCELLATION::: => $data");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment was cancelled.'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Future<void> _verifyTransactionOnServer(String refId) async {
    setState(() => _isLoading = true);

    final result = await EsewaService.verifyTransaction(refId);

    setState(() => _isLoading = false);

    if (result['success'] == true) {
      if (result['status'] == 'COMPLETE') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment Verified Successfully!'),
            backgroundColor: accentColor,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transaction status: ${result['status']}'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification failed: ${result['error']}'),
          backgroundColor: errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'eSewa Payment Gateway',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Payment Details Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(
                      Icons.shopping_bag,
                      size: 64,
                      color: primaryColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _paymentDetails.productName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'NPR ${_paymentDetails.amount}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Secure payment powered by eSewa',
                      style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            PaymentButton(
              onPressed: _initiatePayment,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Text(
                'Processing...',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
      ),
    );
  }
}