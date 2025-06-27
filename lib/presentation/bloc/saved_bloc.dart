import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/book.dart';
import '../../domain/usecases/get_saved_books.dart';
import '../../domain/usecases/save_book.dart';

part 'saved_event.dart';
part 'saved_state.dart';

class SavedBloc extends Bloc<SavedEvent, SavedState> {
  final GetSavedBooks getSavedBooks;
  final SaveBook saveBook;

  SavedBloc({required this.getSavedBooks, required this.saveBook}) : super(SavedInitial()) {
    on<LoadSavedBooks>(_onLoadSavedBooks);
    on<SaveBookEvent>(_onSaveBook);
  }

  Future<void> _onLoadSavedBooks(LoadSavedBooks event, Emitter<SavedState> emit) async {
    emit(SavedLoading());
    try {
      final books = await getSavedBooks();
      emit(SavedLoaded(books));
    } catch (e) {
      emit(SavedError(e.toString()));
    }
  }

  Future<void> _onSaveBook(SaveBookEvent event, Emitter<SavedState> emit) async {
    try {
      await saveBook(event.book);
      add(LoadSavedBooks());
    } catch (e) {
      emit(SavedError(e.toString()));
    }
  }
}
