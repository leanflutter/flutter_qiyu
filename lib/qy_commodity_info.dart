class QYCommodityInfo {
  String commodityInfoTitle;
  String commodityInfoDesc;
  String pictureUrl;
  String commodityInfoUrl;
  String note;
  bool show;

  QYCommodityInfo({
    this.commodityInfoTitle,
    this.commodityInfoDesc,
    this.pictureUrl,
    this.commodityInfoUrl,
    this.note,
    this.show,
  });

  factory QYCommodityInfo.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return QYCommodityInfo(
      commodityInfoTitle: json['commodityInfoTitle'],
      commodityInfoDesc: json['commodityInfoDesc'],
      pictureUrl: json['pictureUrl'],
      commodityInfoUrl: json['commodityInfoUrl'],
      note: json['note'],
      show: json['show'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commodityInfoTitle': commodityInfoTitle,
      'commodityInfoDesc': commodityInfoDesc,
      'pictureUrl': pictureUrl,
      'commodityInfoUrl': commodityInfoUrl,
      'note': note,
      'show': show,
    };
  }
}
