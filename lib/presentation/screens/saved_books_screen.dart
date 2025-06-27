import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/saved_bloc.dart';

class SavedBooksScreen extends StatelessWidget {
  static const routeName = '/saved';
  const SavedBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved Books')),
      body: BlocBuilder<SavedBloc, SavedState>(
        builder: (context, state) {
          if (state is SavedLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SavedLoaded) {
            if (state.books.isEmpty) {
              return const Center(child: Text('No saved books.'));
            }
            return ListView.builder(
              itemCount: state.books.length,
              itemBuilder: (context, index) {
                final book = state.books[index];
                return ListTile(
                  leading: book.coverUrl != null
                      ? Image.network(book.coverUrl!, width: 50, fit: BoxFit.cover)
                      : const Icon(Icons.book, size: 50),
                  title: Text(book.title),
                  subtitle: Text(book.author),
                );
              },
            );
          } else if (state is SavedError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
