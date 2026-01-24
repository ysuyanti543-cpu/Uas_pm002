import 'package:cloud_firestore/cloud_firestore.dart';
import '../models.dart';
import 'mock_service.dart';

class FirebaseService {
  FirebaseService._();

  static FirebaseService? _instance;

  static FirebaseService get instance {
    _instance ??= FirebaseService._();
    return _instance!;
  }

  FirebaseFirestore get _db => FirebaseFirestore.instance;

  CollectionReference get _col => _db.collection('pengajuan');

  // ================= STREAM =================
  Stream<List<PengajuanLayanan>> streamPengajuan() {
    // Use MockService for data
    return Stream.value(MockService.instance.getPengajuan());
  }

  // ================= UPDATE STATUS =================
  Future<void> updateStatus(String id, StatusPengajuan status) {
    MockService.instance.updateStatus(id, status);
    return Future.value();
  }

  // ================= TAMBAH PENGAJUAN =================
  Future<String> tambahPengajuan(PengajuanLayanan pengajuan) {
    MockService.instance.addPengajuan(
      pengajuan.jenisLayanan,
      pengajuan.namaPemohon,
      pengajuan.nik,
      pengajuan.keterangan,
    );
    // Return a mock ID
    return Future.value('mock_${DateTime.now().millisecondsSinceEpoch}');
  }
}
