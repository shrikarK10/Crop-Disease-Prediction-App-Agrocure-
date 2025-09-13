import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isOtpFieldVisible = false; // Controls OTP (password) field visibility

  Future<void> registerUser() async {
    final response = await http.post(
      Uri.parse("http://10.0.2.2:8000/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": _nameController.text,
        "phone": _phoneController.text,
        "password": _passwordController.text // OTP is saved as password
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration successful! Please log in."))
      );
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, '/login'); // Navigate to login page
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["error"] ?? "Registration failed"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text("Register", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Image.asset('assets/farmer.png', height: 200),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: "Name"),
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Name is required";
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(labelText: "Mobile Number"),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Mobile number is required";
                        if (!RegExp(r'^\d{10}$').hasMatch(value)) return "Enter a valid 10-digit mobile number";
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    if (isOtpFieldVisible)
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(labelText: "Enter OTP (Saved as Password)"),
                        obscureText: true,
                        validator: (value) {
                          if (isOtpFieldVisible && (value == null || value.isEmpty)) return "OTP is required";
                          return null;
                        },
                      ),
                    SizedBox(height: 10),
                    if (!isOtpFieldVisible)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            isOtpFieldVisible = true; // Show password field, hide this button
                          });
                        },
                        child: Text("Send OTP"),
                      ),
                    if (isOtpFieldVisible) SizedBox(height: 10),
                    if (isOtpFieldVisible)
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            registerUser();
                          }
                        },
                        child: Text("Register"),
                      ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      child: Text("Already have an account? Login"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
