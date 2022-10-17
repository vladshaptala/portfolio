import 'dart:convert';

class FeedbackModel {
  final String id;
  final double rating;
  final String? comment;

  FeedbackModel({
    required this.id,
    required this.rating,
    this.comment,
  });

  FeedbackModel copyWith({
    String? id,
    double? rating,
    String? comment,
  }) {
    return FeedbackModel(
      id: id ?? this.id,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'rating': rating});
    if (comment != null) {
      result.addAll({'comment': comment});
    }

    return result;
  }

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      id: map['id'] ?? '',
      rating: map['rating']?.toDouble() ?? 0.0,
      comment: map['comment'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FeedbackModel.fromJson(String source) =>
      FeedbackModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'FeedbackModel(id: $id, rating: $rating, comment: $comment)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FeedbackModel &&
        other.id == id &&
        other.rating == rating &&
        other.comment == comment;
  }

  @override
  int get hashCode => id.hashCode ^ rating.hashCode ^ comment.hashCode;
}
