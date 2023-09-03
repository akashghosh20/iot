import 'package:flutter/material.dart';
import 'package:project_neal/constant.dart';
import 'package:project_neal/widgets/extra/add.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopHeader extends StatefulWidget {
  const TopHeader({super.key});

  @override
  State<TopHeader> createState() => _TopHeaderState();
}

class _TopHeaderState extends State<TopHeader> {
  TextEditingController _nameController = TextEditingController();
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  // Load the name from SharedPreferences
  Future<void> _loadName() async {
    _prefs = await SharedPreferences.getInstance();
    String name = _prefs.getString('name') ?? 'User';
    setState(() {
      _nameController.text = name;
    });
  }

  // Save the name to SharedPreferences
  Future<void> _saveName(String name) async {
    await _prefs.setString('name', name);
  }

  void _showNameEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Name'),
          content: TextField(
            controller: _nameController,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  String newName = _nameController.text;
                  _saveName(newName); // Save the updated name
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32.0, // Adjust the radius as needed
                backgroundColor:
                    Colors.white, // Background color of the CircleAvatar
                foregroundImage: AssetImage('assets/images/profilepic.png'),
              ),
              SizedBox(
                width: 6,
              ),
              // ----------------- LiRan Mollick Text ------------------
              Column(
                children: [
                  Text(
                    'Welcome Home,',
                    style: TextStyle(
                        color: kFontLightGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showNameEditDialog();
                    },
                    child: Text(
                      _nameController.text,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.notifications,
                  color: kButtonDarkBlue,
                  size: 32,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Add()));
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: kButtonDarkBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
