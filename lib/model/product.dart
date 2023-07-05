class Product {
  String? prid;
  String? pridowner;
  String? prname;
  String? prdesc;
  String? prprice;
  String? prqty;
  String? prdel;
  String? prlat;
  String? prlong;
  String? prstate;
  String? prloc;
  String? prdate;

  Product(
      {this.prid,
      this.pridowner,
      this.prname,
      this.prdesc,
      this.prprice,
      this.prqty,
      this.prdel,
      this.prlat,
      this.prlong,
      this.prstate,
      this.prloc,
      this.prdate});

  Product.fromJson(Map<String, dynamic> json) {
    prid = json['prid'];
    pridowner = json['userid'];
    prname = json['prname'];
    prdesc = json['prdesc'];
    prprice = json['prprice'];
    prqty = json['prqty'];
    prdel = json['prdel'];
    prlat = json['prlat'];
    prlong = json['prlong'];
    prstate = json['prstate'];
    prloc = json['prloc'];
    prdate = json['prdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prid'] = prid;
    data['userid'] = pridowner;
    data['prname'] = prname;
    data['prdesc'] = prdesc;
    data['prprice'] = prprice;
    data['prqty'] = prqty;
    data['prdel'] = prdel;
    data['prlat'] = prlat;
    data['prlong'] = prlong;
    data['prstate'] = prstate;
    data['prloc'] = prloc;
    data['prdate'] = prdate;
    return data;
  }
}