import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteHelper {
  // Sqlite DB 초기화
  static Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'table_now.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE bookmark(id INTEGER PRIMARY KEY AUTOINCREMENT, storeId INTEGER)',
        );
      },
      version: 1,
    );
  }

  // 즐겨찾기 5개 조회
  static Future<List<int>> findFiveStoreIds() async {
    final db = await SqliteHelper.initDatabase();
    // 테이블 초기화 코드
    // db.execute('DROP TABLE bookmark');
    // db.execute(
    //   'CREATE TABLE bookmark(id INTEGER PRIMARY KEY AUTOINCREMENT, storeId INTEGER)',
    // );
    List<Map<String, dynamic>> result =
        await db.query('bookmark', orderBy: 'id DESC', limit: 5);
    return List.generate(result.length, (index) => result[index]['storeId']);
  }

  // 즐겨찾기 전체조회
  static Future<List<int>> findAllStoreId() async {
    final db = await SqliteHelper.initDatabase();
    List<Map<String, dynamic>> result =
        await db.query('bookmark', orderBy: 'id DESC');
    return List.generate(result.length, (index) => result[index]['storeId']);
  }

  // 즐겨찾기에 추가
  static Future addStoreId(int storeId) async {
    final db = await SqliteHelper.initDatabase();
    await db.insert('bookmark', {'storeId': storeId});
  }

  // 즐겨찾기에서 삭제
  static Future deleteByStoreId(int storeId) async {
    final db = await SqliteHelper.initDatabase();
    await db.delete('bookmark', where: 'storeId = ?', whereArgs: [storeId]);
  }

  // 즐겨찾기 포함 여부 확인 (존재 시 1 리턴)
  static Future<int?> checkIsBookmarked(int storeId) async {
    final db = await SqliteHelper.initDatabase();
    return Sqflite.firstIntValue(await db.rawQuery(
        'SELECT COUNT(*) FROM bookmark WHERE storeId = ?', [storeId]));
  }

  // 즐겨찾기 전체개수 조회
  static Future<int?> findTotalCount() async {
    final db = await SqliteHelper.initDatabase();
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM bookmark'));
  }
}
