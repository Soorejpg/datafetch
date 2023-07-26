import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class DBStudentManager {
  late Database _datebase;

  Future openDB() async {
    _datebase = await openDatabase(
        join(await getDatabasesPath(), "student.db"),
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE student1(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,email TEXT,password TEXT,conformpassword TEXT)");
        }
    );
  }



  Future<int> insertStudent(Student student) async {
    await openDB();
    return await _datebase.insert('student1', student.toMap());

  }




  Future<List<Student>> getStudentList() async {
    await openDB();
    final List<Map<String, dynamic>> maps = await _datebase.query('student1');
    return List.generate(maps.length, (index) {
      return Student( id:maps[index]['id'],name: maps[index]['name'], email: maps[index]['email'],password: maps[index]['password'],conformpassword:maps[index]['conformpassword']);
    });
  }


  Future<int> updateStudent(Student s) async {
    await openDB();
    return await _datebase.update('student1', s.toMap(), where: 'id=?', whereArgs: [s.id]);
  }

  Future<void> deleteStudent(int? id) async {
    await openDB();
    await _datebase.delete("student1", where: "id = ? ", whereArgs: [id]);
  }
}

class Student {
   int ? id;
  String name;
  String email;
  String password;
  String conformpassword;
  Student({  this.id,required this.name, required this.email,required this.password,required this.conformpassword});
  Map<String, dynamic> toMap() {
    return {'id':id,'name': name, 'email': email,'password':password,'conformpassword':conformpassword};
  }
}