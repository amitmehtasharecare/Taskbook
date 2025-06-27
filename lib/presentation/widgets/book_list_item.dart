import 'package:flutter/material.dart';
import '../../domain/entities/book.dart';
import '../screens/details_screen.dart';

class BookListItem extends StatelessWidget {
  final Book book;
  const BookListItem({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: book.coverUrl != null
          ? Image.network(book.coverUrl!, width: 50, fit: BoxFit.cover)
          : const Icon(Icons.book, size: 50),
      title: Text(book.title),
      subtitle: Text(book.author),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailsScreen(book: book),
        ),
      ),
    );
  }
}
