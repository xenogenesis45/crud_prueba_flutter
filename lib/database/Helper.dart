import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';

import 'package:prueba_crud/models/User.dart';

class Helper {
  static final Helper _instance = new Helper.internal();
  factory Helper() => _instance;
  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  Helper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
          create table user ( 
          id integer primary key autoincrement, 
          nombre text not null,
          telefono text not null,
          email text not null)
          ''');
    });
    return theDb;
  }

  Future<User> insert(User user) async {
    var dbClient = await db;
    user.id = await dbClient.insert('user', user.toJson());
    return user;
  }

  Future<User> getUser(int id) async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query('user',
        columns: ['id', 'nombre', 'telefono', 'email'],
        where: 'id = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return User.fromJson(maps.first);
    }
    return null;
  }

  Future<List> getAllUsers() async {
    List<User> user = List();
    var dbClient = await db;
    List<Map> maps = await dbClient
        .query('user', columns: ['id', 'nombre', 'telefono', 'email']);
    if (maps.length > 0) {
      maps.forEach(
        (f) {
          user.add(User.fromJson(f));
        },
      );
    }
    return user;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete('user', where: 'id  = ?', whereArgs: [id]);
  }

  Future<int> update(User user) async {
    var dbClient = await db;
    return await dbClient
        .update('user', user.toJson(), where: 'id = ?', whereArgs: [user.id]);
  }

  close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
