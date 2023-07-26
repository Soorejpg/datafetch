import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'MyDBManager.dart';
class DataDisplayWidget extends StatefulWidget {
  @override
  _DataDisplayWidgetState createState() => _DataDisplayWidgetState();
}

class _DataDisplayWidgetState extends State<DataDisplayWidget> {
  List<Map<String, dynamic>> data = [];
  final DBStudentManager dbStudentManager = DBStudentManager();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _conformpasswordController = TextEditingController();

  Student? student;
  late int updateindex;
  late List<Student> studlist;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    List<Map<String, dynamic>> result = await fetchDataFromDatabase();
    setState(() {
      data = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Display'),
      ),
      body: FutureBuilder(
        future: dbStudentManager.getStudentList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            studlist = snapshot.data as List<Student>;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: studlist == null ? 0 : studlist.length,
              itemBuilder: (BuildContext context, int index) {
                Student st = studlist[index];
                return Card(
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: 85,
                          child: Column(
                            children: <Widget>[
                              Text('ID: ${st.id}'),
                              Text('Name: ${st.name}'),
                              Text('email: ${st.email}'),
                              Text('password: ${st.password}'),
                              Text('Conformpassword: ${st.conformpassword}'),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _nameController.text = st.name;
                          _emailController.text = st.email;
                          _passwordController.text = st.password;
                          _conformpasswordController.text = st.conformpassword;
                          student = st;
                          updateindex = index;
                          showAlertDialog(context);
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          dbStudentManager.deleteStudent(st.id );
                          setState(() {
                            studlist.removeAt(index);
                          });
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return CircularProgressIndicator();
        },
      )
    );
  }
  fetchDataFromDatabase() async {

    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'student.db');


    Database database = await openDatabase(path, version: 1);


    List<Map<String, dynamic>> result = await database.query('student1');


    await database.close();

    return result;
  }


showAlertDialog(BuildContext context) {

  var abc =TextEditingController();
  var ace =TextEditingController();
  var afg =TextEditingController();
  var ahi =TextEditingController();

  Widget okButton = ElevatedButton(
    child: Text("OK"),
    onPressed: () {
      Student(
           name: abc.text , email: ace.text,password: afg.text,conformpassword: ahi.text,);
      student?.name = abc.text;
      student?.email = ace.text;
      student?.password = afg.text;
      student?.conformpassword = ahi.text;

      dbStudentManager.updateStudent(student!).then((value) {
        setState(() {

          studlist[updateindex].name = abc.text;
          studlist[updateindex].email = ace.text;
          studlist[updateindex].password = afg.text;
          studlist[updateindex].conformpassword = ahi.text;
        });
      });
      Navigator.pop(context);
    },
  );


  AlertDialog alert = AlertDialog(
    title: Text("Simple Alert"),
    content: Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.person,
              ),
              border: OutlineInputBorder(),
              label: Text("your name"),
              hintText: "Name"),
          controller: abc,
          validator: (val) =>
          val!.isNotEmpty ? null : "Name Should not be Empty",
        ),
        TextFormField(
          decoration: InputDecoration(labelText: "email"),
          controller: ace,
          validator: (val) =>
          val!.isNotEmpty ? null : "email Should not be Empty",
        ),
        TextFormField(
          decoration: InputDecoration(labelText: "password"),
          controller: afg,
          validator: (val) =>
          val!.isNotEmpty ? null : "password Should not be Empty",
        ),
        TextFormField(
          decoration: InputDecoration(labelText: "conform password"),
          controller: ahi,
          validator: (val) =>
          val!.isNotEmpty ? null : " conform password Should not be Empty",
        ),

      ],
    ),
    actions: [
      okButton,

    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
  }