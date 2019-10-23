class Product {
  String id;
  int createdAt;
  String name;
  String description;
  double price;
  String imageUrl;
  bool isFavorite;
  String userId;
  int quantity;
  String categoryId;

  Product({
    this.id,
    this.name,
    this.description,
    this.price,
    this.categoryId,
    this.userId,
    this.createdAt,
    this.imageUrl,
    this.isFavorite = false,
    this.quantity,
  });

  factory Product.fromJson(dynamic json) {
    return new Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      categoryId: json['categoryId'],
      userId: json['userId'],
      createdAt: json['createdAt'],
      imageUrl: json['imageUrl'],
      isFavorite: json['isFavorite'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['categoryId'] = this.categoryId;
    data['userId'] = this.userId;
    data['createdAt'] = this.createdAt;
    data['imageUrl'] = this.imageUrl;
    data['isFavorite'] = this.isFavorite;
    data['quantity'] = this.quantity;
    return data;
  }
}
