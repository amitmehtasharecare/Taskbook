import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final void Function(String) onSearch;
  const SearchBarWidget({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Search books by title...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: onSearch,
              textInputAction: TextInputAction.search,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.keyboard_return),
            onPressed: () {
              onSearch(controller.text);
            },
          ),
        ],
      ),
    );
  }
}
