
import 'package:flutter/material.dart';
import 'package:flutter_students_detailss/database_helper.dart';
import 'package:flutter_students_detailss/students_details.dart';

import 'main.dart';

class StudentForm extends StatefulWidget {
  const StudentForm({super.key});

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  var _studentNameController = TextEditingController();
  var _studentMobileNoController = TextEditingController();
  var _studentEmailIDController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Students Form'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              TextFormField(
                controller: _studentNameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    labelText: 'Student Name',
                    hintText: 'Enter Student Name'
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _studentMobileNoController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    labelText: 'Student Mobile No',
                    hintText: 'Enter Student Mobile No'
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _studentEmailIDController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    labelText: 'Student Email ID',
                    hintText: 'Enter Student Email ID'
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  print('--------------> Save Button Clicked');
                  _save();
                },
                child: Text('Save'),
              )
            ],
          ),
        ),
      ),

    );
  }

  void _save() async {
    print('--------------> _save');
    print('--------------> Student Name: ${_studentNameController.text}');
    print('--------------> Mobile No: ${_studentMobileNoController.text}');
    print('--------------> Email ID: ${_studentEmailIDController.text}');

    Map<String, dynamic> row = {
      DatabaseHelper.colStudentName: _studentNameController.text,
      DatabaseHelper.colMobileNo: _studentMobileNoController.text,
      DatabaseHelper.colEmailID: _studentEmailIDController.text,
    };

    final result = await dbHelper.insertStudentDetails(row, DatabaseHelper.studentDetailsTable);

    debugPrint('--------> Inserted Row Id: $result');

    if (result > 0) {
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'Saved');
    }

    setState(() {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => StudentsDetails()));
    });
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(message)));
  }
}
