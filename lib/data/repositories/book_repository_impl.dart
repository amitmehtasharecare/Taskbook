import '../datasources/book_datasource.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';
import '../models/book_model.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDataSource remoteDataSource;
  final BookLocalDataSource localDataSource;

  BookRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Book>> searchBooks(String query, int page) async {
    return await remoteDataSource.searchBooks(query, page);
  }

  @override
  Future<void> saveBook(Book book) async {
    await localDataSource.saveBook(book as BookModel);
  }

  @override
  Future<List<Book>> getSavedBooks() async {
    return await localDataSource.getSavedBooks();
  }
}
