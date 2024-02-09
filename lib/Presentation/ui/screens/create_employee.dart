import 'dart:convert';

import 'package:employee_management_app/data/models/emplyee_record_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateEmployeeScreen extends StatefulWidget {
  const CreateEmployeeScreen({super.key});

  @override
  State<CreateEmployeeScreen> createState() => _CreateEmployeeScreenState();
}



class _CreateEmployeeScreenState extends State<CreateEmployeeScreen> {
  List<EmployeeRecord> employeeRecord = [];

  final TextEditingController nameTEController = TextEditingController();
  final TextEditingController departmentTEController = TextEditingController();
  final TextEditingController tunureTEController = TextEditingController();
  final TextEditingController skillsTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<EmployeeRecord> postRecord(String name, String department,
      int tenure, List<String> skills, BuildContext context) async {
    try {
      var url = 'http://10.0.2.2:8000';
      var baseUrl = Uri.parse(url); // Use Uri.parse to create a Uri object
      var response = await http.post(
        baseUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": name,
          "department": department,
          "tenure": tenure,
          "skills": skills,
        }),
      );

      if (response.statusCode == 201) {
        var data = jsonDecode(response.body) as Map<String, dynamic>;
        return EmployeeRecord.fromJson(data);
      } else {
        print("Error: ${response.statusCode} - ${response.reasonPhrase}");
        throw Exception("Failed to post record");
      }
    } catch (e) {
      print("Exception: $e");
      throw Exception("Failed to post record");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Employee'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text('Name'),
                TextFormField(
                    controller: nameTEController,
                    decoration: const InputDecoration(),
                    validator: (String? text) {
                      if (text?.isEmpty ?? true) {
                        return 'Enter Your Full name';
                      }
                      return null;
                    }),
                const SizedBox(
                  height: 15,
                ),
                const Text('Department'),
                TextFormField(
                    controller: departmentTEController,
                    decoration: const InputDecoration(),
                    validator: (String? text) {
                      if (text?.isEmpty ?? true) {
                        return 'Enter Your Full name';
                      }
                      return null;
                    }),
                const SizedBox(
                  height: 15,
                ),
                const Text('Tenure'),
                TextFormField(
                    controller: tunureTEController,
                    decoration: const InputDecoration(),
                    validator: (String? text) {
                      if (text?.isEmpty ?? true) {
                        return 'Enter Your Full name';
                      }
                      return null;
                    }),
                const SizedBox(
                  height: 15,
                ),
                const Text('Skills (comma-separated)'),
                TextFormField(
                    controller: skillsTEController,
                    decoration: const InputDecoration(),
                    validator: (String? text) {
                      if (text?.isEmpty ?? true) {
                        return 'Enter Your Full name';
                      }
                      return null;
                    }),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () async {
                      String name = nameTEController.text;
                      String department = departmentTEController.text;
                      int tenure = int.parse(tunureTEController.text);
                      List<String> skills = skillsTEController.text.split(',');

                      await postRecord(
                          name, department, tenure, skills, context);

                      // Clear text controllers and update UI if necessary
                      nameTEController.text = '';
                      departmentTEController.text = '';
                      tunureTEController.text = '';
                      skillsTEController.text = '';
                      setState(() {
                        employeeRecord = employeeRecord;
                      });
                    },
                    child: const Text('Save')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
