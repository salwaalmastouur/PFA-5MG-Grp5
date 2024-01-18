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
stream: _demandeService.getDemandesEnAttente(),
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
                  title: Text('Demand'),
                  subtitle: Text('Departure: ${demande.depart} - Destination: ${demande.destination}\nDate: ${demande.dateDepart} to ${demande.dateRetour}'),
                  onTap: () => showDemandDetails(context, demande),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.check, color: Colors.green),
                        onPressed: () => _demandeService.validerDemande(demande.id),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.red),
                        onPressed: () => _demandeService.refuserDemande(demande.id),
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
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
  }

  void showDemandDetails(BuildContext context, Demande demande) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Demand Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Name: ${demande.name}'),
                Text('Departure: ${demande.depart}'),
                Text('Destination: ${demande.destination}'),
                Text('Departure Date: ${demande.dateDepart}'),
                Text('Return Date: ${demande.dateRetour}'),
                Text('Accommodation Cost: ${demande.accommodationCost}'),
                Text('Food Cost: ${demande.foodCost}'),
                Text('Transport Cost: ${demande.transportCost}'),
                Text('Miscellaneous Cost: ${demande.miscellaneousCost}'),
                Text('Total Cost: ${demande.totalCost}'),
                // Add more details as needed
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
