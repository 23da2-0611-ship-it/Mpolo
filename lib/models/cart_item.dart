class CartItem {
  final String id;
  final String title;
  final String variant; // e.g., "MAUVE / MEDIUM"
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.variant,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });

  CartItem copyWith({
    String? id,
    String? title,
    String? variant,
    double? price,
    String? imageUrl,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      title: title ?? this.title,
      variant: variant ?? this.variant,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
    );
  }
}
