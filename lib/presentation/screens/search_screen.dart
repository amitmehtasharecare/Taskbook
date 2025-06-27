import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search_bloc.dart';
import '../widgets/book_list_item.dart';
import '../widgets/search_bar.dart';
import '../widgets/shimmer_list.dart';
import 'saved_books_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<SearchBloc>().add(SearchLoadMore());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    context.read<SearchBloc>().add(SearchQueryChanged(query));
  }

  Future<void> _onRefresh() async {
    context.read<SearchBloc>().add(SearchRefresh());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () => Navigator.pushNamed(context, SavedBooksScreen.routeName),
          ),
        ],
      ),
      body: Column(
        children: [
          SearchBarWidget(onSearch: _onSearch),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const ShimmerList();
                } else if (state is SearchLoaded) {
                  if (state.books.isEmpty) {
                    return const Center(child: Text('No books found.'));
                  }
                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: state.hasMore ? state.books.length + 1 : state.books.length,
                      itemBuilder: (context, index) {
                        if (index < state.books.length) {
                          return BookListItem(book: state.books[index]);
                        } else {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      },
                    ),
                  );
                } else if (state is SearchError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
