import 'package:mysql1/mysql1.dart';

var mysqlSettings = ConnectionSettings(
  host: 'mysql.sqlpub.com',
  port: 3306,
  user: 'z853006022',
  password: 'a72fd3cb8ede27c0',
  db: 'website_nav',
);

class DbUtils {
  static MySqlConnection? _db;

  static Future<MySqlConnection> instance() async {
    _db?.close();
    _db = await MySqlConnection.connect(mysqlSettings);
    return _db!;
  }
}
