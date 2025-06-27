import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/book_datasource.dart';
import '../../data/repositories/book_repository_impl.dart';
import '../../domain/usecases/search_books.dart';
import '../../domain/usecases/save_book.dart';
import '../../domain/usecases/get_saved_books.dart';
import '../bloc/search_bloc.dart';
import '../bloc/saved_bloc.dart';
import 'search_screen.dart';
import 'saved_books_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final remoteDataSource = BookRemoteDataSourceImpl();
    final localDataSource = BookLocalDataSourceImpl();
    final repository = BookRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SearchBloc(SearchBooks(repository)),
        ),
        BlocProvider(
          create: (_) => SavedBloc(
            getSavedBooks: GetSavedBooks(repository),
            saveBook: SaveBook(repository),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Book Search',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SearchScreen(),
        routes: {
          SavedBooksScreen.routeName: (_) => const SavedBooksScreen(),
        },
      ),
    );
  }
}
