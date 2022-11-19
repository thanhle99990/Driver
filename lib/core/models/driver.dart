class DriverObj {
  int iddriver;
  String name;
  String email;
  String phone;
  String password;
  String profile;
  Null longitude;
  Null latitude;
  Null token;
  int active;
  String createdate;
  String verify;
  Null address;
  int online;
  int iscar;
  int isdoc;

  DriverObj(
      {this.iddriver,
        this.name,
        this.email,
        this.phone,
        this.password,
        this.profile,
        this.longitude,
        this.latitude,
        this.token,
        this.active,
        this.createdate,
        this.verify,
        this.address,
        this.online,
        this.iscar,
        this.isdoc});

  DriverObj.fromJson(Map<String, dynamic> json) {
    iddriver = json['iddriver'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    profile = json['profile'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    token = json['token'];
    active = json['active'];
    createdate = json['createdate'];
    verify = json['verify'];
    address = json['address'];
    online = json['online'];
    iscar = json['iscar'];
    isdoc = json['isdoc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iddriver'] = this.iddriver;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['profile'] = this.profile;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['token'] = this.token;
    data['active'] = this.active;
    data['createdate'] = this.createdate;
    data['verify'] = this.verify;
    data['address'] = this.address;
    data['online'] = this.online;
    data['iscar'] = this.iscar;
    data['isdoc'] = this.isdoc;
    return data;
  }
}
