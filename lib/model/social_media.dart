import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pet_app/model/member.dart';
import 'package:pet_app/model/social_media_message_board.dart';

class SocialMedia {
  int smId;
  int smMemberId;
  Uint8List smImage;
  String smContent;
  DateTime smDateTime;
  Member? member;
  List<SocialMediaMessageBoard> messageBoards;

  SocialMedia({
    required this.smId,
    required this.smMemberId,
    required this.smImage,
    required this.smContent,
    required this.smDateTime,
    this.member,
    required this.messageBoards,
  });

  factory SocialMedia.fromJson(Map<String, dynamic> json) {
    return SocialMedia(
      smId: json['SM_ID'],
      smMemberId: json['SM_MemberID'],
      smImage: base64Decode(json['SM_Image'] ?? ''),
      smContent: json['SM_Content'],
      smDateTime: DateTime.parse(json['SM_DateTime']),
      member: json['Member'] == null ? null : Member.fromJson(json['Member']),
      messageBoards: (json['SocialMediaMessageBoard'] as List<dynamic>)
          .map((boardJson) => SocialMediaMessageBoard.fromJson(boardJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'SM_ID': smId,
        'SM_MemberID': smMemberId,
        'SM_Image': smImage,
        'SM_Content': smContent,
        'SM_DateTime': smDateTime.toIso8601String(),
        'Member': member?.toJson(),
        'SocialMediaMessageBoard':
            messageBoards.map((board) => board.toJson()).toList(),
      };
}
