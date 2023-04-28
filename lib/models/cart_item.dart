class CartItem{
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.productId,
    required this.price,
    required this.quantity,
    required this.title
  });
}