class TripObj {
  int id;
  int iddriver;
  int fromid;
  int toid;
  int servicetype;
  String vehicleid;
  int seat;
  String km;
  String time;
  String from;
  String to;

  TripObj(
      {
        this.id,
        this.iddriver,
        this.fromid,
        this.toid,
        this.servicetype,
        this.vehicleid,
        this.seat,
        this.km,
        this.time,
        this.from,
        this.to});

  TripObj.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    iddriver = json['iddriver'];
    fromid = json['fromid'];
    toid = json['toid'];
    servicetype = json['servicetype'];
    vehicleid = json['vehicleid'];
    seat = json['seat'];
    km = json['km'];
    time = json['time'];
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['iddriver'] = this.iddriver;
    data['fromid'] = this.fromid;
    data['toid'] = this.toid;
    data['servicetype'] = this.servicetype;
    data['vehicleid'] = this.vehicleid;
    data['seat'] = this.seat;
    data['km'] = this.km;
    data['time'] = this.time;
    data['from'] = this.from;
    data['to'] = this.to;
    return data;
  }
}
