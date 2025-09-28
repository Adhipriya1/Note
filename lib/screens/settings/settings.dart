import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Removes back button in BottomNav
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFFAF7FC),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFAF7FC),
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Account', style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black
              ),),
              const SizedBox(height: 12),
              profileTile(),
              settingsTile(Icons.logout, 'Logout', () {
                
              }),
              const SizedBox(height: 24),
              Text('Preferences', style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black
              )),
              const SizedBox(height: 12),
              themeTile(),
              const SizedBox(height: 24),
              Text('Support', style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black
              ),),
              const SizedBox(height: 12),
              settingsTile(
                Icons.notifications,
                'Notifications',
                () {},
                trailing: Switch(value: false, onChanged: (_) {}),
              ),
              settingsTile(Icons.help_outline, 'Help Center', () {}),
              settingsTile(Icons.email_outlined, 'Contact Us', () {}),
            ],
          ),
        ),
      ),
    );
  }

  final sectionTitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black
  );

  Widget profileTile() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 24,
        backgroundImage: AssetImage('assets/images/profile.png'),
        onBackgroundImageError: (_, __) {}, // Avoids crash if image is missing
      ),
      title: const Text(
        'Profile',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 16,
          color: Colors.black
        ),
      ),
      subtitle: const Text('Edit Your Profile',
      style: TextStyle(
        color: Colors.black
      ),),
      onTap: () {},
    );
  }

  Widget settingsTile(IconData icon, String title, VoidCallback onTap,
      {Widget? trailing}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 20),
      ),
      title: Text(title,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w800
      ),),
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget themeTile() {
    return settingsTile(Icons.wb_sunny_outlined, 'Theme', () {});
  }
}
