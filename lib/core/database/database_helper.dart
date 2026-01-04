import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('formify.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const textTypeNullable = 'TEXT';
    const integerType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';

    // Business Profiles Table
    await db.execute('''
      CREATE TABLE business_profiles (
        id $idType,
        name $textType,
        email $textTypeNullable,
        phone $textTypeNullable,
        address $textTypeNullable,
        city $textTypeNullable,
        country $textTypeNullable,
        taxId $textTypeNullable,
        logo $textTypeNullable,
        isDefault $integerType,
        createdAt $textType
      )
    ''');

    // Customers Table
    await db.execute('''
      CREATE TABLE customers (
        id $idType,
        name $textType,
        email $textTypeNullable,
        phone $textTypeNullable,
        address $textTypeNullable,
        city $textTypeNullable,
        country $textTypeNullable,
        taxId $textTypeNullable,
        createdAt $textType
      )
    ''');

    // Documents Table
    await db.execute('''
      CREATE TABLE documents (
        id $idType,
        type $textType,
        documentNumber $textType,
        title $textType,
        data $textType,
        totalAmount $realType,
        currency $textType,
        createdAt $textType,
        updatedAt $textType
      )
    ''');

    // Templates Table
    await db.execute('''
      CREATE TABLE templates (
        id $idType,
        type $textType,
        name $textType,
        data $textType,
        isPremium $integerType,
        createdAt $textType
      )
    ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  // Generic CRUD operations
  Future<int> insert(String table, Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    final db = await instance.database;
    return await db.query(table, orderBy: 'createdAt DESC');
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
  }) async {
    final db = await instance.database;
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );
  }

  Future<int> update(String table, Map<String, dynamic> row) async {
    final db = await instance.database;
    final id = row['id'];
    return await db.update(
      table,
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(String table, String id) async {
    final db = await instance.database;
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
