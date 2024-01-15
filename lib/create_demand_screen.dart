import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pfamobile/demande_model.dart';
import 'package:pfamobile/demande_service.dart';

class CreateDemandScreen extends StatefulWidget {
  @override
  _CreateDemandScreenState createState() => _CreateDemandScreenState();
}

class _CreateDemandScreenState extends State<CreateDemandScreen> {
  final _formKey = GlobalKey<FormState>();
  final DemandeService _demandeService = DemandeService();
  TextEditingController _purposeController = TextEditingController();
  TextEditingController _departureController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();
  TextEditingController _costController = TextEditingController();
  TextEditingController _detailsController = TextEditingController();
  DateTime? _departureDate;
  DateTime? _returnDate;

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
                controller: _purposeController,
                decoration: InputDecoration(labelText: 'Purpose of Travel'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the purpose of travel';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _departureController,
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
                controller: _costController,
                decoration: InputDecoration(labelText: 'Estimated Cost'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the estimated cost';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _detailsController,
                decoration: InputDecoration(labelText: 'Additional Details'),
                maxLines: 3,
              ),
              ListTile(
                title: Text('Select Departure Date'),
                subtitle: Text(
                  _departureDate == null
                      ? 'No date chosen'
                      : DateFormat('yyyy-MM-dd').format(_departureDate!),
                ),
                onTap: () => _selectDate(context, true),
              ),
              ListTile(
                title: Text('Select Return Date'),
                subtitle: Text(
                  _returnDate == null
                      ? 'No date chosen'
                      : DateFormat('yyyy-MM-dd').format(_returnDate!),
                ),
                onTap: () => _selectDate(context, false),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
// Create and process the demand
                    Demande newDemande = Demande(
                      id: '', // ID will be set automatically by Firestore
                      etudiantId: FirebaseAuth.instance.currentUser!.uid,
                      dateDemande: DateTime.now().toString(),
                      depart: _departureController.text,
                      destination: _destinationController.text,
                      dateDepart: _departureDate?.toString() ?? '',
                      dateRetour: _returnDate?.toString() ?? '',
                      status: 'En attente',
                      teacherId: '', // This can be set as per your logic
                    );
                    _demandeService.ajouterDemande(newDemande);
// Clear the form
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

  void _selectDate(BuildContext context, bool isDepartureDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isDepartureDate
          ? _departureDate ?? DateTime.now()
          : _returnDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _departureDate && isDepartureDate) {
      setState(() {
        _departureDate = picked;
      });
    } else if (picked != null && picked != _returnDate && !isDepartureDate) {
      setState(() {
        _returnDate = picked;
      });
    }
  }

  void _clearForm() {
    _purposeController.clear();
    _departureController.clear();
    _destinationController.clear();
    _costController.clear();
    _detailsController.clear();
    setState(() {
      _departureDate = null;
      _returnDate = null;
    });
  }
}
