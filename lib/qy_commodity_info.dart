class QYCommodityInfo {
  String commodityInfoTitle;
  String commodityInfoDesc;
  String pictureUrl;
  String commodityInfoUrl;
  String note;
  bool show;
  bool sendByUser;

  QYCommodityInfo({
    this.commodityInfoTitle,
    this.commodityInfoDesc,
    this.pictureUrl,
    this.commodityInfoUrl,
    this.note,
    this.show,
    this.sendByUser,
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
      sendByUser: json['sendByUser'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = new Map();

    if (commodityInfoTitle != null)
      json.putIfAbsent('commodityInfoTitle', () => commodityInfoTitle);
    if (commodityInfoDesc != null)
      json.putIfAbsent('commodityInfoDesc', () => commodityInfoDesc);
    if (pictureUrl != null)
      json.putIfAbsent('pictureUrl', () => pictureUrl);
    if (commodityInfoUrl != null)
      json.putIfAbsent('commodityInfoUrl', () => commodityInfoUrl);
    if (note != null)
      json.putIfAbsent('note', () => note);
    if (show != null)
      json.putIfAbsent('show', () => show);
    if (sendByUser != null)
      json.putIfAbsent('sendByUser', () => sendByUser);
    return json;
  }
}
