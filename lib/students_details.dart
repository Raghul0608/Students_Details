
import 'package:flutter/material.dart';
import 'package:flutter_students_detailss/database_helper.dart';
import 'package:flutter_students_detailss/edit_Student_detail_form_screen.dart';
import 'package:flutter_students_detailss/main.dart';
import 'package:flutter_students_detailss/student_details_model.dart';
import 'package:flutter_students_detailss/student_form_details.dart';
import 'package:sqflite/sqflite.dart';



class StudentsDetails extends StatefulWidget {
  const StudentsDetails({super.key});

  @override
  State<StudentsDetails> createState() => _StudentsDetailsState();
}

class _StudentsDetailsState extends State<StudentsDetails> {
  late List<StudentDetailsModel> _studentDetailsList;

  @override
  void initState() {
    super.initState();
    getAllStudentDetails();
  }
  getAllStudentDetails() async{
    _studentDetailsList = <StudentDetailsModel>[];
    var studentsDetailRecords =
    await dbHelper.queryAllRows(DatabaseHelper.studentDetailsTable);

    studentsDetailRecords.forEach((studentDetail){
      setState(() {
        print(studentDetail['_id']);
        print(studentDetail['_studentName']);
        print(studentDetail['_mobileNo']);
        print(studentDetail['_emailId']);

        var studentDetailsModel = StudentDetailsModel(
            studentDetail['_id'],
            studentDetail['_studentName'],
            studentDetail['_mobileNo'],
            studentDetail['_emailId']
        );

        _studentDetailsList.add(studentDetailsModel);

      });
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: ListView.builder(
              itemCount: _studentDetailsList.length,
              itemBuilder: (BuildContext context, int index){
                return InkWell(
                  onTap: (){
                    print(_studentDetailsList[index].id);
                    print(_studentDetailsList[index].stundentName);
                    print(_studentDetailsList[index].stundetMobileNo);
                    print(_studentDetailsList[index].studentMailId);

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context)=> EditStudentForm(),
                      settings: RouteSettings(
                        arguments: _studentDetailsList[index],
                      ),
                    ));
                  },
                  child: ListTile(
                    title: Text(_studentDetailsList[index].stundentName,
                    ),
                  ),
                );
              }
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
         print('------> Launch Students Details Form Screen');
         Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StudentForm()));

        },
        child: Icon(Icons.add),
      ),
    );
  }
}
