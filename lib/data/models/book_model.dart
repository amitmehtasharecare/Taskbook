import '../../domain/entities/book.dart';

class BookModel extends Book {
  const BookModel({
    required String id,
    required String title,
    required String author,
    String? coverUrl,
  }) : super(id: id, title: title, author: author, coverUrl: coverUrl);

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final coverId = json['cover_i'];
    return BookModel(
      id: json['key'] ?? '',
      title: json['title'] ?? '',
      author: (json['author_name'] != null && json['author_name'].isNotEmpty)
          ? json['author_name'][0]
          : '',
      coverUrl: coverId != null
          ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg'
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'coverUrl': coverUrl,
    };
  }
}
