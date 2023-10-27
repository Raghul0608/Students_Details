
import 'package:flutter/material.dart';
import 'package:flutter_students_detailss/database_helper.dart';
import 'package:flutter_students_detailss/student_details_model.dart';
import 'package:flutter_students_detailss/students_details.dart';

import 'main.dart';

class OptimizeStudentForm extends StatefulWidget {
  const OptimizeStudentForm({super.key});

  @override
  State<OptimizeStudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<OptimizeStudentForm> {
  var _studentNameController = TextEditingController();
  var _studentMobileNoController = TextEditingController();
  var _studentEmailIDController = TextEditingController();

  bool firstTimeFlag = false;
  int _selectedId = 0;

  String buttonText ='Save';

  @override
  Widget build(BuildContext context) {
    if (firstTimeFlag == false) {
      print('----------once execute');

      firstTimeFlag = true;

      final studentDetail = ModalRoute
          .of(context)!
          .settings
          .arguments;
      if (studentDetail == null) {
        print('-------->FAB:Insert/Save:');
      } else {
        print('-------->ListView:Review Data:Edit/Delete');

        studentDetail as StudentDetailsModel;

        print('----------->Received Data');
        print(studentDetail.id);
        print(studentDetail.stundentName);
        print(studentDetail.stundetMobileNo);
        print(studentDetail.studentMailId);

        _selectedId = studentDetail.id!;

        _studentNameController.text = studentDetail.stundentName;
        _studentMobileNoController.text = studentDetail.stundetMobileNo;
        _studentEmailIDController.text = studentDetail.studentMailId;
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Students Form'),
        actions:_selectedId !=0
          ?[
          PopupMenuButton<int>(
              itemBuilder: (context)=> [
                PopupMenuItem(value:1, child: Text("Delete")),
              ],
            elevation: 2,
            onSelected: (value){
                if (value == 1) {
                  print('Delete option clicked');
                  _deleteFromDialog(context);
                }
            }
          )
        ]:null
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
                  print('--------------> Update Button Clicked');
                  if (_selectedId ==0){
                    print('----->Save');
                    _save();
                  } else {
                    print('-------->Update');
                    _Update();
                  }
                },
                child: Text(buttonText),
              )
            ],
          ),
        ),
      ),

    );
  }
  _deleteFromDialog(BuildContext Context){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (param){
          return AlertDialog(
           actions:<Widget>[
            ElevatedButton(
                onPressed: () {
                  print('------>Cancel Button Clicked');
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
            ),
             ElevatedButton(
                 onPressed: () async{
                   print('-------->Delete Button Clicked');
                   _delete();
                 },
                 child: const Text('Delete'),
             )
             ],
            title: const Text('Are you sure want to delete this?'),
          );
    });
  }
  void _save() async{
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
  void _Update() async {
    print('--------------> _Update');
    print('--------------> Student Name: ${_studentNameController.text}');
    print('--------------> Mobile No: ${_studentMobileNoController.text}');
    print('--------------> Email ID: ${_studentEmailIDController.text}');

    Map<String, dynamic> row = {

      DatabaseHelper.colId: _selectedId,

      DatabaseHelper.colStudentName: _studentNameController.text,
      DatabaseHelper.colMobileNo: _studentMobileNoController.text,
      DatabaseHelper.colEmailID: _studentEmailIDController.text,
    };

    final result = await dbHelper.updateStudentDetails(
        row, DatabaseHelper.studentDetailsTable);

    debugPrint('--------> Updated Row Id: $result');

    if (result > 0) {
      Navigator.pop(context);
      _showSuccessSnackBar(context, 'Updated');
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
  void _delete() async{
    print('--------------> _delete');

    final result = await dbHelper.deleteStudentDetails(_selectedId, DatabaseHelper.studentDetailsTable);

    debugPrint('-----------------> Deleted Row Id: $result');

    if (result > 0) {
      _showSuccessSnackBar(context, 'Deleted.');
      Navigator.pop(context);
    }

    setState(() {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => StudentsDetails()));
    });
  }
  }
