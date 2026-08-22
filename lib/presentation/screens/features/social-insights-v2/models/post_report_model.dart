import 'package:flutter/material.dart';

enum PostReportReason {
  NUDITY_OR_SEXUAL_CONTENT(
    'Nudity or Sexual Content',
    'Explicit or sexually suggestive content, pornography, or nudity.',
    Icons.no_adult_content_rounded,
  ),
  VIOLENCE_OR_THREATS(
    'Violence or Threats',
    'Threats of physical harm, self-harm, graphic violence, or terrorism.',
    Icons.warning_amber_rounded,
  ),
  BULLYING_OR_HARASSMENT(
    'Bullying or Harassment',
    'Targeted harassment, personal attacks, or bullying.',
    Icons.sentiment_very_dissatisfied_rounded,
  ),
  HATE_SPEECH_OR_HATEFUL_CONDUCT(
    'Hate Speech or Hateful Conduct',
    'Hate speech, discrimination, slur words, or abusive language.',
    Icons.block_rounded,
  ),
  ILLEGAL_OR_RESTRICTED_CONTENT(
    'Illegal or Restricted Content',
    'Sale of illegal goods, regulated drugs, or prohibited activities.',
    Icons.gavel_rounded,
  );

  final String title;
  final String description;
  final IconData icon;

  const PostReportReason(this.title, this.description, this.icon);

  static PostReportReason fromString(String value) {
    return PostReportReason.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PostReportReason.HATE_SPEECH_OR_HATEFUL_CONDUCT,
    );
  }
}

enum PostReportReviewAction {
  TAKE_ACTION,
  DISMISS;

  static PostReportReviewAction fromString(String value) {
    return PostReportReviewAction.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PostReportReviewAction.DISMISS,
    );
  }
}

enum PostReportStatus {
  PENDING('Pending Review', Colors.orange),
  ACTION_TAKEN('Action Taken', Colors.red),
  DISMISSED('Dismissed', Colors.green);

  final String label;
  final Color color;

  const PostReportStatus(this.label, this.color);

  static PostReportStatus fromString(String value) {
    return PostReportStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PostReportStatus.PENDING,
    );
  }
}

class PostReportReqDto {
  final String postId;
  final PostReportReason reason;
  final String? description;

  PostReportReqDto({
    required this.postId,
    required this.reason,
    this.description,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'postId': postId,
      'reason': reason.name,
    };
    if (description != null && description!.trim().isNotEmpty) {
      data['description'] = description;
    }
    return data;
  }
}

class ReviewPostReportReqDto {
  final String reportId;
  final PostReportReviewAction action;
  final String adminRemark;

  ReviewPostReportReqDto({
    required this.reportId,
    required this.action,
    required this.adminRemark,
  });

  Map<String, dynamic> toJson() => {
        'reportId': reportId,
        'action': action.name,
        'adminRemark': adminRemark,
      };
}

class PostReportPostInfo {
  final String id;
  final String caption;
  final String? imageUrl;
  final List<String> mediaUrls;
  final bool active;
  final String? moderationReason;
  final DateTime? createdAt;
  final String? authorName;
  final String? authorUsername;
  final String? authorId;
  final bool authorActive;

  PostReportPostInfo({
    required this.id,
    required this.caption,
    this.imageUrl,
    this.mediaUrls = const [],
    this.active = true,
    this.moderationReason,
    this.createdAt,
    this.authorName,
    this.authorUsername,
    this.authorId,
    this.authorActive = true,
  });

  factory PostReportPostInfo.fromJson(Map<String, dynamic> json) {
    List<String> media = [];
    if (json['mediaUrls'] is List) {
      media = (json['mediaUrls'] as List).map((e) => e.toString()).toList();
    } else if (json['imageUrl'] != null && json['imageUrl'].toString().isNotEmpty) {
      media = [json['imageUrl'].toString()];
    }

    String? authorN;
    String? authorU;
    String? authorI;
    bool authorA = true;
    if (json['author'] is Map) {
      authorN = json['author']['name'];
      authorU = json['author']['username'];
      authorI = json['author']['id'];
      authorA = json['author']['active'] ?? true;
    }

    DateTime? parsedDate;
    if (json['createdAt'] is List) {
      final list = json['createdAt'] as List;
      if (list.length >= 6) {
        parsedDate = DateTime(
          list[0],
          list[1],
          list[2],
          list[3],
          list[4],
          list[5],
        );
      }
    } else if (json['createdAt'] is String) {
      parsedDate = DateTime.tryParse(json['createdAt']);
    }

    return PostReportPostInfo(
      id: json['id'] ?? '',
      caption: json['caption'] ?? '',
      imageUrl: json['imageUrl'],
      mediaUrls: media,
      active: json['active'] ?? true,
      moderationReason: json['moderationReason'],
      createdAt: parsedDate,
      authorName: authorN,
      authorUsername: authorU,
      authorId: authorI,
      authorActive: authorA,
    );
  }
}

class PostReportUserInfo {
  final String id;
  final String username;
  final String name;

  PostReportUserInfo({
    required this.id,
    required this.username,
    required this.name,
  });

  factory PostReportUserInfo.fromJson(Map<String, dynamic> json) {
    return PostReportUserInfo(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      name: json['name'] ?? json['username'] ?? 'Anonymous',
    );
  }
}

class PostReportResDto {
  final String reportId;
  final PostReportPostInfo post;
  final PostReportUserInfo reporter;
  final PostReportReason reason;
  final String? description;
  final PostReportStatus status;
  final DateTime? reportedAt;
  final DateTime? reviewedAt;
  final String? reviewedBy;
  final String? adminRemark;

  PostReportResDto({
    required this.reportId,
    required this.post,
    required this.reporter,
    required this.reason,
    this.description,
    required this.status,
    this.reportedAt,
    this.reviewedAt,
    this.reviewedBy,
    this.adminRemark,
  });

  factory PostReportResDto.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic dateVal) {
      if (dateVal is List && dateVal.length >= 6) {
        return DateTime(
          dateVal[0],
          dateVal[1],
          dateVal[2],
          dateVal[3],
          dateVal[4],
          dateVal[5],
        );
      } else if (dateVal is String) {
        return DateTime.tryParse(dateVal);
      }
      return null;
    }

    return PostReportResDto(
      reportId: json['reportId'] ?? '',
      post: PostReportPostInfo.fromJson(json['post'] ?? {}),
      reporter: PostReportUserInfo.fromJson(json['reporter'] ?? {}),
      reason: PostReportReason.fromString(json['reason'] ?? ''),
      description: json['description'],
      status: PostReportStatus.fromString(json['status'] ?? ''),
      reportedAt: parseDate(json['reportedAt']),
      reviewedAt: parseDate(json['reviewedAt']),
      reviewedBy: json['reviewedBy'],
      adminRemark: json['adminRemark'],
    );
  }
}

class PostReportPageResDto {
  final List<PostReportResDto> reports;
  final int currentPage;
  final int pageSize;
  final int totalElements;
  final int totalPages;
  final bool last;

  PostReportPageResDto({
    required this.reports,
    required this.currentPage,
    required this.pageSize,
    required this.totalElements,
    required this.totalPages,
    required this.last,
  });

  factory PostReportPageResDto.fromJson(Map<String, dynamic> json) {
    final list = (json['reports'] as List?)
            ?.map((e) => PostReportResDto.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return PostReportPageResDto(
      reports: list,
      currentPage: json['currentPage'] ?? 0,
      pageSize: json['pageSize'] ?? 20,
      totalElements: json['totalElements'] ?? list.length,
      totalPages: json['totalPages'] ?? 1,
      last: json['last'] ?? true,
    );
  }
}
