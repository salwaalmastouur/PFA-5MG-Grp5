import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'demande_model.dart';
import 'demande_service.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final DemandeService _demandeService = DemandeService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<List<Demande>>(
        stream: _demandeService.getAllDemandesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          var demandes = snapshot.data ?? [];
          if (demandes.isEmpty) {
            return Center(child: Text('No demands to review'));
          }
          return ListView.builder(
            itemCount: demandes.length,
            itemBuilder: (context, index) {
              var demande = demandes[index];
              return Card(
                child: ListTile(
                  title: Text(demande.destination),
                  subtitle: Text(
                      'From: ${demande.depart} - To: ${demande.destination}\n'
                      'Date: ${demande.dateDepart} to ${demande.dateRetour}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () {
                          _demandeService.validerDemande(demande.id).then((_) {
                            setState(() {});
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          _demandeService.refuserDemande(demande.id).then((_) {
                            setState(() {});
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
  }
}
