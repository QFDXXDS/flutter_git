
import 'package:sqflite/sqlite_api.dart';
import 'package:meta/meta.dart';
import 'package:flutter_git/common/ab/sql_manager.dart';


abstract class BaseDbProvider {

  bool isTableExits = false ;

  tableSqlString();

  tableName();

  tableBaseString(String name, String columnId) {
    return '''
        create table $name (
        $columnId integer primary key autoincrement,
      ''';
  }

  Future<Database> getDataBase() async {

    return await open() ;
  }
  
  @mustCallSuper 
  prepare(name,String createSql) async {
    
    isTableExits = await SqlManager.isTableExits(name) ;
    if(!isTableExits) {
      
      Database db = await SqlManager.getCurrentDatabase();
      return await db.execute(createSql) ;
    }
  }

  @mustCallSuper
  open() async {
    if(!isTableExits){

      await prepare(tableName(), tableSqlString()) ;

    }
    return await SqlManager.getCurrentDatabase() ;

  }

}