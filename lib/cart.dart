import 'package:flower_app/model/item.dart';
import 'package:flutter/material.dart';

class Cart with ChangeNotifier {
  List flowersInCart = [];
  double totalPrice = 0;

  add(Item product) {
    flowersInCart.add(product);
    totalPrice += product.price.round();
    notifyListeners();
  }

  remove(Item product) {
    flowersInCart.remove(product);
    totalPrice -= product.price.round();
    notifyListeners();
  }

  get itemCount {
    return flowersInCart.length;
  }
}
