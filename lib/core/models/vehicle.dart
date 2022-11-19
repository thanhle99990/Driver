class VehicleObj {
  int id;
  int iddriver;
  String name;
  String number;
  String type;
  int seat;

  VehicleObj(
      {this.id, this.iddriver, this.name, this.number, this.type, this.seat});

  VehicleObj.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    iddriver = json['iddriver'];
    name = json['name'];
    number = json['number'];
    type = json['type'];
    seat = json['seat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['iddriver'] = this.iddriver;
    data['name'] = this.name;
    data['number'] = this.number;
    data['type'] = this.type;
    data['seat'] = this.seat;
    return data;
  }
}
