part of 'saved_bloc.dart';

abstract class SavedEvent extends Equatable {
  const SavedEvent();
  @override
  List<Object?> get props => [];
}

class LoadSavedBooks extends SavedEvent {}

class SaveBookEvent extends SavedEvent {
  final Book book;
  const SaveBookEvent(this.book);
  @override
  List<Object?> get props => [book];
}
