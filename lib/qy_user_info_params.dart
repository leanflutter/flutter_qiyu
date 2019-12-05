class QYUserInfoParams {
  String userId;
  String data;

  QYUserInfoParams({
    this.userId,
    this.data,
  });

  factory QYUserInfoParams.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return QYUserInfoParams(
      userId: json['userId'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'data': data,
    };
  }
}
