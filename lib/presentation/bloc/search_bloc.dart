import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/book.dart';
import '../../domain/usecases/search_books.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchBooks searchBooks;
  int _currentPage = 1;
  String _currentQuery = '';
  bool _hasMore = true;
  List<Book> _books = [];

  SearchBloc(this.searchBooks) : super(SearchInitial()) {
    on<SearchQueryChanged>(_onQueryChanged);
    on<SearchLoadMore>(_onLoadMore);
    on<SearchRefresh>(_onRefresh);
  }

  Future<void> _onQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    _currentQuery = event.query;
    _currentPage = 1;
    _hasMore = true;
    _books = [];
    try {
      final books = await searchBooks(event.query, _currentPage);
      _books = books;
      _hasMore = books.length >= 100; // OpenLibrary returns up to 100 per page
      emit(SearchLoaded(books: _books, hasMore: _hasMore));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onLoadMore(SearchLoadMore event, Emitter<SearchState> emit) async {
    if (!_hasMore || state is SearchLoadingMore) return;
    emit(SearchLoadingMore(books: _books));
    try {
      _currentPage++;
      final books = await searchBooks(_currentQuery, _currentPage);
      _books.addAll(books);
      _hasMore = books.length >= 100;
      emit(SearchLoaded(books: _books, hasMore: _hasMore));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onRefresh(SearchRefresh event, Emitter<SearchState> emit) async {
    add(SearchQueryChanged(_currentQuery));
  }
}
