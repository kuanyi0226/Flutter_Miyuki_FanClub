class Garment {
  String name;
  int price = 10000;
  String description;
  String year;
  String live_name;
  String file;

  Garment(
      {required this.name,
      required this.price,
      this.description = 'No Description',
      required this.year,
      required this.live_name,
      required this.file});
}
