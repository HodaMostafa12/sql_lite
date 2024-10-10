import 'package:flutter/material.dart';
import 'package:sql_lite/repo/database.dart';
import 'package:sql_lite/util/TextController.dart';
import 'package:sql_lite/util/TextField.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //refrance database helper
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  //list to hold user data
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshUsers();
  }

  void _refreshUsers() async {
    final data = await _databaseHelper.getUsers();
    setState(() {
      _users = data ?? [];
    });
  }

  void _addUser() async {
    String exitname = name.text;
    int exitage = int.parse(age.text);
    await _databaseHelper.insertUser(exitname, exitage);
    name.clear();
    age.clear();
    _refreshUsers();
  }

  void _deleteUser(int id) async {
    await _databaseHelper.deleteUser(id);
    _refreshUsers();
  }

  Future<void> _updateUserDialog(
      int id, String currentName, int currentAge) async {
    // Set the current values in the text fields
    name.text = currentName;
    age.text = currentAge.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit your Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Textfield(controller: name, hintText: 'Update Name',keyboardType: TextInputType.text,),
              const SizedBox(height: 10),
              Textfield(controller: age, hintText: 'Update Age',keyboardType: TextInputType.number,),
              const SizedBox(height: 10),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () async {
                      if (name.text.isEmpty || age.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Row(
                            children: [
                              Text('Please fill all fields'),
                              Icon(Icons.error_outline, color: Colors.red),
                            ],
                          ),
                        ));
                      } else {
                        // Call updateUser to update the existing user
                        await _databaseHelper.updateUser(
                            id, name.text, int.parse(age.text));
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Row(
                            children: [
                              Text('Successfully Updated'),
                              Icon(Icons.check, color: Colors.green),
                            ],
                          ),
                        ));
                        _refreshUsers(); // Refresh the list after update
                      }
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SQFlite Demo'),
        elevation: 6,
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 16.0),
            child: ListView.builder(
                itemCount: _users.isEmpty ? 1 : _users.length,
                itemBuilder: (context, index) {
                  if (_users.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 160),
                      child: Column(
                        //mainAxisSize: MainAxisSize.min,

                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.no_accounts,
                            size: 70,
                            color: Colors.grey,
                          ),
                          const Text(
                            'No users added',
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          )
                        ],
                      ),
                    );
                  }
                  return Card(
                    elevation: 4,
                    child: ListTile(
                      title: Text(_users[index]['name']),
                      subtitle: Text('Age: ${_users[index]['age']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                _updateUserDialog(
                                    _users[index]['id'],
                                    _users[index]['name'],
                                    _users[index]['age']);
                              },
                              icon: Icon(Icons.edit)),
                          IconButton(
                              onPressed: () {
                                _deleteUser(_users[index]['id']);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        content: Row(
                                  children: [
                                    Text('Successfuly Deleted'),
                                    Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    )
                                  ],
                                )));
                              },
                              icon: Icon(Icons.delete)),
                        ],
                      ),
                    ),
                  );
                })),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Add your Data'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Textfield(controller: name, hintText: 'Add name',keyboardType: TextInputType.text,),
                      const SizedBox(
                        height: 10,
                      ),
                      Textfield(controller: age, hintText: 'Add your age',keyboardType: TextInputType.number,),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.red),
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          TextButton(
                              onPressed: () {
                                if (name.text.isEmpty || age.text.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Row(
                                    children: [
                                      Text('Please fill all fields'),
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                      )
                                    ],
                                  )));
                                } else {
                                  _addUser();
                                  name.clear();
                                  age.clear();
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content: Row(
                                    children: [
                                      Text('Successfuly Added'),
                                      Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      )
                                    ],
                                  )));
                                }
                              },
                              child: const Text(
                                'Add',
                                style: TextStyle(color: Colors.green),
                              )),
                        ],
                      )
                    ],
                  ),
                );
              });
        },
        child: const Text('add'),
      ),
    );
  }
}
