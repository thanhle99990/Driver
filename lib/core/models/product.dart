class ProductObj {
  int id;
  String image;
  String note;
  int type;
  String imgurl;
  int iddriver;

  ProductObj(
      {this.id, this.image, this.note, this.type, this.imgurl, this.iddriver});

  ProductObj.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    note = json['note'];
    type = json['type'];
    imgurl = json['imgurl'];
    iddriver = json['iddriver'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['note'] = this.note;
    data['type'] = this.type;
    data['imgurl'] = this.imgurl;
    data['iddriver'] = this.iddriver;
    return data;
  }
}
