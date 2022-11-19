class EarningRpt {
  String date;
  int ride;
  double earning;

  EarningRpt({this.date, this.ride, this.earning});

  EarningRpt.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    ride = json['ride'];
    earning = json['earning'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['ride'] = this.ride;
    data['earning'] = this.earning;
    return data;
  }
}
