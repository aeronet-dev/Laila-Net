import 'package:flutter/material.dart';
import 'api_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _pinController = TextEditingController();

  void _toggleHotspot() {
    setState(() {
      ApiService.toggleHotspot();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ApiService.isHotspotActive
              ? 'Hotspot Avenet diaktifkan. Perangkat lain dapat terhubung!'
              : 'Hotspot Avenet dimatikan.',
        ),
      ),
    );
  }

  // Informasi Kontak CS WhatsApp Admin
  void _showWhatsAppInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Row(
          children: [
            Icon(Icons.support_agent, color: Colors.greenAccent),
            SizedBox(width: 8),
            Text('Pusat Bantuan CS', style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        content: const Text(
          'Silakan hubungi Admin Avenet melalui nomor WhatsApp resmi untuk konfirmasi pembayaran dan kendala:\n\n📞 0812-3456-7890',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent),
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // Dialog Akses PIN Admin
  void _showAdminPinDialog() {
    _pinController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Row(
          children: [
            Icon(Icons.admin_panel_settings, color: Colors.cyan),
            SizedBox(width: 8),
            Text('Akses Admin Panel', style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masukkan PIN Rahasia Admin untuk membuka kontrol penuh aplikasi:',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white, letterSpacing: 4.0, fontSize: 18),
              decoration: InputDecoration(
                hintText: 'PIN Admin',
                hintStyle: const TextStyle(color: Colors.grey, letterSpacing: 1.0, fontSize: 14),
                filled: true,
                fillColor: const Color(0xFF101927),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.cyan),
                ),
              ),
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
              if (ApiService.verifyAdminPin(_pinController.text)) {
                Navigator.pop(context);
                _openAdminModal();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('PIN Salah! Akses ditolak.')),
                );
              }
            },
            child: const Text('Masuk', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // Tampilan Panel Admin Utama
  void _openAdminModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF101927),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.security, color: Colors.greenAccent),
                            SizedBox(width: 8),
                            Text(
                              'Internal Admin Panel',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 10),

                    // Statistik Server Global
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Sisa Kapasitas Server:', style: TextStyle(color: Colors.grey, fontSize: 13)),
                              Text('${ApiService.totalServerQuota.toStringAsFixed(1)} GB', style: const TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Status Maintenance Server:', style: TextStyle(color: Colors.grey, fontSize: 13)),
                              Text(
                                ApiService.isServerMaintenance ? 'AKTIF (Sistem Mati)' : 'NORMAL (Layanan On)',
                                style: TextStyle(
                                  color: ApiService.isServerMaintenance ? Colors.redAccent : Colors.greenAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Kontrol Tindakan Admin
                    const Text('Aksi Pengelola:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),

                    // Inject Kuota Darurat
                    ListTile(
                      tileColor: const Color(0xFF1E293B),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      leading: const Icon(Icons.add_chart, color: Colors.cyan),
                      title: const Text('Inject Kuota +10 GB (Pengguna)', style: TextStyle(color: Colors.white, fontSize: 14)),
                      subtitle: const Text('Isi ulang saldo kuota mandiri secara langsung', style: TextStyle(color: Colors.grey, fontSize: 11)),
                      onTap: () {
                        setState(() {
                          ApiService.addQuota(10.0);
                          ApiService.addAdminLog("Admin inject kuota +10 GB");
                        });
                        setModalState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Berhasil menambahkan +10 GB ke akun ini!')),
                        );
                      },
                    ),
                    const SizedBox(height: 8),

                    // Reset Status Free Trial
                    ListTile(
                      tileColor: const Color(0xFF1E293B),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      leading: const Icon(Icons.refresh, color: Colors.orangeAccent),
                      title: const Text('Reset Status Free Trial', style: TextStyle(color: Colors.white, fontSize: 14)),
                      subtitle: const Text('Memungkinkan pengguna mengeklaim trial kembali', style: TextStyle(color: Colors.grey, fontSize: 11)),
                      onTap: () {
                        setState(() {
                          ApiService.isFreeTrialClaimed = false;
                          ApiService.addAdminLog("Admin mereset status Free Trial");
                        });
                        setModalState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Status Free Trial berhasil di-reset!')),
                        );
                      },
                    ),
                    const SizedBox(height: 8),

                    // Switch Mode Maintenance
                    ListTile(
                      tileColor: const Color(0xFF1E293B),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      leading: Icon(
                        Icons.power_settings_new,
                        color: ApiService.isServerMaintenance ? Colors.greenAccent : Colors.redAccent,
                      ),
                      title: Text(
                        ApiService.isServerMaintenance ? 'Matikan Mode Maintenance' : 'Aktifkan Mode Maintenance',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      subtitle: const Text('Mengunci koneksi seluruh pengguna', style: TextStyle(color: Colors.grey, fontSize: 11)),
                      onTap: () {
                        setState(() {
                          ApiService.isServerMaintenance = !ApiService.isServerMaintenance;
                          ApiService.addAdminLog(ApiService.isServerMaintenance ? "Server diatur ke Mode Maintenance" : "Server dinormalkan kembali");
                        });
                        setModalState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              ApiService.isServerMaintenance ? 'Mode Maintenance Aktif.' : 'Mode Maintenance Dimatikan.',
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Riwayat Log Aktivitas Admin
                    const Text('Riwayat Aktivitas Admin:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ApiService.adminLogs.isEmpty
                          ? const Text('Belum ada aktivitas tercatat.', style: TextStyle(color: Colors.grey, fontSize: 12))
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: ApiService.adminLogs
                                  .map((log) => Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                                        child: Text(log, style: const TextStyle(color: Colors.greenAccent, fontSize: 11, fontFamily: 'monospace')),
                                      ))
                                  .toList(),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Akun & Hotspot Avenet',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
              // Tombol Rahasia Admin di Sudut Kanan Atas
              IconButton(
                icon: const Icon(Icons.admin_panel_settings_outlined, color: Colors.cyan),
                tooltip: 'Panel Admin',
                onPressed: _showAdminPinDialog,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Profil Mitra
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.cyan.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.cyan,
                  child: Icon(Icons.person, size: 35, color: Colors.black),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Mitra Avenet',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'status: Member Aktif (VIP)',
                      style: TextStyle(fontSize: 13, color: Colors.greenAccent),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Tombol Bantuan / Hubungi WhatsApp CS
          InkWell(
            onTap: _showWhatsAppInfo,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.support_agent, color: Colors.greenAccent, size: 28),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pusat Bantuan / CS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        SizedBox(height: 2),
                        Text('Hubungi admin via WhatsApp untuk kendala', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: Colors.greenAccent, size: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Referral
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Kode Referral Anda', style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ApiService.referralCode,
                      style: const TextStyle(color: Colors.cyan, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Kode referral disalin ke clipboard!')),
                        );
                      },
                      icon: const Icon(Icons.copy, size: 16, color: Colors.black),
                      label: const Text('Salin', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Kontrol Hotspot
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: ApiService.isHotspotActive ? Colors.greenAccent.withOpacity(0.5) : Colors.cyan.withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.wifi_tethering, color: Colors.cyan, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Distribusi Hotspot VPN',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Switch(
                      value: ApiService.isHotspotActive,
                      activeColor: Colors.greenAccent,
                      onChanged: (val) => _toggleHotspot(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  ApiService.isHotspotActive
                      ? 'Status: Aktif Membagikan Koneksi Terenkripsi'
                      : 'Status: Nonaktif (Nyalakan untuk berbagi internet ke perangkat lain)',
                  style: TextStyle(color: ApiService.isHotspotActive ? Colors.greenAccent : Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 12),
                Divider(color: Colors.grey.withOpacity(0.2)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Perangkat Terhubung:', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                    Text(
                      '${ApiService.connectedDevices} Perangkat',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
