import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<void> addToFavorites(String userId, Map<String, dynamic> mealData) async {

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(mealData['idMeal'])
          .set(mealData);

  }


Future<void> removeFavorite(String userId, String mealId) async {
  final snapshot = await _firestore
      .collection('users')
      .doc(userId)
      .collection('favorites')
      .where('idMeal', isEqualTo: mealId)
      .get();

  for (var doc in snapshot.docs) {
    await doc.reference.delete();
  }
}

  Future<bool> isFavorite(String userId, String mealId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(mealId)
          .get();
      return doc.exists;
    } catch (e) {
      print('$e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getFavorites(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .get();

      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('$e');
      return [];
    }
  }
}
