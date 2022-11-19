class VehicletypeObj {
  int idvehicle;
  String typename;
  String image;
  int cost;
  int active;

  VehicletypeObj(
      {this.idvehicle, this.typename, this.image, this.cost, this.active});

  VehicletypeObj.fromJson(Map<String, dynamic> json) {
    idvehicle = json['idvehicle'];
    typename = json['typename'];
    image = json['image'];
    cost = json['cost'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idvehicle'] = this.idvehicle;
    data['typename'] = this.typename;
    data['image'] = this.image;
    data['cost'] = this.cost;
    data['active'] = this.active;
    return data;
  }
}
