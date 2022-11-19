class Post {
  int iddriver;
  int id;
  String title;
  String body;

  Post({this.iddriver, this.id, this.title, this.body});

  Post.fromJson(Map<String, dynamic> json) {
    iddriver = json['iddriver'];
    id = json['id'];
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iddriver'] = this.iddriver;
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
}