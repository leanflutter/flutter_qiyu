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
    return {
      'source': source != null ? source.toJson() : null,
      'commodityInfo': source != null ? commodityInfo.toJson() : null,
      'sessionTitle': sessionTitle,
      'groupId': groupId,
      'staffId': staffId,
      'robotId': robotId,
      'robotFirst': robotFirst,
      'faqTemplateId': faqTemplateId,
      'vipLevel': vipLevel,
      'showQuitQueue': showQuitQueue,
      'showCloseSessionEntry': showCloseSessionEntry,
    };
  }
}
