import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'demande_model.dart';
import 'demande_service.dart';
import 'create_demand_screen.dart'; // Replace with the correct path

class Employee extends StatefulWidget {
  const Employee({Key? key}) : super(key: key);

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  final DemandeService _demandeService = DemandeService();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 0 ? CreateDemandScreen() : DemandesAccepteesEmployeePage(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Create Demand",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "View Accepted Demands",
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}

class DemandesAccepteesEmployeePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Accepted Demands"),
      ),
      body: Center(
        child: Text("Content for accepted demands page goes here."),
      ),
    );
  }
}
