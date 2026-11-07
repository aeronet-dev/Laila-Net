import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'url_launcher_helper.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final TextEditingController _voucherController = TextEditingController();
  bool _hasClaimedTrial = false;

  @override
  void initState() {
    super.initState();
    _checkTrialStatus();
  }

  Future<void> _checkTrialStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _hasClaimedTrial = prefs.getBool('has_claimed_trial') ?? false;
    });
  }

  // Klaim Free Trial 30 Menit (Hanya 1 kali seumur hidup aplikasi per perangkat)
  Future<void> _claimFreeTrial() async {
    final prefs = await SharedPreferences.getInstance();
    bool claimed = prefs.getBool('has_claimed_trial') ?? false;

    if (claimed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anda sudah pernah mengklaim Free Trial sebelumnya!'), backgroundColor: Colors.orange),
      );
      return;
    }

    int currentSeconds = prefs.getInt('remaining_seconds') ?? 0;
    int addedSeconds = 30 * 60; // 30 Menit
    int totalSeconds = currentSeconds + addedSeconds;

    await prefs.setInt('remaining_seconds', totalSeconds);
    await prefs.setBool('has_claimed_trial', true);
    await prefs.setString('active_package_name', 'Paket Free Trial (Aktif)');

    setState(() {
      _hasClaimedTrial = true;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Berhasil! Free Trial 30 Menit telah ditambahkan.'), backgroundColor: Colors.green),
    );
  }

  // Redeem / Aktivasi Voucher Kode
  Future<void> _activateVoucher() async {
    String code = _voucherController.text.trim().toUpperCase();

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan kode voucher terlebih dahulu!'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    // Simulasi database kode voucher nyata (Dapat dihubungkan ke backend 3x-ui / API Anda)
    int addedMinutes = 0;
    if (code == 'LAILANET1H') {
      addedMinutes = 60;
    } else if (code == 'LAILANET24H') {
      addedMinutes = 24 * 60;
    } else if (code == 'VIP30DAYS') {
      addedMinutes = 30 * 24 * 60;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kode Voucher Tidak Valid / Kedaluwarsa!'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    int currentSeconds = prefs.getInt('remaining_seconds') ?? 0;
    int totalSeconds = currentSeconds + (addedMinutes * 60);

    await prefs.setInt('remaining_seconds', totalSeconds);
    await prefs.setString('active_package_name', 'Paket Voucher ($code)');
    _voucherController.clear();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Voucher Berhasil Diaktifkan! +$addedMinutes Menit'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101927),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101927),
        elevation: 0,
        title: const Text('Toko & Voucher', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kotak Banner Free Trial
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.cyan.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Klaim Free Trial 30 Menit', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('Khusus pengguna baru untuk mencoba kecepatan koneksi tanpa kuota.', style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _hasClaimedTrial ? Colors.grey : Colors.cyan,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _hasClaimedTrial ? null : _claimFreeTrial,
                      child: Text(
                        _hasClaimedTrial ? 'Sudah Diklaim' : 'Klaim Sekarang',
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Form Masukkan Kode Voucher
            const Text('Aktivasi Voucher', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _voucherController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Masukkan Kode Voucher',
                hintStyle: TextStyle(color: Colors.grey.shade600),
                filled: true,
                fillColor: const Color(0xFF1E293B),
                prefixIcon: const Icon(Icons.key, color: Colors.cyan),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _activateVoucher,
                child: const Text('Aktifkan Voucher', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 30),

            // Kotak Hubungi Admin via WhatsApp
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.cyan.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.support_agent, size: 40, color: Colors.cyan),
                  const SizedBox(height: 10),
                  const Text('Butuh Voucher / Paket Baru?', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Text('Hubungi admin melalui WhatsApp untuk mendapatkan kode voucher akses cepat.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.cyan),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => UrlLauncherHelper.openWhatsApp('6285890014896', 'Halo Admin Laila Net, saya ingin membeli voucher akses.'),
                      icon: const Icon(Icons.chat, color: Colors.cyan),
                      label: const Text('Beli Voucher via WhatsApp', style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
