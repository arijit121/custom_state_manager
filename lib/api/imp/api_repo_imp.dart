import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import '../../../extension/AppLog.dart';
import '../repo/apirepo.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ApiRepoImp extends ApiRepo {
  @override
  Future<String?> callApi(
      {required String tag,
      required String uri,
      required Method method,
      Map<String, dynamic>? queryParameters,
      Map<String, String>? headers,
      BodyData? bodyData}) async {
    try {
      Map<String, String> stringQueryParameters = <String, String>{};
      queryParameters?.forEach((key, value) {
        if (value != null) {
          stringQueryParameters[key] = value!.toString();
        }
      });

      Uri url = Uri.parse(uri).replace(queryParameters: stringQueryParameters);
      Request request = http.Request(method.name, url);
      MultipartRequest requestFormData =
          http.MultipartRequest(method.name, url);
      DateTime requestTime = DateTime.now();
      AppLog.i(tag: "$tag Url", uri, time: DateTime.now());
      if (bodyData?.bodyTypeStatus == BodyTypeStatus.raw) {
        BodyData<Map<String, String>?> body =
            bodyData as BodyData<Map<String, String>?>;
        if (body.value?.isNotEmpty == true) {
          request.body = json.encode(body.value);
          AppLog.i(
              tag: "$tag BodyData",
              json.encode(body.value),
              time: DateTime.now());
        }
      } else if (bodyData?.bodyTypeStatus == BodyTypeStatus.rawText) {
        BodyData<String> body = bodyData as BodyData<String>;
        if (body.value?.isNotEmpty == true) {
          request.body = body.value ?? "";
          AppLog.i(tag: "$tag BodyData", "${body.value}", time: DateTime.now());
        }
      } else if (bodyData?.bodyTypeStatus == BodyTypeStatus.formData) {
        BodyData<FormData?> body = bodyData as BodyData<FormData?>;
        if (body.value != null) {
          requestFormData.fields.addAll(body.value?.fields ?? {});
        }
        if (body.value?.files?.isNotEmpty == true) {
          body.value?.files?.forEach((element) async {
            if (kIsWeb) {
              requestFormData.files.add(http.MultipartFile.fromBytes(
                  element.key ?? "", element.bytes ?? [],
                  filename: element.filename));
            } else {
              requestFormData.files.add(await http.MultipartFile.fromPath(
                  element.key ?? "", element.path ?? ""));
            }
          });
        }
        AppLog.i(
            tag: "$tag BodyData",
            json.encode(body.value?.toJson()),
            time: DateTime.now());
      }
      if (headers?.isNotEmpty == true) {
        (bodyData?.bodyTypeStatus == BodyTypeStatus.formData
                ? requestFormData
                : request)
            .headers
            .addAll(headers ?? {});
        AppLog.i(
            tag: "$tag Headers", json.encode(headers), time: DateTime.now());
      }
      http.StreamedResponse response =
          await (bodyData?.bodyTypeStatus == BodyTypeStatus.formData
                  ? requestFormData
                  : request)
              .send();

      if (response.statusCode == 200) {
        String responseReturn = await response.stream.bytesToString();
        AppLog.i(tag: "$tag Response", responseReturn, time: DateTime.now());
        AppLog.i(
          tag: "$tag Response Time",
          "${DateTime.now().difference(requestTime).toString()} HH:MM:SS",
        );
        return responseReturn;
      } else {
        AppLog.i(
            tag: "$tag Response",
            "${response.reasonPhrase}",
            time: DateTime.now());
        return (response.reasonPhrase);
      }
    } catch (e, s) {
      AppLog.e(
          tag: "$tag Error",
          e.toString(),
          error: e,
          stackTrace: s,
          time: DateTime.now());
    }
    return null;
  }

  Future<Uint8List> urlToByte({required String url, Duration? timeOut}) async {
    http.Response response = await http
        .get(
          Uri.parse(url),
        )
        .timeout(timeOut ?? const Duration(minutes: 1));
    return response.bodyBytes;
  }
}

enum Method {
  get('GET'),
  post('POST');

  final String value;

  const Method(this.value);
}

class BodyData<T> {
  BodyTypeStatus? bodyTypeStatus;
  T? value;

  BodyData({
    this.bodyTypeStatus,
    this.value,
  });

  BodyData<Map<String, String>?> raw({Map<String, String>? body}) {
    return BodyData<Map<String, String>?>(
        bodyTypeStatus: BodyTypeStatus.raw, value: body);
  }

  BodyData<String> rawText({Map<String, String>? body}) {
    return BodyData<String>(
        bodyTypeStatus: BodyTypeStatus.rawText, value: '''${body ?? ""}''');
  }

  BodyData<FormData?> formData({FormData? formData}) {
    return BodyData<FormData?>(
        bodyTypeStatus: BodyTypeStatus.formData, value: formData);
  }

  @override
  String toString() {
    return "Status : $bodyTypeStatus \n Data : $value";
  }
}

enum BodyTypeStatus {
  formData,
  raw,
  rawText,
}

class FormData {
  Map<String, String>? fields;
  List<CustomFile>? files;

  FormData({this.fields, this.files});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {};
    result["fields"] = fields;
    if (files?.isEmpty == true) {
      result["files"] = List.generate(
          files?.length ?? 0, (index) => files?.elementAt(index).toJson());
    }

    return result;
  }
}

class CustomFile {
  String? filename;
  String? key;
  String? path;
  Uint8List? bytes;

  CustomFile({this.filename, this.key, this.path, this.bytes});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = {};
    result["filename"] = filename;
    result["key"] = key;
    result["path"] = path;
    result["bytes"] = bytes;
    return result;
  }
}
