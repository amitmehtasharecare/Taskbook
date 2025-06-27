import '../models/book_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class BookRemoteDataSource {
  Future<List<BookModel>> searchBooks(String query, int page);
}

class BookRemoteDataSourceImpl implements BookRemoteDataSource {
  static const _baseUrl = 'https://openlibrary.org/search.json';

  @override
  Future<List<BookModel>> searchBooks(String query, int page) async {
    final response = await http.get(Uri.parse('$_baseUrl?q=$query&page=$page'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final docs = data['docs'] as List;
      return docs.map((e) => BookModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }
}

abstract class BookLocalDataSource {
  Future<void> saveBook(BookModel book);
  Future<List<BookModel>> getSavedBooks();
}

class BookLocalDataSourceImpl implements BookLocalDataSource {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'books.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE books(
            id TEXT PRIMARY KEY,
            title TEXT,
            author TEXT,
            coverUrl TEXT
          )
        ''');
      },
    );
  }

  @override
  Future<void> saveBook(BookModel book) async {
    final db = await database;
    await db.insert('books', book.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<List<BookModel>> getSavedBooks() async {
    final db = await database;
    final maps = await db.query('books');
    return maps.map((e) => BookModel(
      id: e['id'] as String,
      title: e['title'] as String,
      author: e['author'] as String,
      coverUrl: e['coverUrl'] as String?,
    )).toList();
  }
}
