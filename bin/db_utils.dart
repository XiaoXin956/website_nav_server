import 'package:mysql1/mysql1.dart';

var mysqlSettings = ConnectionSettings(
  host: 'mysql.sqlpub.com',
  port: 3306,
  user: 'z853006022',
  password: '90b23819e94572af',
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
