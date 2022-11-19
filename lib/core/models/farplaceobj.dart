class FarPlaceObj {
  int id;
  String name;
  String address;
  double lng;
  double lat;
  int type;
  int idcustomer;

  FarPlaceObj(
      {this.id,
        this.name,
        this.address,
        this.lng,
        this.lat,
        this.type,
        this.idcustomer});

  FarPlaceObj.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    lng = json['lng'];
    lat = json['lat'];
    type = json['type'];
    idcustomer = json['idcustomer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['lng'] = this.lng;
    data['lat'] = this.lat;
    data['type'] = this.type;
    data['idcustomer'] = this.idcustomer;
    return data;
  }
}
