class UserObj {
  int iddriver;
  String name;
  String email;
  String phone;
  String password;
  String profile;
  double longitude;
  double latitude;
  String token;
  int active;
  String createdate;
  String verify;
  String address;
  int online;
  int iscar;
  int isdoc;
  int sex;
  int idride;
  double rating;
  int accept;

  UserObj(
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

  UserObj.fromJson(Map<String, dynamic> json) {
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
    sex = json['sex'];
    idride = json['idride'];
    rating = json['rating'].toDouble();
    accept = json['accept'];
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
    data['sex'] = this.sex;
    data['idride'] = this.idride;
    data['rating'] = this.rating;
    data['accept'] = this.accept;
    return data;
  }
}
