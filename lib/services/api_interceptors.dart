import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiInterceptors extends Interceptor {
  // 儲存請求
  final Map<String, Completer<void>> _requestCompleters = {};

  // 請求攔截，過濾重複的請求
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final String key = _generateKey(options);

    // 如果請求重複，則取消請求
    if (['POST', 'PUT', 'DELETE'].contains(options.method)) {
      if (_requestCompleters.containsKey(key)) {
        return handler.reject(DioException(
          requestOptions: options,
          type: DioExceptionType.cancel,
        ));
      }

      final completer = Completer<void>();
      _requestCompleters[key] = completer;

      handler.next(options);

      // 清除完成的請求
      completer.future.whenComplete(() {
        _requestCompleters.remove(key);
      });
      return;
    }
    super.onRequest(options, handler);
  }

  String _generateKey(RequestOptions options) {
    return '${options.method}:${options.uri.toString()}';
  }

  // 回應攔截
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final String key = _generateKey(response.requestOptions);
    _requestCompleters[key]?.complete();
    // debugPrint(
    //     'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    debugPrint(
        'RESPONSE[${response.statusCode} / ${response.requestOptions.method} / ${response.realUri}]');
    // debugPrint(
    //     'RESPONSE[${response.statusCode} / ${response.requestOptions.method}]');
    super.onResponse(response, handler);
  }

  // 錯誤攔截
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 自定義錯誤訊息
    DioException errMessage = err.copyWith();
    final String key = _generateKey(err.requestOptions);
    _requestCompleters[key]?.complete();

    if (err.response != null) {
      debugPrint(
          'ERROR RESPONSE[${err.response!.statusCode} / ${err.response!.requestOptions.method} / ${err.response!.realUri}]');
      if (err.response!.realUri.toString().contains('Members?email=')) {
        if (err.response!.statusCode == 404) {
          errMessage = err.copyWith(message: '帳號不存在，請先建立帳號。');
          return super.onError(errMessage, handler);
        }
      }
      if (err.response!.realUri.toString().contains('Pets?code=')) {
        if (err.response!.statusCode == 404) {
          errMessage = err.copyWith(message: '無效的邀請碼。');
          return super.onError(errMessage, handler);
        }
      }
    }
    switch (err.type) {
      case DioExceptionType.unknown:
        break;
      case DioExceptionType.connectionError:
        errMessage = err.copyWith(message: '無法連線至伺服器，請檢查網路連線。');
        break;
      case DioExceptionType.connectionTimeout:
        errMessage = err.copyWith(message: '網路連線超時，請檢查網路設定。');
        break;
      case DioExceptionType.sendTimeout:
        errMessage = err.copyWith(message: '發送逾時。');
        break;
      case DioExceptionType.receiveTimeout:
        errMessage = err.copyWith(message: '接收逾時。');
        break;
      case DioExceptionType.badResponse:
        errMessage = err.copyWith(message: '無法連線至伺服器，請檢查網路連線。');
        break;
      case DioExceptionType.cancel:
        errMessage = err.copyWith(message: '重複操作間隔太快，請稍後再試。');
        // break;
        debugPrint(errMessage.message);
        return;
      default:
        errMessage = err.copyWith(message: '網路異常，請稍後重試。');
        break;
    }
    super.onError(errMessage, handler);
  }
}
