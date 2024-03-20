
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/informationUsers.dart';

class InformationService{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  /*
  getQuestionData(String quizId) async{
    return await FirebaseFirestore.instance
        .collection("Quiz")
        .doc(quizId)
        .collection("QNA")
        .get();
  }
  */
  Future<informationUsers> getInformation(String userId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('users').doc(userId).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> userData =
            documentSnapshot.data() as Map<String, dynamic>;

        String firstNameUser = userData['first name'];
        String lastNameUser = userData['last name'];
        int age = userData['age'];
        String address = userData['address'];
        String imageUser = userData['image'];

        informationUsers user = informationUsers(
          firstNameUser: firstNameUser,
          lastNameUser: lastNameUser,
          age: age,
          address: address,
          imageUser: imageUser,
        );

        return user;
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to fetch user information');
    }
  }

  // Các phương thức khác để lấy thông tin khác từ Firebase

  Future<List<informationUsers>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();

      List<informationUsers> userList = [];

      if (querySnapshot.docs.isNotEmpty) {
        for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
          Map<String, dynamic> userData =
              documentSnapshot.data() as Map<String, dynamic>;

          String firstNameUser = userData['firstNameUser'];
          String lastNameUser = userData['lastNameUser'];
          int age = userData['age'];
          String address = userData['address'];
          String imageUser = userData['imageUser'];

          informationUsers user = informationUsers(
            firstNameUser: firstNameUser,
            lastNameUser: lastNameUser,
            age: age,
            address: address,
            imageUser: imageUser,
          );

          userList.add(user);
        }
      }

      return userList;
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to fetch user information');
    }
  }
}