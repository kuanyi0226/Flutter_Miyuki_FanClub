class Images {
  String id;
  final String url;
  Images({
    this.id = '',
    required this.url,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': url,
      };

  static Images fromJson(Map<String, dynamic> json) => Images(
        url: json['url'],
      );
}
