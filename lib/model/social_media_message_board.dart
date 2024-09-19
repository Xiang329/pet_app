import 'package:pet_app/model/social_media.dart';

class SocialMediaMessageBoard {
  int mbId;
  int mbSid;
  int mbMemberId;
  String mbContent;
  DateTime mbDateTime;
  SocialMedia? socialMedia;

  SocialMediaMessageBoard({
    required this.mbId,
    required this.mbSid,
    required this.mbMemberId,
    required this.mbContent,
    required this.mbDateTime,
    this.socialMedia,
  });

  factory SocialMediaMessageBoard.fromJson(Map<String, dynamic> json) {
    return SocialMediaMessageBoard(
      mbId: json['MB_ID'],
      mbSid: json['MB_SID'],
      mbMemberId: json['MB_MemberID'],
      mbContent: json['MB_Content'],
      mbDateTime: DateTime.parse(json['MB_DateTime']),
      socialMedia: json['SocialMedia'] == null
          ? null
          : SocialMedia.fromJson(json['SocialMedia']),
    );
  }

  Map<String, dynamic> toJson() => {
        'MB_ID': mbId,
        'MB_SID': mbSid,
        'MB_MemberID': mbMemberId,
        'MB_Content': mbContent,
        'MB_DateTime': mbDateTime.toIso8601String(),
        'SocialMedia': socialMedia?.toJson(),
      };
}
