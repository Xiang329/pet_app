import 'package:dio/dio.dart';
import 'package:pet_app/services/api_interceptors.dart';
import 'package:pet_app/services/api_urls.dart';

enum DioMethod { get, post, put, delete }

class ApiService {
  static String baseUrl = ApiUrls.baseUrl;
  // 連線線逾時
  static const int connectTimeout = 10 * 1000;
  // 接收逾時
  static const int receiveTimeout = 10 * 1000;

  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  late Dio _dio;

  ApiService._internal() {
    // 初始化配置
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: connectTimeout),
      receiveTimeout: const Duration(seconds: receiveTimeout),
      headers: {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      },
    );
    // 初始化Dio
    _dio = Dio(options);
    // 自定義攔截器
    _dio.interceptors.add(ApiInterceptors());
  }

  // 取消請求Token
  final CancelToken _cancelToken = CancelToken();

  // 取消網路請求
  void cancelRequests({CancelToken? token}) {
    token?.cancel("cancelled");
  }

  Future<Response> request<T>(
    String path, {
    required DioMethod method,
    Map<String, dynamic>? params,
    Object? data,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    const methodValues = {
      DioMethod.get: 'get',
      DioMethod.post: 'post',
      DioMethod.put: 'put',
      DioMethod.delete: 'delete',
    };

    options ??= Options(method: methodValues[method]);
    try {
      Response response;
      response = await _dio.request(path,
          data: data,
          queryParameters: params,
          cancelToken: cancelToken ?? _cancelToken,
          options: options,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress);
      return response;
    } on DioException catch (e) {
      throw ('${e.message}');
    }
  }
}
