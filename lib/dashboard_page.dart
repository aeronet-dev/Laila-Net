import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isConnected = false;
  int _activeMinutes = 5; // Durasi awal

  // Fungsi untuk simulasi Hubungkan/Putuskan VPN
  void _toggleVpnConnection() {
    setState(() {
      _isConnected = !_isConnected;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isConnected ? 'VPN Terhubung ke Server' : 'VPN Terputus'),
        backgroundColor: _isConnected ? Colors.green : Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Fungsi untuk Klaim Free Trial
  void _claimFreeTrial() {
    setState(() {
      _activeMinutes += 30; // Tambah 30 menit
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Berhasil klaim Free Trial 30 Menit! Masa aktif bertambah.'),
        backgroundColor: Colors.green,
      ),
    );
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
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.cyan.withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.signal_cellular_alt, color: Colors.cyan, size: 16),
                SizedBox(width: 6),
                Text(
                  '24 ms',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Kotak Masa Aktif
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.cyan.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Masa Aktif:',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  Text(
                    '$_activeMinutes Menit Aktif',
                    style: const TextStyle(
                      color: Colors.cyan,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tombol Klaim Free Trial (Sekarang Berfungsi)
            InkWell(
              onTap: _claimFreeTrial,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.cyan.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Klaim Free Trial 30 Menit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Khusus Pengguna Baru (Tanpa Kuota)',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                    const Icon(Icons.arrow_forward_ios, color: Colors.cyan, size: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Indikator Status Lingkaran VPN
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isConnected ? Colors.green : Colors.redAccent,
                  width: 4,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isConnected ? Icons.lock : Icons.lock_open,
                    size: 60,
                    color: _isConnected ? Colors.green : Colors.redAccent,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _isConnected ? 'ONLINE' : 'OFFLINE',
                    style: TextStyle(
                      color: _isConnected ? Colors.green : Colors.redAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isConnected ? 'Terhubung' : 'Terputus',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Tombol Utama Hubungkan / Putuskan
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
                onPressed: _toggleVpnConnection,
                child: Text(
                  _isConnected ? 'Putuskan Koneksi' : 'Hubungkan Sekarang',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
