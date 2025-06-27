part of 'saved_bloc.dart';

abstract class SavedState extends Equatable {
  const SavedState();
  @override
  List<Object?> get props => [];
}

class SavedInitial extends SavedState {}
class SavedLoading extends SavedState {}
class SavedLoaded extends SavedState {
  final List<Book> books;
  const SavedLoaded(this.books);
  @override
  List<Object?> get props => [books];
}
class SavedError extends SavedState {
  final String message;
  const SavedError(this.message);
  @override
  List<Object?> get props => [message];
}
