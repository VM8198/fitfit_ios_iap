import 'package:dio/dio.dart';
import 'package:flutter_fitfit/utility/pref.dart';

class Api {
  final _baseUrl = 'https://studio.fitfitapp.co/api/app';
  Dio _dio = new Dio();
  
  Api() {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers = {
      Headers.contentTypeHeader: Headers.jsonContentType,
      Headers.acceptHeader: Headers.jsonContentType, 
    };
  }

  get(path) async{
    var results;

    try {
      results = await _dio.get(_getPath(path));
    }on DioError catch(e) {
      if (e.response.statusCode != 500) {
        return e.response.data;
      }
      throw e;
    }

    return results.data;
  }

  getAuth(String path) async{
    var results;
    String token = await Pref.getToken();
    _dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      results = await _dio.get<Map>(
        _getPath(path),
      );
    }on DioError catch(e) {
      if (e.response.statusCode != 500) {
        return e.response.data;
      }
      throw e;
    }

    return results.data;
  }

  post(String path, dynamic data) async{
    var results;
    print(_getPath(path));
    try {
      results = await _dio.post<Map>(
        _getPath(path),
        data: data
      );
    }on DioError catch(e) {
      if (e.response.statusCode != 500) {
        return e.response.data;
      }
      throw e;
    }

    return results.data;
  }

  postAuth(String path, dynamic data) async{
    var results;
    String token = await Pref.getToken();
    _dio.options.headers['Authorization'] = 'Bearer $token';

    try {
      results = await _dio.post<Map>(
        _getPath(path),
        data: data
      );
    }on DioError catch(e) {
      if (e.response.statusCode != 500) {
        return e.response.data;
      }
      throw e;
    }

    return results.data;
  }

  _getPath(String path) {
    return _baseUrl+path;
  }
}