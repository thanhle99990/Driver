class ReasonObj {
  int idreason;
  String description;
  int active;

  ReasonObj({this.idreason, this.description, this.active});

  ReasonObj.fromJson(Map<String, dynamic> json) {
    idreason = json['idreason'];
    description = json['description'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idreason'] = this.idreason;
    data['description'] = this.description;
    data['active'] = this.active;
    return data;
  }
}
