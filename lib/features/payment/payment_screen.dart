import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/payment_cubit.dart';
import 'models/payment_model.dart';
import 'dart:io';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _saveCard = false;
  bool _payWithCard = true;
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvcController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  String? _cardType;

  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'رقم البطاقة مطلوب';
    }
    final cleanNumber = value.replaceAll(' ', '');
    if (cleanNumber.length != 16) {
      return 'يجب أن يكون رقم البطاقة 16 رقماً';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(cleanNumber)) {
      return 'يجب أن يحتوي رقم البطاقة على أرقام فقط';
    }
    final paymentCubit = context.read<PaymentCubit>();
    if (!paymentCubit.validateLuhn(value)) {
      return 'رقم البطاقة غير صالح';
    }
    return null;
  }

  String? _validateExpiry(String? value) {
    if (value == null || value.isEmpty) {
      return 'تاريخ الانتهاء مطلوب';
    }
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
      return 'الصيغة يجب أن تكون MM/YY';
    }
    final parts = value.split('/');
    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);
    if (month == null || month < 1 || month > 12) {
      return 'الشهر غير صالح';
    }
    if (year == null) {
      return 'السنة غير صالحة';
    }
    final now = DateTime.now();
    final cardYear = 2000 + year;
    if (cardYear < now.year || (cardYear == now.year && month < now.month)) {
      return 'البطاقة منتهية الصلاحية';
    }
    return null;
  }

  String? _validateCVC(String? value) {
    if (value == null || value.isEmpty) {
      return 'رمز الأمان مطلوب';
    }
    if (value.length != 3) {
      return 'يجب أن يكون رمز الأمان 3 أرقام';
    }
    if (!RegExp(r'^\d{3}$').hasMatch(value)) {
      return 'يجب أن يحتوي رمز الأمان على أرقام فقط';
    }
    return null;
  }

  void _formatCardNumber(String value) {
    final numbers = value.replaceAll(' ', '');
    if (numbers.length > 16) return;

    final buffer = StringBuffer();
    for (int i = 0; i < numbers.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(numbers[i]);
    }

    _cardNumberController.value = TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.toString().length),
    );

    // Determine card type
    if (numbers.startsWith('4')) {
      setState(() => _cardType = 'visa');
    } else if (numbers.startsWith('5')) {
      setState(() => _cardType = 'mastercard');
    } else if (numbers.startsWith('3')) {
      setState(() => _cardType = 'amex');
    } else {
      setState(() => _cardType = null);
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    super.dispose();
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Payment'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Apple Pay Option
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: RadioListTile<bool>(
                value: false,
                groupValue: _payWithCard,
                onChanged: (value) {
                  setState(() {
                    _payWithCard = value!;
                  });
                },
                title: Row(
                  children: [
                    Image.asset('assets/apple_pay.png', height: 24),
                    const SizedBox(width: 8),
                    const Text('Apple pay'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Credit Card Option
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: RadioListTile<bool>(
                value: true,
                groupValue: _payWithCard,
                onChanged: (value) {
                  setState(() {
                    _payWithCard = value!;
                  });
                },
                title: Row(
                  children: [
                    const Icon(Icons.credit_card),
                    const SizedBox(width: 8),
                    const Text('Pay with card'),
                  ],
                ),
              ),
            ),
            if (_payWithCard) ...[
              const SizedBox(height: 24),
              const Text('Card number'),
              const SizedBox(height: 8),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _cardNumberController,
                  decoration: InputDecoration(
                    hintText: '1234 5678 9012 3456',
                    errorStyle: const TextStyle(color: Colors.red),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_cardType == 'mastercard')
                          Image.asset(
                            'assets/mastercard.png',
                            height: 24,
                            color: Colors.blue,
                          )
                        else
                          Image.asset('assets/mastercard.png', height: 24),
                        const SizedBox(width: 8),
                        if (_cardType == 'visa')
                          Image.asset(
                            'assets/visa.png',
                            height: 24,
                            color: Colors.blue,
                          )
                        else
                          Image.asset('assets/visa.png', height: 24),
                        const SizedBox(width: 8),
                        if (_cardType == 'amex')
                          Image.asset(
                            'assets/amex.png',
                            height: 24,
                            color: Colors.blue,
                          )
                        else
                          Image.asset('assets/amex.png', height: 24),
                      ],
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: _validateCardNumber,
                  onChanged: _formatCardNumber,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Expiry'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _expiryController,
                          decoration: const InputDecoration(
                            hintText: 'MM/YY',
                            errorStyle: TextStyle(color: Colors.red),
                          ),
                          keyboardType: TextInputType.number,
                          validator: _validateExpiry,
                          onChanged: (value) {
                            if (value.length == 2 && !value.contains('/')) {
                              _expiryController.text = '$value/';
                              _expiryController
                                  .selection = TextSelection.fromPosition(
                                TextPosition(
                                  offset: _expiryController.text.length,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('CVC'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _cvcController,
                          decoration: const InputDecoration(
                            hintText: '123',
                            errorStyle: TextStyle(color: Colors.red),
                            suffixIcon: Icon(Icons.credit_card),
                          ),
                          keyboardType: TextInputType.number,
                          validator: _validateCVC,
                          maxLength: 3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                value: _saveCard,
                onChanged: (value) {
                  setState(() {
                    _saveCard = value;
                  });
                },
                title: const Text('Save this card'),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : () async {
                          if (!await _checkInternetConnection()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('تأكد من اتصالك بالإنترنت'),
                                backgroundColor: Colors.orange,
                                duration: Duration(seconds: 3),
                              ),
                            );
                            return;
                          }
                          if (_formKey.currentState!.validate()) {
                            setState(() => _isProcessing = true);
                            try {
                              final payment = PaymentModel(
                                cardNumber: _cardNumberController.text
                                    .replaceAll(' ', ''),
                                expiryDate: _expiryController.text,
                                cvc: _cvcController.text,
                                cardType: _cardType ?? 'unknown',
                                isSaved: _saveCard,
                                userId:
                                    'current_user_id', // يجب استبداله بمعرف المستخدم الحقيقي
                                createdAt: DateTime.now(),
                              );

                              await context.read<PaymentCubit>().processPayment(
                                payment,
                              );
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('تمت عملية الدفع بنجاح!'),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              Navigator.pop(context);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'فشلت عملية الدفع: ${e.toString()}',
                                  ),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 3),
                                  action: SnackBarAction(
                                    label: 'حاول مرة أخرى',
                                    textColor: Colors.white,
                                    onPressed: () {
                                      // إعادة تعيين حالة المعالجة
                                      setState(() => _isProcessing = false);
                                    },
                                  ),
                                ),
                              );
                            } finally {
                              if (mounted) {
                                setState(() => _isProcessing = false);
                              }
                            }
                          }
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Pay Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
