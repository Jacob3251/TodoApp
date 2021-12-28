
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/model/note.dart';
//null safety demolished; found error on line 9 => ?, (12,15) => ! at the end not recognized therefore removed

class NotesDatabase{
  static final NotesDatabase instance = NotesDatabase.init();//this instance calls the instructor
  static Database? _database;//initializing new database
  NotesDatabase.init();
  Future<Database> get database async{
    if(_database != null ) return _database!;//if there is database then returns that else creates new database

    _database = await _initDB('notes.db');//creating new database and returning it
    return _database!;
  }
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath,filePath);//providing database file name and path

    return await openDatabase(path, version: 1, onCreate: _createDB);//giving file schema and db file path

  }
  //for creating database table below
  Future _createDB(Database db, int version) async {
    //initializing the types of data types for the data table
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';
    //calling the initialized datatypes for the datatable column and making the database
    await db.execute('''
      CREATE TABLE $tableNotes(
      ${NoteFields.id} $idType,
      ${NoteFields.isImportant} $boolType,
      ${NoteFields.number} $integerType,
      ${NoteFields.title} $textType,
      ${NoteFields.description} $textType,
      ${NoteFields.time} $textType
      )
    ''');

  }
  Future<Note> create(Note note) async {
    final db = await instance.database;
    //here inside insert method **takes two inputs** first one is the table name where the data is inserted
    //second is the data that is going to be inserted into the database and we have to convert it into a map
    final id = await db.insert(tableNotes, note.toJson());
    //this will generate an id provided by the database which we have to pass to note object
    return note.copy(id: id);
  }
  //for reading a note
  Future<Note> readNote(int id)async{
    final db = await instance.database;

    final maps = await db.query(
        tableNotes,
        columns: NoteFields.values,
        where: '${NoteFields.id} = ?',
        whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    final orderBy = '${NoteFields.time} ASC';
    final result = await db.query(tableNotes,orderBy: orderBy);

    return result.map((json) => Note.fromJson(json)).toList();
  }
  Future<int> update(Note note)async {
    final db = await instance.database;

    return db.update(
        tableNotes,
        note.toJson(),
        where: '${NoteFields.id}=?',
        whereArgs: [note.id],
    );
  }
  Future<int>delete(int id) async{
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: '${NoteFields.id}=?',
      whereArgs: [id],
    );
  }
  //for closing the database
  Future close() async {
    final db = await instance.database;
    db.close();

  }
}