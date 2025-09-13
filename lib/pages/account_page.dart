import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'common_widgets/custom_nav_bar.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int _selectedIndex = 3;
  bool isEditable = false;
  bool showOtpField = false;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  String userName = "Loading...";
  String mobileNumber = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phone = prefs.getString('user_phone') ?? "";

    final response = await http.get(
      Uri.parse("http://10.0.2.2:8000/auth/user/$phone"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        userName = data['name'];
        mobileNumber = data['phone'];
        nameController.text = userName;
        phoneController.text = mobileNumber;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load user data')),
      );
    }
  }

  Future<void> _updateUser() async {
    final response = await http.post(
      Uri.parse("http://10.0.2.2:8000/auth/update_user"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': nameController.text,
        'phone': phoneController.text,
        'password': otpController.text, // OTP used as password verification
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['message'] == "User updated successfully") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_name', nameController.text);
        await prefs.setString('user_phone', phoneController.text);

        setState(() {
          userName = nameController.text;
          mobileNumber = phoneController.text;
          isEditable = false;
          showOtpField = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid OTP')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating user')),
      );
    }
  }

  void _onUpdatePressed() {
    setState(() {
      if (!isEditable) {
        isEditable = true;
        showOtpField = true;
      } else if (showOtpField) {
        _updateUser();
      }
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    phoneController.dispose();
    nameController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.person, size: 70, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 60),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    enabled: isEditable,
                  ),
                  SizedBox(height: 40),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'Mobile number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    enabled: isEditable,
                    keyboardType: TextInputType.number,
                  ),
                  if (showOtpField) ...[
                    SizedBox(height: 40),
                    TextField(
                      controller: otpController,
                      decoration: InputDecoration(
                        labelText: 'Enter OTP',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                  SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: _onUpdatePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    child: Text(showOtpField ? 'Verify OTP' : 'Update Profile'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _logout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomNavBar(
              selectedIndex: _selectedIndex,
              onTap: (index) {
                if (index != _selectedIndex) {
                  Navigator.pushReplacementNamed(context, ['/home', '/chart', '/weather', '/account'][index]);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
