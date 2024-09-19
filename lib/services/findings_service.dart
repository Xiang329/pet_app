import 'package:pet_app/model/finding.dart';
import 'package:pet_app/services/api_service.dart';
import 'package:pet_app/services/api_urls.dart';

class FindingsService {
  static Future<List<Finding>> getFindings() async {
    List<Finding> findings = [];
    final response = await ApiService().request(
      ApiUrls.findings,
      method: DioMethod.get,
    );

    findings = List<Finding>.from(
        (response.data as List).map((e) => Finding.fromJson(e)));
    for (var value in findings) {
      print(value.findingId);
    }
    return findings;
  }

  static Future<Finding> getFindingById(int id) async {
    Finding finding;
    final response = await ApiService().request(
      '${ApiUrls.findings}/$id',
      method: DioMethod.get,
    );

    finding = Finding.fromJson(response.data);
    print(finding.findingId);
    return finding;
  }

  static Future<List<Finding>> getFindingsByMemberId(int memberId) async {
    List<Finding> findings = [];
    final response = await ApiService().request(
      ApiUrls.findings,
      method: DioMethod.get,
      params: {'member_id': memberId},
    );

    findings = List<Finding>.from(
        (response.data as List).map((e) => Finding.fromJson(e)));
    for (var value in findings) {
      print(value.findingId);
    }
    return findings;
  }

  static Future<void> createFinding(Map<String, dynamic> data) async {
    Finding finding;
    final response = await ApiService().request(
      ApiUrls.findings,
      method: DioMethod.post,
      data: data,
    );

    finding = Finding.fromJson(response.data);
    print(finding.findingId);
  }

  static Future<void> updateFinding(int id, Map<String, dynamic> data) async {
    await ApiService().request(
      '${ApiUrls.findings}/$id',
      method: DioMethod.put,
      data: data,
    );
  }

  static Future<void> deleteFinding(int id) async {
    await ApiService().request(
      '${ApiUrls.findings}/$id',
      method: DioMethod.delete,
    );
  }
}
