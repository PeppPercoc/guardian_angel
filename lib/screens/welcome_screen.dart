import 'package:flutter/material.dart';
import 'package:guardian_angel/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _controller = PageController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  int _pageIndex = 0;

  void _saveAndContinue() async {
    final prefs = await SharedPreferences.getInstance();
    // Salva i dati inseriti
    await prefs.setString('userName', _nameController.text);
    await prefs.setString('userSurname', _surnameController.text);
    await prefs.setBool('introSeen', true); // Così mostri la schermata solo al primo avvio!
    if(context.mounted) {
      Navigator.of(context).pushReplacementNamed("/main");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index) => setState(() => _pageIndex = index),
        children: [
          _buildWelcomePage(),
          _buildUserInfoPage(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 18.0, left: 12, right: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_pageIndex > 0)
              TextButton(
                onPressed: () => _controller.previousPage(duration: Duration(milliseconds: 300), curve: Curves.ease),
                child: Text('Indietro'),
              ),
            Spacer(),
            (_pageIndex == 0)
                ? ElevatedButton(
                    onPressed: () => _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease),
                    child: Text('Avanti'),
                  )
                : ElevatedButton(
                    onPressed: _saveAndContinue,
                    child: Text('Salva e inizia'),
                  )
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.security, color: AppColors.primary, size: 80),
            SizedBox(height: 28),
            Text(
              'Benvenuto in Guardian Angel!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 22),
            Text(
              'Prima di iniziare, inserisci alcune informazioni utili per la tua sicurezza.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoPage() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('I tuoi dati:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 18),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Nome'),
          ),
          SizedBox(height: 12),
          TextField(
            controller: _surnameController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Cognome'),
          ),
        ],
      ),
    );
  }
}
