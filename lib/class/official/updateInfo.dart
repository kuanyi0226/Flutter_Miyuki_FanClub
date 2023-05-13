class UpdateInfo {
  String? version;
  String? link;

  UpdateInfo({required this.version, required this.link});

  static UpdateInfo fromJson(Map<String, dynamic> json) => UpdateInfo(
        version: json['version'],
        link: json['link'],
      );
}
