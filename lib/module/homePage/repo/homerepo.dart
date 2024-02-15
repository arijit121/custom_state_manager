import 'dart:convert';

import '../../../../const/apiConst.dart';

import '../../../../extension/AppLog.dart';
import '../../../api/imp/api_repo_imp.dart';
import '../../../api/repo/apirepo.dart';
import '../model/img_api_response_model.dart';

class HomeRepo {
  Future<ImgApiResponseModel?> getData() async {
    try {
      String? v = await apiRepo().callApi(
          tag: "get img list", uri: ApiConst.photos, method: Method.get);
      if (v != null) {
        var response = {"data_list": json.decode(v)};
        ImgApiResponseModel imgApiResponseModel =
            ImgApiResponseModel.fromJson(response);
        return imgApiResponseModel;
      }
    } catch (e, s) {
      AppLog.e(e.toString(), error: e, stackTrace: s);
    }
    return null;
  }
}
