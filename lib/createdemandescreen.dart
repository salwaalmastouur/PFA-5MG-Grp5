import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pfamobile/demande_model.dart';
import 'package:pfamobile/demande_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateDemandScreen extends StatefulWidget {
  @override
  _CreateDemandScreenState createState() => _CreateDemandScreenState();
}

class _CreateDemandScreenState extends State<CreateDemandScreen> {
  final _formKey = GlobalKey<FormState>();
  final DemandeService _demandeService = DemandeService();

  TextEditingController _departController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  TextEditingController _accommodationCostController = TextEditingController();
  TextEditingController _foodCostController = TextEditingController();
  TextEditingController _transportCostController = TextEditingController();
  TextEditingController _miscellaneousCostController = TextEditingController();

  DateTime? _dateDepart;
  DateTime? _dateRetour;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Demand')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _departController,
                decoration: InputDecoration(labelText: 'Departure Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the departure location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _destinationController,
                decoration: InputDecoration(labelText: 'Destination'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the destination';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _accommodationCostController,
                decoration: InputDecoration(labelText: 'Accommodation Cost'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the accommodation cost';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _foodCostController,
                decoration: InputDecoration(labelText: 'Food Cost'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the food cost';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _transportCostController,
                decoration: InputDecoration(labelText: 'Transport Cost'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the transport cost';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _miscellaneousCostController,
                decoration: InputDecoration(labelText: 'Miscellaneous Cost'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the miscellaneous cost';
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text('Select Departure Date'),
                subtitle: Text(
                  _dateDepart == null
                      ? 'No date chosen'
                      : DateFormat('yyyy-MM-dd').format(_dateDepart!),
                ),
                onTap: () => _selectDate(context, true),
              ),
              ListTile(
                title: Text('Select Return Date'),
                subtitle: Text(
                  _dateRetour == null
                      ? 'No date chosen'
                      : DateFormat('yyyy-MM-dd').format(_dateRetour!),
                ),
                onTap: () => _selectDate(context, false),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                          String name = await fetchuser();

                    Demande newDemande = Demande(
                      id: '',
                      etudiantId: FirebaseAuth.instance.currentUser!.uid,
                              name: name, // Include the fetched name

                      dateDemande: DateTime.now().toString(),
                      depart: _departController.text,
                      destination: _destinationController.text,
                      dateDepart: _dateDepart != null ? DateFormat('yyyy-MM-dd').format(_dateDepart!) : '',
                      dateRetour: _dateRetour != null ? DateFormat('yyyy-MM-dd').format(_dateRetour!) : '',
                      status: 'En attente',
                      adminId: '',
                      accommodationCost: double.tryParse(_accommodationCostController.text) ?? 0,
                      foodCost: double.tryParse(_foodCostController.text) ?? 0,
                      transportCost: double.tryParse(_transportCostController.text) ?? 0,
                      miscellaneousCost: double.tryParse(_miscellaneousCostController.text) ?? 0,
                      totalCost: calculateTotalCost(),
                    );
                    _demandeService.ajouterDemande(newDemande);
                    _clearForm();
                  }
                },
                child: Text('Submit Demand'),
              ),
            ],
          ),
        ),
      ),
    );
  }
Future<String> fetchuser() async {
  var userDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();
  return userDoc.data()?['name'] ?? 'Unknown';
}
  double calculateTotalCost() {
    double accommodation = double.tryParse(_accommodationCostController.text) ?? 0;
    double food = double.tryParse(_foodCostController.text) ?? 0;
    double transport = double.tryParse(_transportCostController.text) ?? 0;
    double miscellaneous = double.tryParse(_miscellaneousCostController.text) ?? 0;
    return accommodation + food + transport + miscellaneous;
  }

  void _selectDate(BuildContext context, bool isDepartureDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isDepartureDate
          ? _dateDepart ?? DateTime.now()
          : _dateRetour ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
        if (isDepartureDate) {
          _dateDepart = picked;
        } else {
          _dateRetour = picked;
        }
      });
    }
  }

  void _clearForm() {
    _departController.clear();
    _destinationController.clear();
    _accommodationCostController.clear();
    _foodCostController.clear();
    _transportCostController.clear();
    _miscellaneousCostController.clear();
    setState(() {
      _dateDepart = null;
      _dateRetour = null;
    });
  }
}
