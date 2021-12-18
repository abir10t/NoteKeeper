import 'package:note_keeper/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io'; // deals with file and folder
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static  DatabaseHelper ? _databaseHelper; // singelton DatabaseHelper
  static late Database _database; // Singelton Database
  DatabaseHelper._createInstance();

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  factory  DatabaseHelper()
  {
    if (_databaseHelper == null) {_databaseHelper = DatabaseHelper._createInstance();
    }

    return _databaseHelper!;
  }

  Future<Database> get database async
  {
    if (_database == null) _database = await initializeDatabase();
    return _database;
  }

  Future<Database> initializeDatabase() async
  {
    //get the directory path for android and ios;
    Directory directory = await getApplicationDocumentsDirectory(); // path provider package
    String path = directory.path + 'notes.db';

    // create the database at a given path
    var noteDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return noteDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $noteTable($colId INTEGER PRIMARY AUTOINCREMENT, $colTitle Text,''$colDescription TEXT,  $colPriority INTEGER $colDate TEXT)');
  }

  // Fetch Operation : Get all note objects from database

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;

// var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');

    var result = await db.query(noteTable, orderBy: '$colPriority ASC');

    return result;
  }

  // Insert operation

 Future<int> insertNote(Note note) async
 {
   Database db = await this.database;
   var result = await db.insert(noteTable, note.toMap());
   return result;

 }

 // update operation: Update a note object and save it to database

Future<int> updateNote(Note note) async
{
  var db = await this.database;
  var result = await db.update(noteTable, note.toMap(), where: '$colId = ?', whereArgs: [note.id]);
  return  result;
}

// delete operation

Future<int> deleteNote(int id) async
{
 var db = await this.database;
 int result = await db.rawDelete('DELETE FROM $noteTable where $colId = $id');
 return result;
}

// Number of Note Objects in Database

Future<int?> getCount()async{
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $noteTable');
    int? result = Sqflite.firstIntValue(x);
    return result;
}

Future<List<Note>> getNoteList() async
{

var noteMapList = await getNoteMapList();
int count = noteMapList.length;

List<Note> noteList = <Note>[];

for(int i=0; i<count; i++)
{
  noteList.add(Note.fromMapObject(noteMapList[i]));
}

return noteList;
}


}
