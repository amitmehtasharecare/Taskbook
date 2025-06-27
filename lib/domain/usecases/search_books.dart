import '../repositories/book_repository.dart';
import '../entities/book.dart';

class SearchBooks {
  final BookRepository repository;
  SearchBooks(this.repository);

  Future<List<Book>> call(String query, int page) async {
    return await repository.searchBooks(query, page);
  }
}
