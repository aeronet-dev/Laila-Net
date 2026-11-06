class ApiService {
  // Simulasi masa aktif internet & kuota
  static double sisaWaktuAktif = 5.0; 
  static double sisaWaktu = 5.0; 
  static double totalServerQuota = 50.0;

  // Variabel status tambahan yang dipanggil di UI
  static bool isServerMaintenance = false;
  static String referralCode = 'AVENET99';
  static bool isHotspotActive = true;
  static int connectedDevices = 1;
  static bool isFreeTrialClaimed = false;

  // Daftar database kode voucher manual yang valid beserta durasinya (dalam jam)
  static final Map<String, double> validVouchers = {
    'AVENET2H': 2.0,   // Paket Kilat 2 Jam
    'AVENET7H': 7.0,   // Paket Hemat 7 Jam
    'AVENET24H': 24.0, // Paket Harian 24 Jam
    'AVENET1W': 168.0, // Paket Mingguan
  };

  static List<String> adminLogs = [];

  // Fungsi untuk menambah waktu masa aktif
  static void tambahWaktu(double hours) {
    sisaWaktuAktif += hours;
    sisaWaktu = sisaWaktuAktif;
  }

  // Fungsi untuk mengurangi waktu (dipanggil vpn_service)
  static void kurangiWaktu(double hours) {
    sisaWaktuAktif -= hours;
    if (sisaWaktuAktif < 0) sisaWaktuAktif = 0;
    sisaWaktu = sisaWaktuAktif;
  }

  // Fungsi untuk klaim free trial (dipanggil dashboard_page)
  static bool claimFreeTrial() {
    if (!isFreeTrialClaimed) {
      isFreeTrialClaimed = true;
      tambahWaktu(0.5); // Bonus 30 Menit (0.5 Jam)
      addAdminLog('Free trial berhasil diklaim (+30 Menit)');
      return true;
    }
    return false;
  }

  // Fungsi untuk menambah kuota server
  static void addQuota(double amount) {
    totalServerQuota += amount;
  }

  // Fungsi untuk verifikasi PIN Admin
  static bool verifyAdminPin(String pin) {
    return pin == '1234';
  }

  // Fungsi untuk toggle hotspot
  static void toggleHotspot() {
    isHotspotActive = !isHotspotActive;
    addAdminLog(isHotspotActive ? 'Hotspot diaktifkan' : 'Hotspot dimatikan');
  }

  // Fungsi untuk validasi dan redeem voucher manual
  static bool redeemVoucherCode(String code) {
    String upperCode = code.trim().toUpperCase();
    if (validVouchers.containsKey(upperCode)) {
      double hours = validVouchers[upperCode]!;
      tambahWaktu(hours);
      addAdminLog('Berhasil redeem voucher manual: $upperCode (+$hours Jam)');
      return true;
    }
    return false;
  }

  static void addAdminLog(String log) {
    adminLogs.insert(0, '[${DateTime.now().toString().substring(11, 16)}] $log');
  }
}
