
class CMNModel {
  int id;
  String slug;
  String name;

  CMNModel({
    this.id = -1,
    this.slug = "",
    this.name = "",
  });

  factory CMNModel.fromJson(Map<String, dynamic> json) {
    return CMNModel(
      id: json['id'] is int ? json['id'] : -1,
      slug: json['slug'] is String ? json['slug'] : "",
      name: json['name'] is String ? json['name'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'name': name,
    };
  }
}
