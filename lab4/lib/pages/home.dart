import 'package:flutter/material.dart';
import '../controllers/auth_services.dart';
import '../controllers/crud_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'update_contact.dart'; // THÊM DÒNG NÀY

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
        actions: [
          IconButton(
            onPressed: () => AuthService().signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: CRUDService().getContacts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text("Lỗi xảy ra"));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Danh sách trống"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index];
              return ListTile(
                title: Text(data['name']),
                subtitle: Text(data['phone']),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => CRUDService().deleteContact(data.id),
                ),
                onTap: () {
                  // ĐIỀU HƯỚNG SANG TRANG UPDATE VÀ TRUYỀN DỮ LIỆU
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateContactPage(
                        docId: data.id,
                        name: data['name'],
                        phone: data['phone'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, "/add"),
        child: const Icon(Icons.add),
      ),
    );
  }
}