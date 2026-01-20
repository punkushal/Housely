import 'package:esewa_flutter/esewa_flutter.dart';
import 'package:flutter/material.dart';
import 'package:housely/core/utils/typedef.dart';

abstract interface class EsewaPaymentRepo {
  ResultFuture<EsewaPaymentResult> initiateEsewaPayment({
    required BuildContext context,
    required ESewaConfig esewaConfig,
  });
}
