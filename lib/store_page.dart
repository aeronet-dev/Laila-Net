import 'package:flutter/material.dart';
import 'api_service.dart';

class StorePage extends StatefulWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final TextEditingController _voucherController = TextEditingController();

  void _redeemVoucher() {
    String code = _voucherController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan kode voucher fisik terlebih dahulu!')),
      );
      return;
    }

    ApiService.tambahWaktu(2.0); // Tambah 2 jam sebagai contoh
    ApiService.addAdminLog('Berhasil tukar voucher fisik: $code');
    
    _voucherController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voucher berhasil digunakan! Masa aktif bertambah.')),
    );
    setState(() {});
  }

  void _showPaymentDialog(String packageName, int hours, int price) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF101927),
          title: Text(
            'Pembayaran $packageName',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Silakan scan QRIS di bawah ini menggunakan aplikasi M-Banking atau E-Wallet Anda:',
                style: TextStyle(color: Colors.grey, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.qr_code_2, size: 150, color: Colors.black),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Total Bayar: Rp $price',
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Durasi Didapat: $hours Jam',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
              onPressed: () {
                Navigator.pop(context);
                ApiService.tambahWaktu(hours.toDouble());
                ApiService.addAdminLog('Pembayaran sukses untuk paket: $packageName');
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Pembayaran berhasil! Paket $packageName aktif.')),
                );
                setState(() {});
              },
              child: const Text('Konfirmasi Pembayaran Selesai', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101927),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B), // Diperbaiki dari 0xFF11E293B
        title: const Text('Toko Voucher Internet', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Bagian Voucher Fisik
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B), // Diperbaiki dari 0xFF11E293B
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.cyan.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Punya Kode Voucher Fisik?',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Masukkan kode voucher di bawah untuk langsung menambah masa aktif.',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _voucherController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Contoh: AVENET2H',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFF101927),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                    onPressed: _redeemVoucher,
                    child: const Text('Gunakan Voucher', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Daftar Paket Berlangganan',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Pilihan Paket
          _buildPackageCard('Voucher Kilat 2 Jam', 2, 1000, '3 Mbps', false),
          _buildPackageCard('Voucher Hemat 7 Jam', 7, 2000, '5 Mbps', true),
          _buildPackageCard('Voucher Harian (24 Jam)', 24, 5000, '5 Mbps', false),
          _buildPackageCard('Voucher Mingguan', 168, 25000, '8 Mbps', false),
        ],
      ),
    );
  }

  Widget _buildPackageCard(String name, int hours, int price, String speed, bool isPopular) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B), // Diperbaiki dari 0xFF11E293B
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isPopular ? Colors.cyan : Colors.transparent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isPopular)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.cyan, borderRadius: BorderRadius.circular(6)),
              child: const Text('PALING POPULER', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              Text('Rp $price', style: const TextStyle(color: Colors.cyan, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text('Durasi: $hours Jam  •  Speed: $speed', style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
              onPressed: () => _showPaymentDialog(name, hours, price),
              child: const Text('Beli Voucher Sekarang', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
