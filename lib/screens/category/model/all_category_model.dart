class CategoryListRes {
  bool status;
  List<CategoryElement> data;
  String message;

  CategoryListRes({
    this.status = false,
    this.data = const <CategoryElement>[],
    this.message = "",
  });

  factory CategoryListRes.fromJson(Map<String, dynamic> json) {
    return CategoryListRes(
      status: json['status'] is bool ? json['status'] : false,
      data: json['data'] is List ? List<CategoryElement>.from(json['data'].map((x) => CategoryElement.fromJson(x))) : [],
      message: json['message'] is String ? json['message'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((e) => e.toJson()).toList(),
      'message': message,
    };
  }
}

class CategoryElement {
  int id;
  String name;
  String slug;
  String description;
  int parentId;
  int status;
  bool isFeatured;
  int vendorId;
  String categoryImage;
  int createdBy;
  int updatedBy;
  int deletedBy;
  String createdAt;
  String updatedAt;
  String deletedAt;

  CategoryElement({
    this.id = -1,
    this.name = "",
    this.slug = "",
    this.description = "",
    this.parentId = -1,
    this.status = -1,
    this.isFeatured = false,
    this.vendorId = -1,
    this.categoryImage = "",
    this.createdBy = -1,
    this.updatedBy = -1,
    this.deletedBy = -1,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt = "",
  });

  factory CategoryElement.fromJson(Map<String, dynamic> json) {
    return CategoryElement(
      id: json['id'] is int ? json['id'] : -1,
      name: json['name'] is String ? json['name'] : "",
      slug: json['slug'] is String ? json['slug'] : "",
      description: json['description'] is String ? json['description'] : "",
      parentId: json['parent_id'] is int ? json['parent_id'] : -1,
      status: json['status'] is int ? json['status'] : -1,
      isFeatured: json['is_featured'] is bool ? json['is_featured'] : json['is_featured'] == 1,
      vendorId: json['vendor_id'] is int ? json['vendor_id'] : -1,
      categoryImage: json['category_image'] is String ? json['category_image'] : "",
      createdBy: json['created_by'] is int ? json['created_by'] : -1,
      updatedBy: json['updated_by'] is int ? json['updated_by'] : -1,
      deletedBy: json['deleted_by'] is int ? json['deleted_by'] : -1,
      createdAt: json['created_at'] is String ? json['created_at'] : "",
      updatedAt: json['updated_at'] is String ? json['updated_at'] : "",
      deletedAt: json['deleted_at'] is String ? json['deleted_at'] : "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'parent_id': parentId,
      'status': status,
      'is_featured': isFeatured,
      'vendor_id': vendorId,
      'category_image': categoryImage,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'deleted_by': deletedBy,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
