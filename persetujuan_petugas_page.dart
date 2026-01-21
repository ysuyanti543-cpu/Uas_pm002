import 'package:flutter/material.dart';
import '../models.dart';
import '../services/mock_service.dart';
import '../widgets/app_drawer.dart';
import 'aspirasi_qr_page.dart';

class PersetujuanPetugasPage extends StatefulWidget {
  static const routeName = '/persetujuan-petugas';
  const PersetujuanPetugasPage({super.key});

  @override
  State<PersetujuanPetugasPage> createState() =>
      _PersetujuanPetugasPageState();
}

class _PersetujuanPetugasPageState
    extends State<PersetujuanPetugasPage> {
  @override
  Widget build(BuildContext context) {
    final data = MockService.instance.getPengajuan();

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Persetujuan Layanan'),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final p = data[index];
          return Card(
            margin: const EdgeInsets.all(12),
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

                  // STATUS BADGE
                  _statusBadge(p.status),

                  const SizedBox(height: 12),

                  // AKSI PETUGAS
                  _aksiPetugas(p),
                ],
              ),
            ),
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

  Widget _aksiPetugas(PengajuanLayanan p) {
    final qrButton = IconButton(
      icon: const Icon(Icons.qr_code),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AspirasiQrPage(pengajuan: p),
          ),
        );
      },
    );

    // TAHAP 1
    if (p.status == StatusPengajuan.diajukan) {
      return Row(
        children: [
          qrButton,
          ElevatedButton.icon(
            icon: const Icon(Icons.check),
            label: const Text('Setujui'),
            onPressed: () {
              setState(() {
                MockService.instance.updateStatus(
                  p.id,
                  StatusPengajuan.diproses,
                );
              });
            },
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.close),
            label: const Text('Tolak'),
            onPressed: () {
              setState(() {
                MockService.instance.updateStatus(
                  p.id,
                  StatusPengajuan.ditolak,
                );
              });
            },
          ),
        ],
      );
    }

    // TAHAP 2
    if (p.status == StatusPengajuan.diproses) {
      return Row(
        children: [
          qrButton,
          ElevatedButton.icon(
            icon: const Icon(Icons.done_all),
            label: const Text('Selesaikan'),
            onPressed: () {
              setState(() {
                MockService.instance.updateStatus(
                  p.id,
                  StatusPengajuan.selesai,
                );
              });
            },
          ),
        ],
      );
    }

    // TAHAP AKHIR
    return Row(
      children: [
        qrButton,
        Text(
          _statusText(p.status),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
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
