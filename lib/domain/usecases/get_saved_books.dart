import '../repositories/book_repository.dart';
import '../entities/book.dart';

class GetSavedBooks {
  final BookRepository repository;
  GetSavedBooks(this.repository);

  Future<List<Book>> call() async {
    return await repository.getSavedBooks();
  }
}
