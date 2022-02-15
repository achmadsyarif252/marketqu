class Posts {
  final int? userId;
  final int? id;
  final String? title;
  final String? body;

  Posts({this.userId, this.id, this.title, this.body});

  factory Posts.formJson(Map<String, dynamic> json) {
    return new Posts(
        userId: json['userid'],
        id: json['id'],
        title: json['title'],
        body: json['body']);
  }
}
