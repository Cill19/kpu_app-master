import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kpu_app/screens/form_entry_screen.dart';
import 'package:kpu_app/screens/information_screen.dart';
import 'package:kpu_app/screens/view_data_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF407BFF),
        title: Text('Home Screen', style: TextStyle(color: Colors.white)),
        elevation: 0, // Menghilangkan bayangan di bawah AppBar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFB3E5FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Center(
              child: Image.asset(
                "assets/onboarding.png",
                height: 180.0,
                width: 180.0,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(16.0),
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  _buildMenuItem(
                    context,
                    icon: Icons.info,
                    title: 'Informasi',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InformationScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.edit,
                    title: 'Form Entry',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FormEntryScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.list,
                    title: 'Lihat Data',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ViewDataScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.exit_to_app,
                    title: 'Keluar App',
                    onTap: () {
                      SystemNavigator.pop();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Center(
          child: ListTile(
            leading: Icon(
              icon,
              size: 40.0,
              color: Color(0xFF407BFF),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            contentPadding: EdgeInsets.all(16.0),
          ),
        ),
      ),
    );
  }
}
