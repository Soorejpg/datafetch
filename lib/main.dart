
import 'package:flutter/material.dart';
import 'MyDBManager.dart';
import 'newpage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final DBStudentManager dbStudentManager = DBStudentManager();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _conformpasswordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  Student? student;
  late int updateindex;
  late List<Student> studlist;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Sqflite Example"),
      ),
      body: ListView(
        children: <Widget>[
          Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                          ),
                          border: OutlineInputBorder(),
                          label: Text("your name"),
                          hintText: "Name"),
                      controller: _nameController,
                      validator: (val) =>
                      val!.isNotEmpty ? null : "Name Should not be Empty",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                          ),
                          border: OutlineInputBorder(),
                          label: Text("Email"),
                          hintText: "Email"),
                      controller: _emailController,
                      validator: (val) =>
                      val!.isNotEmpty ? null : "Course Should not be Empty",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                          ),
                          border: OutlineInputBorder(),
                          label: Text("Password"),
                          hintText: "Password"),
                      controller: _passwordController,
                      validator: (val) =>
                      val!.isNotEmpty ? null : "Course Should not be Empty",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                          ),
                          border: OutlineInputBorder(),
                          label: Text("Confirm Password"),
                          hintText: "Confirm Password"),
                      controller: _conformpasswordController,
                      validator: (val) =>
                      val!.isNotEmpty ? null : "Course Should not be Empty",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(

                      child: Container(
                          width: width * 0.9,
                          child: Text("Submit",
                            textAlign: TextAlign.center,
                          )),
                      onPressed: () {
                        submitStudent(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  DataDisplayWidget()),
                        );
                      },
                    ),
                  ),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void submitStudent(BuildContext context) {
    if (_formkey.currentState!.validate()) {
      if (student == null) {
        Student st =  Student(
            name: _nameController.text, email: _emailController.text,password: _passwordController.text,conformpassword: _conformpasswordController.text);
        dbStudentManager.insertStudent(st).then((value) => {
          _nameController.clear(),
          _emailController.clear(),
          _passwordController.clear(),
          _conformpasswordController.clear(),
          print("Student Data Add to database $value"),
        });
      }
      else {
        student?.name = _nameController.text;
        student?.email = _emailController.text;
        student?.password = _passwordController.text;
        student?.email = _conformpasswordController.text;

        dbStudentManager.updateStudent(student!).then((value) {
          setState(() {
            studlist[updateindex].name = _nameController.text;
            studlist[updateindex].email = _emailController.text;
            studlist[updateindex].password = _passwordController.text;
            studlist[updateindex].email = _conformpasswordController.text;
          });
          _nameController.clear();
          _emailController.clear();
          _passwordController.clear();
          _conformpasswordController.clear();
          student=null;
        });
      }
    }
  }
}