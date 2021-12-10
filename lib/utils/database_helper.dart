import 'package:sqflite/sqflite.dart';
import  'dart:async';
import 'dart:io'; // deals with file and folder
import 'package:path_provider/path_provider.dart';

class DatabaseHelper
{
 static late  DatabaseHelper _databaseHelper;// singelton DatabaseHelper
 static late Database _database; // Singelton Database
 DatabaseHelper._createInstance();

 String noteTable = 'note_table';
 String colId = 'id';
 String colTitle = 'title';
 String colDescription = 'description';
 String colPriority = 'priority';
 String colDate = 'date';




 factory DatabaseHelper()
 {

    if(_databaseHelper == null)
    {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    
   return _databaseHelper;
 }

 Future<Database> get database async
 {
   if(_database == null)
     _database = await initializeDatabase();
   return _database;
 }

 Future<Database>initializeDatabase() async
 {
   //get the directory path for android and ios;
   Directory directory = await getApplicationDocumentsDirectory(); // path provider package
   String path = directory.path + 'notes.db';

   // create the database at a given path

  var noteDatabase =  await openDatabase( path, version: 1, onCreate: _createDb);
  return noteDatabase;

 }
 
 void _createDb (Database db, int newVersion) async
 {
    await db.execute('CREATE TABLE $noteTable($colId INTEGER PRIMARY AUTOINCREMENT, $colTitle Text,'  '$colDescription TEXT,  $colPriority INTEGER $colDate TEXT)');
 }


}