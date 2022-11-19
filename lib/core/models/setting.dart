class SettingObj {
  double initrace;
  int maxkm;
  int editvehicle;

  SettingObj({this.initrace});

  SettingObj.fromJson(Map<String, dynamic> json) {
    initrace = json['initrace'].toDouble();
    maxkm = json['maxkm'];
    editvehicle = json['editvehicle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['initrace'] = this.initrace;
    data['maxkm'] = this.maxkm;
    data['editvehicle'] = this.editvehicle;
    return data;
  }
}
