import './qy_commodity_info.dart';
import './qy_source.dart';

class QYServiceWindowParams {
  QYSource source;
  QYCommodityInfo commodityInfo;

  String sessionTitle;
  int groupId;
  int staffId;
  int robotId;
  bool robotFirst;
  int faqTemplateId;
  int vipLevel;
  bool showQuitQueue;
  bool showCloseSessionEntry;

  QYServiceWindowParams({
    this.source,
    this.commodityInfo,
    this.sessionTitle,
    this.groupId = 0,
    this.staffId = 0,
    this.robotId,
    this.robotFirst = false,
    this.faqTemplateId = 0,
    this.vipLevel = 0,
    this.showQuitQueue = true,
    this.showCloseSessionEntry = true,
  });

  factory QYServiceWindowParams.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return QYServiceWindowParams(
      source: QYSource.fromJson(json['source']),
      commodityInfo: QYCommodityInfo.fromJson(json['commodityInfo']),
      sessionTitle: json['sessionTitle'],
      groupId: json['groupId'],
      staffId: json['staffId'],
      robotId: json['robotId'],
      robotFirst: json['robotFirst'],
      faqTemplateId: json['faqTemplateId'],
      vipLevel: json['vipLevel'],
      showQuitQueue: json['showQuitQueue'],
      showCloseSessionEntry: json['showCloseSessionEntry'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = new Map();
    if (source != null)
      json.putIfAbsent('source', () => source.toJson());
    if (commodityInfo != null)
      json.putIfAbsent('commodityInfo', () => commodityInfo.toJson());
    if (sessionTitle != null)
      json.putIfAbsent('sessionTitle', () => sessionTitle);
    if (groupId != null)
      json.putIfAbsent('groupId', () => groupId);
    if (staffId != null)
      json.putIfAbsent('staffId', () => staffId);
    if (robotId != null)
      json.putIfAbsent('robotId', () => robotId);
    if (robotFirst != null)
      json.putIfAbsent('robotFirst', () => robotFirst);
    if (faqTemplateId != null)
      json.putIfAbsent('faqTemplateId', () => faqTemplateId);
    if (vipLevel != null)
      json.putIfAbsent('vipLevel', () => vipLevel);
    if (showQuitQueue != null)
      json.putIfAbsent('showQuitQueue', () => showQuitQueue);
    if (showCloseSessionEntry != null)
      json.putIfAbsent('showCloseSessionEntry', () => showCloseSessionEntry);
    return json;
  }
}
