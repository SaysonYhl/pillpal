import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pillpal/constants.dart';
import 'package:pillpal/global_bloc.dart';
import 'package:pillpal/user_auth/auth_service.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: kErrorBorderColor,
                    width: 3,
                  ),
                ),
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(
                    user?.photoURL ??
                        'https://images.app.goo.gl/LEQrX3wnxp2FrQny8',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                user?.email ?? 'No Email',
                style: const TextStyle(fontSize: 18, color: kTextColor),
              ),
              const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  await _globalBloc.removeAllMedicines();
                  await AuthService().signOut(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kErrorBorderColor,
                  fixedSize: const Size(150, 50),
                ),
                child: const Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
