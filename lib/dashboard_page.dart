import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isConnected = false;
  bool _isLoading = false;

  // Simulasi status data seluler perangkat
  final bool _isCellularOn = true; 

  void _toggleConnection() async {
    // 1. Pastikan Data Seluler aktif (ON) sebelum menghubungkan
    if (!_isCellularOn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap aktifkan Data Seluler terlebih dahulu!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulasi proses koneksi VPN (meskipun kuota 0/OPOK, tetap berjalan)
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _isConnected = !_isConnected;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isConnected ? 'Terhubung ke Laila Net!' : 'Koneksi diputus.'),
          backgroundColor: _isConnected ? Colors.green : Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101927),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101927),
        elevation: 0,
        title: const Text(
          'Laila Net',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isConnected ? Colors.green : Colors.cyan.withOpacity(0.5),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _isConnected ? Icons.signal_cellular_connected_no_internet_4_bar : Icons.signal_cellular_alt,
                    size: 14,
                    color: _isConnected ? Colors.green : Colors.cyan,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _isConnected ? 'Aktif' : '24 ms',
                    style: TextStyle(
                      color: _isConnected ? Colors.green : Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Kartu Masa Aktif
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.cyan.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Masa Aktif:', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  Text('5 Menit Aktif', style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Banner Free Trial
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.cyan.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Klaim Free Trial 30 Menit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Khusus Pengguna Baru (Tanpa Kuota)', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.cyan),
                ],
              ),
            ),
            
            const Spacer(),

            // Indikator Lingkaran Status VPN
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _isConnected ? Colors.green : Colors.redAccent,
                    width: 4,
                  ),
                  color: const Color(0xFF1E293B).withOpacity(0.5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isConnected ? Icons.lock_open : Icons.lock,
                      size: 50,
                      color: _isConnected ? Colors.green : Colors.redAccent,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _isConnected ? 'ONLINE' : 'OFFLINE',
                      style: TextStyle(
                        color: _isConnected ? Colors.green : Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isConnected ? 'Terhubung' : 'Terputus',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Tombol Hubungkan / Putuskan
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
                onPressed: _isLoading ? null : _toggleConnection,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : Text(
                        _isConnected ? 'Putuskan Koneksi' : 'Hubungkan Sekarang',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF101927),
        selectedItemColor: Colors.cyan,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.shield), label: 'VPN'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Toko'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }
}
