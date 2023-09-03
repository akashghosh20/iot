import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  foregroundImage: AssetImage('assets/images/profilepic.png'),
                  backgroundColor: Colors.teal.withOpacity(0.2),
                ),
                SizedBox(
                  height: 4,
                ),
                GestureDetector(
                  onTap: () {
                    _showNameEditDialog();
                  },
                  child: Text(
                    _nameController.text,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 28),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Tile(
                  name: 'Privacy',
                  icon: Icon(Icons.privacy_tip_outlined),
                ),
                Tile(
                  name: 'Policy',
                  icon: Icon(Icons.policy),
                ),
                Tile(
                  name: 'Settings',
                  icon: Icon(Icons.settings),
                ),
                Tile(
                  name: 'Security',
                  icon: Icon(Icons.security),
                ),
                Tile(
                  name: 'Logout',
                  icon: Icon(Icons.logout),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}

class Tile extends StatelessWidget {
  final String name;
  final Icon icon;
  Tile({required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: icon,
        title: Text(name),
        tileColor: Color.fromARGB(255, 45, 200, 247).withOpacity(.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
