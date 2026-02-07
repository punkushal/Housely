import 'package:esewa_flutter/esewa_flutter.dart';
import 'package:flutter/material.dart';

class EsewaRemoteDataSource {
  Future<EsewaPaymentResult> payWithEsewa({
    required BuildContext context,
    required ESewaConfig esewaConfig,
  }) async {
    try {
      final result = await Esewa.i.init(
        context: context,
        eSewaConfig: esewaConfig,
      );

      return result;
    } catch (e) {
      throw Exception('Failed to pay with esewa :$e');
    }
  }
}
