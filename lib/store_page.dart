import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final TextEditingController _voucherController = TextEditingController();
  String _activePackage = 'Paket Free Trial (Aktif)';
  String _expiredDate = 'Menyesuaikan';

  @override
  void initState() {
    super.initState();
    _loadVoucherData();
  }

  // Memuat data paket dari penyimpanan lokal
  Future<void> _loadVoucherData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _activePackage = prefs.getString('active_package') ?? 'Paket Free Trial (Aktif)';
      _expiredDate = prefs.getString('expired_date') ?? 'Cek Masa Aktif di VPN';
    });
  }

  // Logika Klaim Voucher Sederhana
  Future<void> _redeemVoucher() async {
    final code = _voucherController.text.trim();

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan kode voucher terlebih dahulu!'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    // Simulasi validasi voucher (Nanti bisa diganti dengan API Node.js/SQL)
    if (code == 'LAILANET2026' || code.startsWith('VCH')) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('active_package', 'Paket Premium Bulanan');
      await prefs.setString('expired_date', '30 Hari ke Depan');

      _loadVoucherData();
      _voucherController.clear();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil! Voucher sukses diaktifkan.'), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kode voucher tidak valid atau sudah kedaluwarsa!'), backgroundColor: Colors.redAccent),
      );
    }
  }

  // Fungsi untuk Beli Voucher via WhatsApp Admin
  Future<void> _buyVoucherWhatsApp() async {
    final whatsappUrl = Uri.parse('https://wa.me/6285890014896?text=Halo%20Admin%20Laila%20Net,%20saya%20ingin%20membeli%20voucher%20koneksi.');
    
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka WhatsApp'), backgroundColor: Colors.redAccent),
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
        centerTitle: true,
        title: const Text(
          'Toko & Voucher',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          // Kartu Informasi Paket Saat Ini
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.cyan.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.card_membership, color: Colors.cyan),
                    SizedBox(width: 8),
                    Text(
                      'Status Paket Anda',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _activePackage,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Masa Aktif: $_expiredDate',
                  style: const TextStyle(color: Colors.cyan, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Bagian Input / Klaim Voucher
          const Text(
            'Klaim Voucher',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _voucherController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Masukkan Kode Voucher',
              hintStyle: TextStyle(color: Colors.grey.shade600),
              filled: true,
              fillColor: const Color(0xFF1E293B),
              prefixIcon: const Icon(Icons.vpn_key, color: Colors.cyan),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _redeemVoucher,
              child: const Text(
                'Aktifkan Voucher',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Bagian Beli Voucher Baru via Admin
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(Icons.storefront, size: 40, color: Colors.cyan),
                const SizedBox(height: 12),
                const Text(
                  'Butuh Voucher / Paket Baru?',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Hubungi admin melalui WhatsApp untuk mendapatkan kode voucher akses cepat.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.cyan),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _buyVoucherWhatsApp,
                    icon: const Icon(Icons.support_agent, color: Colors.cyan),
                    label: const Text(
                      'Beli Voucher via WhatsApp',
                      style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
