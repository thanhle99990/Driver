class CarObj {
  int idcar;
  String model;
  int type;
  String plate;
  String color;
  int iddriver;
  int seat;
  String typename;

  CarObj(
      {
        this.idcar,
        this.model,
        this.type,
        this.plate,
        this.color,
        this.iddriver,
        this.seat});

  CarObj.fromJson(Map<String, dynamic> json) {
    idcar = json['idcar'];
    model = json['model'];
    type = json['type'];
    plate = json['plate'];
    color = json['color'];
    iddriver = json['iddriver'];
    seat = json['seat'];
    typename = json['typename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idcar'] = this.idcar;
    data['model'] = this.model;
    data['type'] = this.type;
    data['plate'] = this.plate;
    data['color'] = this.color;
    data['iddriver'] = this.iddriver;
    data['seat'] = this.seat;
    data['typename'] = this.typename;
    return data;
  }
}
