import '../../../../extension/AppLog.dart';

class ImgApiResponseModel {
  List<DataList>? dataList;

  ImgApiResponseModel({this.dataList});

  ImgApiResponseModel.fromJson(Map<String, dynamic> json) {
    try {
      if (json['data_list'] != null) {
        dataList = <DataList>[];
        json['data_list'].forEach((v) {
          dataList!.add(DataList.fromJson(v));
        });
      }
    } catch (e, s) {
      AppLog.e(e.toString(), error: e, stackTrace: s);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (dataList != null) {
      data['data_list'] = dataList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataList {
  int? albumId;
  int? id;
  String? title;
  String? url;
  String? thumbnailUrl;

  DataList({this.albumId, this.id, this.title, this.url, this.thumbnailUrl});

  DataList.fromJson(Map<String, dynamic> json) {
    try {
      albumId = json['albumId'];
      id = json['id'];
      title = json['title'];
      url = json['url'];
      thumbnailUrl = json['thumbnailUrl'];
    } catch (e, s) {
      AppLog.e(e.toString(), error: e, stackTrace: s);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['albumId'] = albumId;
    data['id'] = id;
    data['title'] = title;
    data['url'] = url;
    data['thumbnailUrl'] = thumbnailUrl;
    return data;
  }
}
