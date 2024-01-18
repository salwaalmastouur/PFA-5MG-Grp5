import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pfamobile/createdemandescreen.dart';
import 'login.dart';
import 'demande_model.dart';
import 'demande_service.dart';

class Employee extends StatefulWidget {
  const Employee({Key? key}) : super(key: key);

  @override
  State<Employee> createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  final DemandeService _demandeService = DemandeService();
  final TextEditingController _demandeController = TextEditingController();
  int _currentIndex = 0; // Variable pour suivre l'onglet actuel sélectionné

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Employee"),
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: _currentIndex == 0 ? CreateDemandScreen() : DemandesAccepteesEmployeePage(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Voir demandes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: "Voir demandes acceptées",
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return CreateDemandScreen();
      case 1:
        // Return the widget for viewing accepted demands or whatever the second tab is for
        return DemandesAccepteesEmployeePage();
      default:
        // Default case if needed
        return Center(child: Text("Select a tab"));
    }
  }

  Widget _buildVoirDemandesTab() {
    return Column(
      children: [
        TextField(
          controller: _demandeController,
          decoration: InputDecoration(labelText: 'Écrire une demande'),
        ),
        ElevatedButton(
          onPressed: () async {
            final nouvelleDemande = Demande(
              id: '',
              etudiantId: FirebaseAuth.instance.currentUser!.uid,
              dateDemande: DateTime.now().toString(),
              depart: 'Paris', // Remplacez par les valeurs appropriées
              destination: 'Londres', // Remplacez par les valeurs appropriées
              dateDepart: '2022-01-01', // Remplacez par les valeurs appropriées
              dateRetour: '2022-01-10', // Remplacez par les valeurs appropriées
              status: 'En attente',
              adminId: '', // L'enseignant peut être ajouté après la demande
              accommodationCost: 0,
              foodCost: 0,
              transportCost: 0,
              miscellaneousCost: 0,
              totalCost: 0,
              name: '',
            );
            await _demandeService.ajouterDemande(nouvelleDemande);
            setState(() {
              _demandeController.clear();
            });
          },
          child: Text('Envoyer la demande'),
        ),
        Expanded(
          child: StreamBuilder<List<Demande>>(
            stream: _demandeService.getDemandesEtudiantStream(
                FirebaseAuth.instance.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: snapshot.data!.map((demande) {
                    return ListTile(
                      title: Text('Date de demande: ${demande.dateDemande}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Départ: ${demande.depart}'),
                          Text('Destination: ${demande.destination}'),
                          Text('Date de départ: ${demande.dateDepart}'),
                          Text('Date de retour: ${demande.dateRetour}'),
                          Text('Statut: ${demande.status}'),
                        ],
                      ),
                    );
                  }).toList(),
                );
              } else if (snapshot.hasError) {
                return Text('Erreur : ${snapshot.error}');
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ],
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}

class DemandesAccepteesEmployeePage extends StatelessWidget {
  final DemandeService _demandeService = DemandeService();

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text("Accepted/Refused Demands"),
      ),
      body: StreamBuilder<List<Demande>>(
stream: _demandeService.getDemandesByEmployeeAndStatus(FirebaseAuth.instance.currentUser!.uid, ['Validée', 'Refusée']),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var demands = snapshot.data!.where((d) => d.status == 'Validée' || d.status == 'Refusée').toList();
            return ListView.builder(
              itemCount: demands.length,
              itemBuilder: (context, index) {
                Demande demande = demands[index];
                return ListTile(
                  title: Text('Departure: ${demande.depart} - Destination: ${demande.destination}'),
                  subtitle: Text('Date: ${demande.dateDepart} to ${demande.dateRetour}'),
                  trailing: Icon(Icons.circle, color: demande.status == 'Validée' ? Colors.green : Colors.red),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
