import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart'; // Untuk membuka link/WhatsApp
import 'main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = 'Pengguna Laila Net';
  String _userPhone = '-';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'Pengguna Laila Net';
      _userPhone = prefs.getString('user_phone') ?? '-';
    });
  }

    // Fungsi untuk membuka WhatsApp Admin
  Future<void> _contactAdmin() async {
    // Nomor WhatsApp sudah disesuaikan ke +6285890014896 (format internasional tanpa tanda +)
    final whatsappUrl = Uri.parse('https://wa.me/6285890014896?text=Halo%20Admin%20Laila%20Net,%20saya%20mengalami%20kendala%20pada%20aplikasi.');
    
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka WhatsApp'), backgroundColor: Colors.redAccent),
      );
    }
  }


  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Hapus sesi login

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
        centerTitle: true,
        title: const Text(
          'Akun Saya',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          // Bagian Profil Header
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.cyan,
                  child: Icon(Icons.person, size: 50, color: Colors.black),
                ),
                const SizedBox(height: 16),
                Text(
                  _userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _userPhone,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Menu Bantuan / Hubungi Admin
          ListTile(
            tileColor: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: const Icon(Icons.support_agent, color: Colors.cyan),
            title: const Text(
              'Pusat Bantuan / Hubungi Admin',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              'Laporkan kendala koneksi atau voucher via WhatsApp',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.cyan, size: 16),
            onTap: _contactAdmin,
          ),
          const SizedBox(height: 12),

          // Menu Panduan / FAQ Sederhana
          ListTile(
            tileColor: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: const Icon(Icons.help_outline, color: Colors.cyan),
            title: const Text(
              'Panduan & FAQ',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              'Cara menggunakan aplikasi & klaim voucher',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.cyan, size: 16),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xFF1E293B),
                  title: const Text('Panduan Penggunaan', style: TextStyle(color: Colors.white)),
                  content: const Text(
                    '1. Pastikan masa aktif Anda mencukupi.\n'
                    '2. Tekan "Hubungkan Sekarang" pada menu VPN untuk memulai koneksi aman.\n'
                    '3. Masukkan kode voucher di menu Toko untuk memperpanjang masa aktif.',
                    style: TextStyle(color: Colors.grey, height: 1.5),
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
          const SizedBox(height: 12),

          // Menu Logout
          ListTile(
            tileColor: const Color(0xFF1E293B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text(
              'Keluar Akun (Logout)',
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xFF1E293B),
                  title: const Text('Keluar Akun', style: TextStyle(color: Colors.white)),
                  content: const Text(
                    'Apakah Anda yakin ingin keluar dari akun ini?',
                    style: TextStyle(color: Colors.grey),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _logout();
                      },
                      child: const Text('Keluar', style: TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
