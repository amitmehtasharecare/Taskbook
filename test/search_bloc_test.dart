import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:task26_2jun/domain/entities/book.dart';
import 'package:task26_2jun/domain/usecases/search_books.dart';
import 'package:task26_2jun/presentation/bloc/search_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:task26_2jun/domain/repositories/book_repository.dart';

class MockBookRepository extends Mock implements BookRepository {}

void main() {
  final books = [
    Book(id: '1', title: 'Test Book', author: 'Author', coverUrl: null),
  ];

  blocTest<SearchBloc, SearchState>(
    'emits [SearchLoading, SearchLoaded] when SearchQueryChanged is added and search succeeds',
    build: () {
      final mockBookRepository = MockBookRepository();
      when(mockBookRepository.searchBooks('test', 1)).thenAnswer((_) async => books);
      return SearchBloc(SearchBooks(mockBookRepository));
    },
    act: (bloc) => bloc.add(const SearchQueryChanged('test')),
    expect: () => [
      SearchLoading(),
      SearchLoaded(books: books, hasMore: false),
    ],
  );

  blocTest<SearchBloc, SearchState>(
    'emits [SearchLoading, SearchError] when SearchQueryChanged is added and search fails',
    build: () {
      final mockBookRepository = MockBookRepository();
      when(mockBookRepository.searchBooks('fail', 1)).thenThrow(Exception('error'));
      return SearchBloc(SearchBooks(mockBookRepository));
    },
    act: (bloc) => bloc.add(const SearchQueryChanged('fail')),
    expect: () => [
      SearchLoading(),
      isA<SearchError>(),
    ],
  );
}
