import 'package:flutter/material.dart';
import 'dashboard_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _processLogin() async {
    String phone = _phoneController.text.trim();

    // 1. Validasi Input Kosong
    if (phone.isEmpty) {
      _showErrorSnackBar('Masukkan nomor HP Anda!');
      return;
    }

    // 2. Validasi Format Nomor Indonesia (Harus diawali 08/628 dan panjang 10-14 digit)
    RegExp idPhoneRegex = RegExp(r'^(08|628|\+628)[0-9]{8,11}$');
    if (!idPhoneRegex.hasMatch(phone)) {
      _showErrorSnackBar('Nomor HP tidak valid! Gunakan format 08xxxxxxxxx');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulasi Cek Keamanan / Pengecekan Database
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    // 3. Jika nomor valid & terverifikasi, langsung masuk ke Dashboard
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selamat datang, $phone!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101927),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo Utama Laila Net
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF1E293B),
                    border: Border.all(color: Colors.cyan, width: 2),
                  ),
                  child: const Icon(Icons.shield, size: 50, color: Colors.cyan),
                ),
                const SizedBox(height: 30),
                
                const Text(
                  'Selamat Datang di\nLaila Net',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                
                const Text(
                  'Masukkan nomor telepon kartu aktif Anda untuk mengakses layanan internet aman.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 40),

                // Form Input Nomor Telepon
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone_android, color: Colors.cyan),
                    hintText: 'Contoh: 08123456789',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.cyan),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.cyan, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Tombol Masuk / Masuk Layanan
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isLoading ? null : _processLogin,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.login, color: Colors.black),
                              SizedBox(width: 8),
                              Text(
                                'Masuk ke Layanan',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
