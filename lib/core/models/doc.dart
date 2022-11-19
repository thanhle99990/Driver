class DocObj {
  int iddoc;
  int type;
  String image;
  int iddriver;
  int status;

  DocObj({this.iddoc, this.type, this.image, this.iddriver, this.status});

  DocObj.fromJson(Map<String, dynamic> json) {
    iddoc = json['iddoc'];
    type = json['type'];
    image = json['image'];
    iddriver = json['iddriver'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iddoc'] = this.iddoc;
    data['type'] = this.type;
    data['image'] = this.image;
    data['iddriver'] = this.iddriver;
    data['status'] = this.status;
    return data;
  }
}
