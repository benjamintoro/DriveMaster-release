import 'package:drive_master/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage1 extends StatelessWidget {
  const ProfilePage1({super.key});

  Future<Map<String, dynamic>?> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return userData.data() as Map<String, dynamic>?;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>?>( 
          future: _fetchUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No se encontró información del usuario.'));
            }

            final userData = snapshot.data!;
            return Center(  
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,  
                crossAxisAlignment: CrossAxisAlignment.center,  
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: userData['photoUrl'] != null
                        ? NetworkImage(userData['photoUrl'])
                        : const AssetImage('assets/images/default_profile.jpg') as ImageProvider,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                    },
                    child: const Text('Subir Foto'),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Mi información:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Nombre: ${userData['firstName']}"),
                        Text("Apellido: ${userData['lastName']}"),
                        Text("Correo: ${userData['email']}"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SignInPage2()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, 
                      foregroundColor: Colors.white, 
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    ),
                    child: const Text('Cerrar Sesión'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
