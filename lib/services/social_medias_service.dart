import 'package:pet_app/model/social_media.dart';
import 'package:pet_app/services/api_service.dart';
import 'package:pet_app/services/api_urls.dart';

class SocialMediasService {
  static Future<List<SocialMedia>> getSocialMedias() async {
    List<SocialMedia> socialMedias = [];
    final response = await ApiService().request(
      ApiUrls.socialMedias,
      method: DioMethod.get,
    );
    socialMedias = List<SocialMedia>.from(
        (response.data as List).map((e) => SocialMedia.fromJson(e)));
    // for (var value in socialMedias) {
    //   print(value.smId);
    // }
    return socialMedias;
  }

  static Future<SocialMedia> getSocialMediaById(int id) async {
    final response = await ApiService().request(
      '${ApiUrls.socialMedias}/$id',
      method: DioMethod.get,
    );

    return SocialMedia.fromJson(response.data);
  }

  static Future<List<SocialMedia>> getSocialMediasByMemberId(int id) async {
    List<SocialMedia> socialMedias = [];
    final response = await ApiService().request(
      ApiUrls.socialMedias,
      params: {'member_id': id},
      method: DioMethod.get,
    );
    socialMedias = List<SocialMedia>.from(
        (response.data as List).map((e) => SocialMedia.fromJson(e)));
    // for (var value in socialMedias) {
    //   print(value.smId);
    // }
    return socialMedias;
  }

  static Future<void> createSocialMedia(Map<String, dynamic> data) async {
    await ApiService().request(
      ApiUrls.socialMedias,
      method: DioMethod.post,
      data: data,
    );
  }

  static Future<void> updateSocialMedia(
      int id, Map<String, dynamic> data) async {
    await ApiService().request(
      '${ApiUrls.socialMedias}/$id',
      method: DioMethod.put,
      data: data,
    );
  }

  static Future<void> deleteSocialMedia(int id) async {
    await ApiService().request(
      '${ApiUrls.socialMedias}/$id',
      method: DioMethod.delete,
    );
  }
}
