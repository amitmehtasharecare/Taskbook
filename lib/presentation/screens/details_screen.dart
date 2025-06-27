import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/book.dart';
import '../bloc/saved_bloc.dart';

class DetailsScreen extends StatefulWidget {
  final Book book;
  const DetailsScreen({super.key, required this.book});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveBook() {
    context.read<SavedBloc>().add(SaveBookEvent(widget.book));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Book saved!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.book.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _animation.value * 2 * 3.14159,
                    child: child,
                  );
                },
                child: widget.book.coverUrl != null
                    ? Image.network(widget.book.coverUrl!, width: 150, height: 200, fit: BoxFit.cover)
                    : const Icon(Icons.book, size: 150),
              ),
            ),
            const SizedBox(height: 24),
            Text(widget.book.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('by ${widget.book.author}', style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Save Book'),
              onPressed: _saveBook,
            ),
          ],
        ),
      ),
    );
  }
}
