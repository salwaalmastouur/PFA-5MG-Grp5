// demande_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Demande {
  final String id;
  final String etudiantId;
  final String dateDemande;
  final String depart;
  final String destination;
  final String dateDepart;
  final String dateRetour;
  final String status;
  final String adminId;
  final double accommodationCost;
  final double foodCost;
  final double transportCost;
  final double miscellaneousCost;
  final double totalCost;
  final String name; // Add this


  Demande({
        required this.name, // Add this

    required this.id,
    required this.etudiantId,
    required this.dateDemande,
    required this.depart,
    required this.destination,
    required this.dateDepart,
    required this.dateRetour,
    required this.status,
    required this.adminId,
    required this.accommodationCost,
    required this.foodCost,
    required this.transportCost,
    required this.miscellaneousCost,
    required this.totalCost,
  });

  factory Demande.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Demande(
      id: doc.id,
      etudiantId: data['etudiantId'],
      dateDemande: data['dateDemande'],
      depart: data['depart'],
      destination: data['destination'],
      dateDepart: data['dateDepart'],
      dateRetour: data['dateRetour'],
      status: data['status'],
      adminId: data['adminId'],
      accommodationCost: data['accommodationCost'],
      foodCost: data['foodCost'],
      transportCost: data['transportCost'],
      miscellaneousCost: data['miscellaneousCost'],
      totalCost: data['totalCost'],
            name: data['name'] ?? '', // Add this

    );
  }
}
