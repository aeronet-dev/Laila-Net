import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isConnected = false;
  int _remainingSeconds = 0;
  Timer? _countdownTimer;
  String _activePackageName = "Memuat Status...";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  // Muat data masa aktif dan status dari SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _remainingSeconds = prefs.getInt('remaining_seconds') ?? 0;
      _activePackageName = prefs.getString('active_package_name') ?? (_remainingSeconds > 0 ? "Paket Aktif" : "Tidak Ada Paket Aktif");
    });

    // Jika waktu masih ada, pastikan timer berjalan
    if (_remainingSeconds > 0 && !_isConnected) {
      // Otomatis siap/aktif jika waktu tersedia
    }
  }

  // Mulai Hitung Mundur Nyata (Timer.periodic)
  void _startTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('remaining_seconds', _remainingSeconds);
      } else {
        timer.cancel();
        _disconnectVpn();
        setState(() {
          _activePackageName = "Masa Aktif Habis";
        });
      }
    });
  }

  void _toggleConnection() {
    if (_remainingSeconds <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masa aktif habis! Silakan klaim Free Trial atau beli voucher di menu Toko.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isConnected = !_isConnected;
    });

    if (_isConnected) {
      _startTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('VPN Terhubung ke Server Laila Net'), backgroundColor: Colors.green),
      );
    } else {
      _countdownTimer?.cancel();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Koneksi VPN Diputus'), backgroundColor: Colors.orange),
      );
    }
  }

  void _disconnectVpn() {
    setState(() {
      _isConnected = false;
    });
    _countdownTimer?.cancel();
  }

  // Format detik ke bentuk Menit / Jam
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSecs = seconds % 60;
    if (minutes > 60) {
      final hours = minutes ~/ 60;
      final mins = minutes % 60;
      return '$hours Jam $mins Menit Aktif';
    }
    return '$minutes Menit $remainingSecs Detik Aktif';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101927),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101927),
        elevation: 0,
        title: const Text('Laila Net', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.cyan.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.signal_cellular_alt, size: 16, color: Colors.cyan),
                  SizedBox(width: 4),
                  Text('24 ms', style: TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
          )
        ],
      ),
      body: Padding(
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
                  const Text('Masa Aktif:', style: TextStyle(color: Colors.grey, fontSize: 15)),
                  Text(
                    _remainingSeconds > 0 ? _formatTime(_remainingSeconds) : 'Habis / Tidak Aktif',
                    style: TextStyle(
                      color: _remainingSeconds > 0 ? Colors.cyanAccent : Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Tombol Status Lingkaran Utama VPN
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: _toggleConnection,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _isConnected ? Colors.greenAccent : Colors.redAccent,
                        width: 4,
                      ),
                      color: const Color(0xFF1E293B),
                      boxShadow: [
                        BoxShadow(
                          color: (_isConnected ? Colors.greenAccent : Colors.redAccent).withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isConnected ? Icons.lock : Icons.lock_open,
                          size: 60,
                          color: _isConnected ? Colors.greenAccent : Colors.redAccent,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _isConnected ? 'ONLINE' : 'OFFLINE',
                          style: TextStyle(
                            color: _isConnected ? Colors.greenAccent : Colors.redAccent,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isConnected ? 'Terhubung' : 'Terputus',
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Tombol Aksi Bawah
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isConnected ? Colors.redAccent : Colors.cyan,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _toggleConnection,
                child: Text(
                  _isConnected ? 'Putuskan Koneksi' : 'Hubungkan Sekarang',
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
