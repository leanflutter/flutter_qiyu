class QYSource {
  String sourceTitle;
  String sourceUrl;
  String sourceCustomInfo;

  QYSource({
    this.sourceTitle,
    this.sourceUrl,
    this.sourceCustomInfo,
  });

  factory QYSource.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return QYSource(
      sourceTitle: json['sourceTitle'],
      sourceUrl: json['sourceUrl'],
      sourceCustomInfo: json['sourceCustomInfo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sourceTitle': sourceTitle,
      'sourceUrl': sourceUrl,
      'sourceCustomInfo': sourceCustomInfo,
    };
  }
}
