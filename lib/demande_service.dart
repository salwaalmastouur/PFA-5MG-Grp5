// demande_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

import 'demande_model.dart';

class DemandeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> ajouterDemande(Demande demande) async {
    try {
      await _firestore.collection('demandes').add({
        'etudiantId': demande.etudiantId,
        'dateDemande': demande.dateDemande,
        'depart': demande.depart,
        'destination': demande.destination,
        'dateDepart': demande.dateDepart,
        'dateRetour': demande.dateRetour,
        'status': demande.status,
        'adminId': demande.adminId,
        'accommodationCost': demande.accommodationCost,
        'foodCost': demande.foodCost,
        'transportCost': demande.transportCost,
        'miscellaneousCost': demande.miscellaneousCost,
        'totalCost': demande.totalCost,
      });
    } catch (e) {
      print('Erreur lors de l\'ajout de la demande : $e');
    }
  }
Stream<List<Demande>> getDemandesByStatus(String etudiantId, String status1, String status2) {
  return _firestore
      .collection('demandes')
      .where('etudiantId', isEqualTo: etudiantId)
      .where('status', whereIn: [status1, status2])
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => Demande.fromFirestore(doc)).toList());
}


Stream<List<Demande>> getDemandesEnAttente() {
  return _firestore
      .collection('demandes')
      .where('status', isEqualTo: 'En attente')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => Demande.fromFirestore(doc)).toList());
}
Stream<List<Demande>> getDemandesByEmployeeAndStatus(String etudiantId, List<String> statuses) {
  return _firestore
      .collection('demandes')
      .where('etudiantId', isEqualTo: etudiantId)
      .where('status', whereIn: statuses)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => Demande.fromFirestore(doc)).toList());
}

  Stream<List<Demande>> getDemandesEtudiantStream(String etudiantId) {
    return _firestore
        .collection('demandes')
        .where('etudiantId', isEqualTo: etudiantId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Demande.fromFirestore(doc)).toList());
  }

  Stream<List<Demande>> getDemandesAdminStream(String adminId) {
    return _firestore
        .collection('demandes')
        .where('adminId', isEqualTo: adminId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Demande.fromFirestore(doc)).toList());
  }

  Future<void> validerDemande(String demandeId) async {
    try {
      await _firestore
          .collection('demandes')
          .doc(demandeId)
          .update({'status': 'Validée'});
    } catch (e) {
      print('Erreur lors de la validation de la demande : $e');
    }
  }

  Future<void> refuserDemande(String demandeId) async {
    try {
      await _firestore
          .collection('demandes')
          .doc(demandeId)
          .update({'status': 'Refusée'});
    } catch (e) {
      print('Erreur lors du refus de la demande : $e');
    }
  }

Stream<List<Demande>> getAllDemandesStream() {
  return _firestore.collection('demandes').snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Demande.fromFirestore(doc)).toList());
}
}