part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}
class SearchLoading extends SearchState {}
class SearchLoadingMore extends SearchState {
  final List<Book> books;
  const SearchLoadingMore({required this.books});
  @override
  List<Object?> get props => [books];
}
class SearchLoaded extends SearchState {
  final List<Book> books;
  final bool hasMore;
  const SearchLoaded({required this.books, required this.hasMore});
  @override
  List<Object?> get props => [books, hasMore];
}
class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);
  @override
  List<Object?> get props => [message];
}
