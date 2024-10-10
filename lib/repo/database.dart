import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  // Factory constructor to return instance
  factory DatabaseHelper() {
    return _instance;
  }

  // Get the database
  Future<Database> _initDatabase() async {
    // Get the path we will store data on it
    String path = join(await getDatabasesPath(), 'user_database.db');

    // Open the database, create it if it doesn't exist
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users ( 
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          age INTEGER
          )
        ''');
      },
    );
  }

  // Ensure the database is initialized
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  // Insert a new user into the user table
  Future<void> insertUser(String name, int age) async {
    final db = await database; // Use the initialized database
    await db.insert(
      'users',
      {'name': name, 'age': age},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve all users from the users table
  Future<List<Map<String, dynamic>>?> getUsers() async {
    final db = await database; // Use the initialized database
    return await db.query('users');
  }

  // Update a user's information in the user table
  Future<void> updateUser(int id, String name, int age) async {
    final db = await database; // Use the initialized database
    await db.update(
      'users',
      {'name': name, 'age': age},
      where: 'id = ?', // Update the user with this ID
      whereArgs: [id],
    );
    print('User Updated succesfuly');
  }

  // Delete an item from the database
  Future<void> deleteUser(int id) async {
    final db = await database; // Use the initialized database
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
