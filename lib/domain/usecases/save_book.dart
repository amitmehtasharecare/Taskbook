import '../repositories/book_repository.dart';
import '../entities/book.dart';

class SaveBook {
  final BookRepository repository;
  SaveBook(this.repository);

  Future<void> call(Book book) async {
    await repository.saveBook(book);
  }
}
