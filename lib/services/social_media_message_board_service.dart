import 'package:dio/dio.dart';
import 'package:pet_app/services/api_service.dart';
import 'package:pet_app/services/api_urls.dart';

class SocialMediaMessageBoardsService {
  static CancelToken _oldCancelToken = CancelToken();

  static Future<void> createSocialMediaMessage(
      Map<String, dynamic> data) async {
    await ApiService().request(
      ApiUrls.socialMediaMessageBoards,
      method: DioMethod.post,
      data: data,
      // cancelToken: await cancelOldAndGetNewToken(),
    );
  }

  static Future<void> updateSocialMediaMessage(
      int id, Map<String, dynamic> data) async {
    await ApiService().request(
      '${ApiUrls.socialMediaMessageBoards}/$id',
      method: DioMethod.put,
      data: data,
      // cancelToken: await cancelOldAndGetNewToken(),
    );
  }

  static Future<void> deleteSocialMediaMessage(int id) async {
    await ApiService().request(
      '${ApiUrls.socialMediaMessageBoards}/$id',
      method: DioMethod.delete,
      // cancelToken: await cancelOldAndGetNewToken(),
    );
  }

  static Future<CancelToken> cancelOldAndGetNewToken() async {
    ApiService().cancelRequests(token: _oldCancelToken);
    await _oldCancelToken.whenCancel;
    CancelToken newCancelToken = CancelToken();
    _oldCancelToken = newCancelToken;
    return newCancelToken;
  }
}
