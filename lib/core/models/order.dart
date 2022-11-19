import 'orderprice.dart';
import 'person.dart';
import 'product.dart';

class OrderObj {
  int iddriver;
  int orderid;
  OrderPrice orderPrice;
  ProductObj product;
  PersonObj sender;
  PersonObj receiver;

  OrderObj(
      {
        this.orderid,
        this.iddriver,
        this.orderPrice,
        this.product,
        this.sender,
        this.receiver});

  OrderObj.fromJson(Map<String, dynamic> json) {
    orderid = json['orderid'];
    iddriver = json['iddriver'];
    orderPrice =
    json['orderPrice'] != null ? new OrderPrice.fromJson(json['orderPrice']) : null;
    product =
    json['product'] != null ? new ProductObj.fromJson(json['product']) : null;
    sender =
    json['sender'] != null ? new PersonObj.fromJson(json['sender']) : null;
    receiver =
    json['receiver'] != null ? new PersonObj.fromJson(json['receiver']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderid'] = this.orderid;
    data['iddriver'] = this.iddriver;
    if (this.orderPrice != null) {
      data['orderPrice'] = this.orderPrice.toJson();
    }
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    if (this.sender != null) {
      data['sender'] = this.sender.toJson();
    }
    if (this.receiver != null) {
      data['receiver'] = this.receiver.toJson();
    }
    return data;
  }
}