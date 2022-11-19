class OrderlogObj {
  int id;
  String code;
  String createDate;
  int iddriver;
  int productid;
  int senderid;
  int receiverid;
  int status;
  int price;
  String lastUpdate;
  String driverstatus;
  //int iddriver;
  String pin;
  int time;
  int timeminus;
  int km;

  OrderlogObj(
      {this.id,
        this.code,
        this.createDate,
        this.iddriver,
        this.productid,
        this.senderid,
        this.receiverid,
        this.status,
        this.price,
        this.lastUpdate,
        this.driverstatus,
        //this.iddriver,
        this.pin,
        this.time,
        this.timeminus,
        this.km});

  OrderlogObj.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    createDate = json['create_date'];
    //iddriver = json['iddriver'];
    productid = json['productid'];
    senderid = json['senderid'];
    receiverid = json['receiverid'];
    status = json['status'];
    price = json['price'];
    lastUpdate = json['last_update'];
    driverstatus = json['driverstatus'];
    iddriver = json['iddriver'];
    pin = json['pin'];
    time = json['time'];
    timeminus = json['timeminus'];
    km = json['km'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['create_date'] = this.createDate;
    data['iddriver'] = this.iddriver;
    data['productid'] = this.productid;
    data['senderid'] = this.senderid;
    data['receiverid'] = this.receiverid;
    data['status'] = this.status;
    data['price'] = this.price;
    data['last_update'] = this.lastUpdate;
    data['driverstatus'] = this.driverstatus;
    data['iddriver'] = this.iddriver;
    data['pin'] = this.pin;
    data['time'] = this.time;
    data['timeminus'] = this.timeminus;
    data['km'] = this.km;
    return data;
  }
}
