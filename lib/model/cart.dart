class Cart {
  String? cartid;
  String? prid;
  String? prname;
  String? prdesc;
  String? prqty;
  String? prprice;
  String? cartqty;
  String? cartprice;
  String? pridowner;
  String? sellerid;
  String? cartdate;

  Cart(
      {this.cartid,
      this.prid,
      this.prname,
      this.prdesc,
      this.prqty,
      this.prprice,
      this.cartqty,
      this.cartprice,
      this.pridowner,
      this.sellerid,
      this.cartdate});

  Cart.fromJson(Map<String, dynamic> json) {
    cartid = json['cartid'];
    prid = json['prid'];
    prname = json['prname'];
    prdesc = json['prdesc'];
    prqty = json['prqty'];
    prprice = json['prprice'];
    cartqty = json['cartqty'];
    cartqty = json['cartprice'];
    pridowner = json['userid'];
    sellerid = json['sellerid'];
    cartdate = json['cartdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cartid'] = cartid;
    data['prid'] = prid;
    data['prname'] = prname;
    data['prdesc'] = prdesc;
    data['prqty'] = prqty;
    data['prprice'] = prprice;
    data['cartqty'] = cartqty;
    data['cartprice'] = cartprice;
    data['userid'] = pridowner;
    data['sellerid'] = sellerid;
    data['cartdate'] = cartdate;
    return data;
  }
}