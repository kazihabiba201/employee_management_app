import 'dart:convert';
import 'dart:io';

import 'package:employee_management_app/Presentation/ui/screens/create_employee.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/emplyee_record_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

const url = 'http://10.0.2.2:8000';
const baseUrl = url;

class _HomeScreenState extends State<HomeScreen> {
  List<EmployeeRecord> employeeRecord = [];

  Future<List<EmployeeRecord>> getRecord() async {
    const maxRetries = 3;
    int retryCount = 0;

    while (retryCount < maxRetries) {
      try {
        final response = await http.get(Uri.parse(baseUrl),
            headers: {'Content-Type': 'application/json'});

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body.toString());
          for (Map<String, dynamic> index in data) {
            employeeRecord.add(EmployeeRecord.fromJson(index));
          }
          return employeeRecord;
        } else {
          print("Error: ${response.statusCode} - ${response.reasonPhrase}");
          return employeeRecord;
        }
      } on SocketException catch (se) {
        print("SocketException: $se");
        retryCount++;
        print("Retrying... (Attempt $retryCount)");
      } on Exception catch (e) {
        print("Error fetching data: $e");
        return [];
      }
    }

    print("Max retries reached. Unable to fetch data.");
    return [];
  }

  @override
  void initState() {
    super.initState();
    // getRecord().then((value) {
    //   print("Data fetched successfully: $value");
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Management"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Employee List',
                  style: TextStyle(fontSize: 20),
                ),
                InkWell(
                  onTap: () {
                    // Add your functionality here
                    print('Custom button pressed');
                  },
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        // Add your functionality here
                        print('TextButton pressed');
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.blue, // Set text color
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const CreateEmployeeScreen()));
                            },
                            child: const Row(
                              children: [
                                Text('Add Employee'),
                                Icon(Icons.arrow_forward_ios_sharp),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder(
                  future: getRecord(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List<EmployeeRecord> employeeRecords = snapshot.data;
                      return ListView.separated(
                        itemCount: employeeRecords.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text('Name: ${employeeRecord[index].name}'),
                            subtitle: Text(
                                'Department:${employeeRecord[index].department}\nTenure:${employeeRecord[index].tenure} years \nSkills:${employeeRecord[index].skills}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    // Handle edit button press
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    // Handle delete button press
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(); // Divider between list items
                        },
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
