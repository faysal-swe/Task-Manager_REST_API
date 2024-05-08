class SummaryCountModel {
  String? status;
  List<SummaryCountListData>? data;

  SummaryCountModel({this.status, this.data});

  SummaryCountModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <SummaryCountListData>[];
      json['data'].forEach((v) {
        data!.add(SummaryCountListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SummaryCountListData {
  String? sId;
  int? sum;

  SummaryCountListData({this.sId, this.sum});

  SummaryCountListData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sum = json['sum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['sum'] = sum;
    return data;
  }
}
