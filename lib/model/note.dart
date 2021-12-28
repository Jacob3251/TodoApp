
final String tableNotes = 'notes';
class NoteFields{
  static final List<String> values = [
    //adding all fields
    id, isImportant,number, title, description,time
  ];
  //class for making the db column names and its types
  static final String id = '_id';//this is the primary key in the table which will have '_' in the first
  static final String isImportant = 'isImportant';
  static final String number = 'number';
  static final String title = 'title';
  static final String description = 'description';
  static final String time = 'time';
}

class Note{
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;
  //this class stores the data which we would store in the database
  const Note({
    //primary key cannot be required
    this.id,
    required this.isImportant,
    required this.number,
    required this.title,
    required this.description,
    required this.createdTime
    });
  Note copy({
    int ? id,
    bool ? isImportant,
    int ? number,
    String ? title,
    String ? description,
    DateTime ? createdTime,
  })=>
    Note(
      id: id?? this.id,
      isImportant: isImportant?? this.isImportant,
      number: number?? this.number,
      title: title??this.title,
      description: description?? this.description,
      createdTime: createdTime?? this.createdTime,
    );
  //converting json object to note object
  static Note fromJson(Map<String,Object>json) => Note(
    id: json[NoteFields.id] as int?,
    number: json[NoteFields.number] as int,
    title: json[NoteFields.title] as String,
    description: json[NoteFields.description] as String,
    createdTime: DateTime.parse(json[NoteFields.time] as String),
    isImportant: json[NoteFields.isImportant] == 1,//if true then 1 else 0
  );
  //converting the data into map for adding to the database
  Map<String, Object?> toJson() => {
    NoteFields.id: id,
    NoteFields.title: title,
    NoteFields.isImportant: isImportant ? 1 : 0,
    NoteFields.number: number,
    NoteFields.time: createdTime.toIso8601String(),
    NoteFields.description: description,
  };
}