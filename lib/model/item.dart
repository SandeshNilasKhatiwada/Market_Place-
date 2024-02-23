// model

class Item {
  String imgUrl;
  double price;
  String location;
  String product;
  int quantity;
  String description;

  Item({
    required this.imgUrl,
    required this.product,
    required this.price,
    this.location = "hh",
    this.quantity = 5,
    this.description = 'This is description',
  });
}

List items = [
  Item(
      imgUrl: "1.webp",
      product: "Flower1",
      price: 12.99,
      location: "Cité el Qods"),
  Item(imgUrl: "2.webp", product: "Flower2", price: 11.00, location: "Annaba"),
  Item(imgUrl: "3.webp", product: "Flower3", price: 9.01, location: "El bouni"),
  Item(imgUrl: "4.webp", product: "Flower4", price: 5.99),
  Item(imgUrl: "5.webp", product: "Flower5", price: 4.99),
  Item(imgUrl: "6.webp", product: "Flower6", price: 4.99),
  Item(imgUrl: "7.webp", product: "Flower7", price: 4.99),
  Item(imgUrl: "8.webp", product: "Flower8", price: 4.99),
];
