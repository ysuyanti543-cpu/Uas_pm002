import 'package:flutter/material.dart';
import '../services/mock_service.dart';
import '../models.dart';
import '../widgets/app_drawer.dart';
import 'aspirasi_qr_scanner_page.dart';

class ResidentPage extends StatelessWidget {
  static const routeName = '/resident';
  const ResidentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pengajuan = MockService.instance.getPengajuan();

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Dashboard Warga'),
      ),
      body: pengajuan.isEmpty
          ? const Center(
              child: Text('Belum ada pengajuan'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pengajuan.length,
              itemBuilder: (context, index) {
                final p = pengajuan[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.jenisLayanan,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('Pemohon: ${p.namaPemohon}'),
                        const SizedBox(height: 8),
                        _statusBadge(p.status),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.qr_code_scanner),
        onPressed: () {
          Navigator.pushNamed(
            context,
            AspirasiQrScannerPage.routeName,
          );
        },
      ),
    );
  }

  Widget _statusBadge(StatusPengajuan status) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        _statusText(status),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _statusText(StatusPengajuan status) {
    switch (status) {
      case StatusPengajuan.diajukan:
        return 'Diajukan';
      case StatusPengajuan.diproses:
        return 'Diproses';
      case StatusPengajuan.ditolak:
        return 'Ditolak';
      case StatusPengajuan.selesai:
        return 'Selesai';
    }
  }

  Color _statusColor(StatusPengajuan status) {
    switch (status) {
      case StatusPengajuan.diajukan:
        return Colors.orange;
      case StatusPengajuan.diproses:
        return Colors.blue;
      case StatusPengajuan.ditolak:
        return Colors.red;
      case StatusPengajuan.selesai:
        return Colors.green;
    }
  }
}
