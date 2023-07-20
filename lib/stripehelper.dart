import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeHelper{
  
  static StripeHelper instance = StripeHelper();
  Map<String, dynamic>? paymentIntent;

  Future <bool> makePayment(String amount) async {
    try{
      paymentIntent = await createPaymentIntent("200", 'MYR');

      var gpay = const PaymentSheetGooglePay(
        merchantCountryCode: "MYS", currencyCode: "MYR", testEnv: true);

        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent![
              'client_secret'],
              merchantDisplayName: 'Alia',
              googlePay: gpay
          )).then((value) => {});

      displayPaymentSheet();
      return true;
    } catch(err){
      print(err);
      return false;
    }
  }

   displayPaymentSheet() async{
    try{
      await Stripe.instance.presentPaymentSheet().then((value){
        print("Payment Succesfully");
      });
    } catch(e){
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency)async{
    try{
      Map<String, dynamic> body ={
        "amount" : amount,
        "currency" : currency,
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers:{
          'Authorization': 'Bearer sk_test_51NUqYZJYHilDWI38T067GLsGJp99Xo46dA1uRSRfQVR8J7tdG6foGNmzqYhObwMDqnH4LSYHCyA4mZFRK00q0Tg800L4dclhYJ',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}
