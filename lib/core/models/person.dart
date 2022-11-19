class PersonObj {
  int id;
  String name;
  String phone;
  double lng;
  double lat;
  String note;
  String address;
  int type;
  int iddriver;

  PersonObj(
      {this.id,
        this.name,
        this.phone,
        this.lng,
        this.lat,
        this.note,
        this.address,
        this.type,
        this.iddriver});

  PersonObj.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    lng = json['lng'];
    lat = json['lat'];
    note = json['note'];
    address = json['address'];
    type = json['type'];
    iddriver = json['iddriver'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['lng'] = this.lng;
    data['lat'] = this.lat;
    data['note'] = this.note;
    data['address'] = this.address;
    data['type'] = this.type;
    data['iddriver'] = this.iddriver;
    return data;
  }
}
