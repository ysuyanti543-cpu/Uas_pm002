import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models.dart';

class MockService {
  MockService._internal();
  static final MockService instance = MockService._internal();

  final List<Subdistrict> _subdistricts = [];
  final List<Seller> _sellers = [];
  final List<Resident> _residents = [];
  final List<Admin> _admins = [];
  final List<Layanan> _layanans = [];
  final List<PengajuanLayanan> _pengajuans = [];

  /// Dipanggil dari main.dart
  Future<void> initSampleData() async {
    _subdistricts.clear();
    _sellers.clear();
    _residents.clear();
    _admins.clear();
    _layanans.clear();
    _pengajuans.clear();

    // Load saved pengajuans from shared preferences
    await _loadPengajuans();

    /// KELURAHAN
    _subdistricts.addAll(const [
      Subdistrict(id: 'sd1', name: 'Sekejati'),
      Subdistrict(id: 'sd2', name: 'Megasari'),
      Subdistrict(id: 'sd3', name: 'Buah Batu'),
    ]);

    /// SELLER / Anggota Dewan (renamed from UMKM/Petugas)
    _sellers.addAll(const [
      Seller(id: 's1', name: 'Anggota Dewan ', subdistrictId: 'sd1'),
      Seller(id: 's2', name: 'Anggota Dewan ', subdistrictId: 'sd2'),
      Seller(id: 's3', name: 'Anggota Dewan ', subdistrictId: 'sd3'),
    ]);

    /// RESIDENT / WARGA
    _residents.addAll(const [
      Resident(id: 'r1', name: 'Fajar', subdistrictId: 'sd1'),
      Resident(id: 'r2', name: 'Budi', subdistrictId: 'sd2'),
      Resident(id: 'r3', name: 'Subianto', subdistrictId: 'sd3'),
    ]);

    /// ADMIN
    _admins.addAll(const [
      Admin(id: 'a1', name: 'Admin Kelurahan'),
    ]);

    /// LAYANAN KELURAHAN
    _layanans.addAll([
      Layanan(
        id: 'l1',
        nama: 'Administrasi Kependudukan',
        deskripsi: 'KTP, KK, Surat Domisili',
      ),
      Layanan(
        id: 'l2',
        nama: 'Pelayanan Surat',
        deskripsi: 'Surat Pengantar dan Keterangan',
      ),
    ]);

    // SAMPLE PENGAJUAN LAYANAN (only add if no saved data)
    if (_pengajuans.isEmpty) {
      _pengajuans.addAll([
        PengajuanLayanan(id: 'p1', jenisLayanan: 'KTP', namaPemohon: 'Agus', nik: '123456789', keterangan: 'Pengajuan KTP baru', tanggal: DateTime.now().subtract(const Duration(days: 1))),
        PengajuanLayanan(id: 'p2', jenisLayanan: 'KK', namaPemohon: 'Siti', nik: '987654321', keterangan: 'Pengajuan KK', tanggal: DateTime.now().subtract(const Duration(days: 2))),
        PengajuanLayanan(id: 'p3', jenisLayanan: 'Surat Domisili', namaPemohon: 'Rudi', nik: '456789123', keterangan: 'Surat domisili untuk keperluan bank', tanggal: DateTime.now().subtract(const Duration(days: 3))),
      ]);
    }
  }

  /// ================= GET =================
  List<Subdistrict> getSubdistricts() => List.unmodifiable(_subdistricts);
  List<Seller> getSellers() => List.unmodifiable(_sellers);
  List<Admin> getAdmins() => List.unmodifiable(_admins);
  List<Layanan> getLayanans() => List.unmodifiable(_layanans);
  List<PengajuanLayanan> getPengajuan() => List.unmodifiable(_pengajuans);

  void addPengajuan(String jenisLayanan, String namaPemohon, String nik, String keterangan) {
    final id = 'p${_pengajuans.length + 1}';
    final peng = PengajuanLayanan(
      id: id,
      jenisLayanan: jenisLayanan,
      namaPemohon: namaPemohon,
      nik: nik,
      keterangan: keterangan,
    );
    _pengajuans.add(peng);
    _savePengajuans(); // Save after adding
  }

  List<Seller> getSellersBySubdistrict(String subdistrictId) =>
      _sellers.where((s) => s.subdistrictId == subdistrictId).toList();

  List<Resident> getResidentsBySubdistrict(String subdistrictId) =>
      _residents.where((r) => r.subdistrictId == subdistrictId).toList();

  /// ================= CREATE =================
  void addSeller(String name, String subdistrictId) {
    final id = 's${_sellers.length + 1}';
    _sellers.add(Seller(id: id, name: name, subdistrictId: subdistrictId));
  }

  // Aliases / helpers using the "petugas" naming so UI can call getAllPetugas/addPetugas/etc.
  List<Seller> getAllPetugas() => getSellers();

  void addPetugas(String name, String subdistrictId) =>
      addSeller(name, subdistrictId);

  void updatePetugas(String id, String name, String subdistrictId) {
    final index = _sellers.indexWhere((s) => s.id == id);
    if (index != -1) {
      _sellers[index] = Seller(id: id, name: name, subdistrictId: subdistrictId);
    }
  }

  void deletePetugas(String id) {
    _sellers.removeWhere((s) => s.id == id);
  }

  void addLayanan(String nama, String deskripsi) {
    final id = 'l${_layanans.length + 1}';
    _layanans.add(
      Layanan(id: id, nama: nama, deskripsi: deskripsi),
    );
  }

  /// ================= UPDATE =================
  void updateLayanan(String id, String nama, String deskripsi) {
    final index = _layanans.indexWhere((l) => l.id == id);
    if (index != -1) {
      _layanans[index].nama = nama;
      _layanans[index].deskripsi = deskripsi;
    }
  }

  /// ================= DELETE =================
  void deleteLayanan(String id) {
    _layanans.removeWhere((l) => l.id == id);
  }

  /// ================= PENGAJUAN LAYANAN (ALUR PETUGAS) =================
  void updateStatus(String id, StatusPengajuan status) {
    final index = _pengajuans.indexWhere((p) => p.id == id);
    if (index != -1) {
      _pengajuans[index].status = status;
    }
  }

  Future<void> _loadPengajuans() async {
    final prefs = await SharedPreferences.getInstance();
    final pengajuansJson = prefs.getString('pengajuans');
    if (pengajuansJson != null) {
      final List<dynamic> decoded = json.decode(pengajuansJson);
      _pengajuans.clear();
      for (var item in decoded) {
        _pengajuans.add(PengajuanLayanan(
          id: item['id'],
          jenisLayanan: item['jenisLayanan'],
          namaPemohon: item['namaPemohon'],
          nik: item['nik'],
          keterangan: item['keterangan'],
          tanggal: DateTime.parse(item['tanggal']),
          status: StatusPengajuan.values.firstWhere((e) => e.toString().split('.').last == item['status']),
        ));
      }
    }
  }

  Future<void> _savePengajuans() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> pengajuansJson = _pengajuans.map((p) => {
      'id': p.id,
      'jenisLayanan': p.jenisLayanan,
      'namaPemohon': p.namaPemohon,
      'nik': p.nik,
      'keterangan': p.keterangan,
      'tanggal': p.tanggal.toIso8601String(),
      'status': p.status.toString().split('.').last,
    }).toList();
    await prefs.setString('pengajuans', json.encode(pengajuansJson));
  }
}
