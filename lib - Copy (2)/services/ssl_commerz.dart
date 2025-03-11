import 'dart:math';

class EasySSLCommerz{
  double amount;
  String customerName;
  String customerEmail;
  String customerPhone;
  String customerCountry;
  String customerPostCode;
  String customerCity;
  String customerAddress1;
  String productCategory;
  String customerState;



  EasySSLCommerz({
    required this.amount,
    required this.productCategory,
    required this.customerEmail,
    required this.customerName,
    required this.customerPhone,
    required this.customerCountry,
    required this.customerPostCode,
    required this.customerAddress1,
    required this.customerCity,
    required this.customerState,
  }){
    config();
  }
  void config(){




  }

  Future<dynamic>  payNow() async{
  }

  String getRandomString(int length){
    Random rnd = Random();
    String chars = '0123456789';
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }
}
