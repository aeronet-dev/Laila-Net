import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'url_launcher_helper.dart';
import 'main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = 'Pengguna Laila Net';
  String _userPhone = '085890014896';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'Pengguna Laila Net';
      _userPhone = prefs.getString('user_phone') ?? '085890014896';
    });
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AuthPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101927),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101927),
        elevation: 0,
        title: const Text('Akun Saya', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF1E293B),
                      border: Border.all(color: Colors.cyan, width: 2),
                    ),
                    child: const Icon(Icons.person, size: 40, color: Colors.cyan),
                  ),
                  const SizedBox(height: 12),
                  Text(_userName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(_userPhone, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.cyan.withOpacity(0.2)),
              ),
              child: ListTile(
                leading: const Icon(Icons.support_agent, color: Colors.cyan),
                title: const Text('Pusat Bantuan / Hubungi Admin', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: const Text('Laporkan kendala koneksi atau voucher', style: TextStyle(color: Colors.grey, fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () => UrlLauncherHelper.openWhatsApp('6285890014896', 'Halo Admin Laila Net, saya butuh bantuan kendala aplikasi.'),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.cyan.withOpacity(0.2)),
              ),
              child: ListTile(
                leading: const Icon(Icons.help_outline, color: Colors.cyan),
                title: const Text('Panduan & FAQ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: const Text('Cara menggunakan aplikasi & klaim voucher', style: TextStyle(color: Colors.grey, fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: const Color(0xFF1E293B),
                      title: const Text('Panduan Laila Net', style: TextStyle(color: Colors.white)),
                      content: const Text(
                        '1. Klaim Free Trial 30 Menit di menu Toko bagi pengguna baru.\n\n'
                        '2. Masukkan kode voucher jika Anda membelinya dari admin.\n\n'
                        '3. Tekan Hubungkan Sekarang pada tab VPN untuk mulai menjelajah.',
                        style: TextStyle(color: Colors.grey),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Tutup', style: TextStyle(color: Colors.cyan)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.redAccent.withOpacity(0.2)),
              ),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text('Keluar Akun (Logout)', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                onTap: () => _logout(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
