import 'dart:async';
import 'api_service.dart';

class VpnService {
  static bool _isConnected = false;
  static Timer? _timer;

  // Konfigurasi Server V2Ray / VLESS Avenet Anda
  static const String serverIp = '103.55.36.173';
  static const int serverPort = 19839;
  static const String uuid = '1d643b7c-dbfe-496a-afa9-6af2326ab510';

  static bool get isConnected => _isConnected;

  // Memulai Koneksi VPN
  static Future<bool> connect(Function() onTick, Function() onExpired) async {
    if (ApiService.sisaWaktu <= 0) {
      return false;
    }

    _isConnected = true;
    ApiService.addAdminLog('VPN VLESS terhubung ke server $serverIp:$serverPort');

    // Timer untuk mengurangi masa aktif setiap 1 menit (60 detik)
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      if (_isConnected) {
        ApiService.kurangiWaktu(1.0); // Kurangi 1 menit
        onTick(); // Perbarui tampilan UI
      }

      // Jika masa aktif habis saat digunakan
      if (ApiService.sisaWaktu <= 0) {
        disconnect();
        onExpired(); // Hentikan koneksi & beri tahu pengguna
      }
    });

    return true;
  }

  // Memutuskan Koneksi VPN
  static void disconnect() {
    _isConnected = false;
    _timer?.cancel();
    ApiService.addAdminLog('VPN VLESS diputus oleh pengguna/sistem');
  }
}
