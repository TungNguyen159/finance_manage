import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String image;
  final String name;

  UserModel({
    required this.email,
    required this.image,
    required this.name,
  });

  // Tạo phương thức từ dữ liệu Map (dữ liệu từ Firestore)
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      email: data['email'] ?? '',
      image: data['image_url'] ?? '',
      name: data['username'] ?? '',
    );
  }
}

Future<List<UserModel>> fetchUsers() async {
  List<UserModel> userList = [];

  try {
    // Truy cập vào collection "users" trên Firestore
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').get();

    // Duyệt qua từng document trong collection
    for (var doc in snapshot.docs) {
      // Lấy dữ liệu và ánh xạ vào đối tượng UserModel
      final user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
      userList.add(user);
    }
  } catch (e) {
    print("Error fetching users: $e");
  }

  return userList;
}
