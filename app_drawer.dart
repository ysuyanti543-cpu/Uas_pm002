import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/mock_service.dart';
import '../pages/aspirasi_qr_scanner_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // ================= HEADER =================
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.account_balance,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'DEWAN PERWAKILAN RAKYAT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Aspirasi & Pengaduan Rakyat',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ================= MENU =================
            _item(context, Icons.login, 'Login', '/login'),
            _item(context, Icons.dashboard, 'Dashboard Warga', '/resident'),
            _item(context, Icons.store, 'Data Petugas / UMKM', '/seller'),
            _item(context, Icons.group, 'Manajemen Petugas', '/manage-user'),
            _item(context, Icons.assignment, 'Layanan', '/layanan'),
            _item(context, Icons.article, 'Administrasi', '/administrasi'),
            _item(context, Icons.how_to_reg, 'Administrasi Kependudukan', '/administrasi-kependudukan'),
            _item(context, Icons.admin_panel_settings, 'Admin Panel', '/admin'),
            _item(context, Icons.check_circle_outline, 'Persetujuan Layanan', '/persetujuan-petugas'),

            ListTile(
              leading: const Icon(Icons.qr_code_scanner),
              title: const Text('Pindai QR Aspirasi'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AspirasiQrScannerPage()),
                );
              },
            ),

            _item(context, Icons.picture_as_pdf, 'Laporan Aspirasi (PDF)', '/laporan-aspirasi'),

          

            ListTile(
              leading: const Icon(Icons.arrow_back),
              title: const Text('Kembali'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ================= HELPER =================
  Widget _item(BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }
}
