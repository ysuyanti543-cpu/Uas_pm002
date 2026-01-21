import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/mock_service.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
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
                      children: [
                        const Text(
                          'DEWAN PERWAKILAN RAKYAT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Aspirasi & Pengaduan Rakyat',
                          style: TextStyle(
                            color: Colors.white.withAlpha((0.9 * 255).round()),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              onTap: () => Navigator.pushReplacementNamed(context, '/login'),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard Warga'),
              onTap: () => Navigator.pushReplacementNamed(context, '/resident'),
            ),
            ListTile(
              leading: const Icon(Icons.store),
              title: const Text('Data Petugas / UMKM'),
              onTap: () => Navigator.pushReplacementNamed(context, '/seller'),
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('Manajemen Petugas'),
              onTap: () => Navigator.pushReplacementNamed(context, '/manage-user'),
            ),
            ListTile(
              leading: const Icon(Icons.assignment),
              title: const Text('Layanan'),
              onTap: () => Navigator.pushReplacementNamed(context, '/layanan'),
            ),
            ListTile(
              leading: const Icon(Icons.article),
              title: const Text('Administrasi'),
              onTap: () => Navigator.pushReplacementNamed(context, '/administrasi'),
            ),
            ListTile(
              leading: const Icon(Icons.how_to_reg),
              title: const Text('Administrasi Kependudukan'),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/administrasi-kependudukan'),
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Admin Panel'),
              onTap: () => Navigator.pushReplacementNamed(context, '/admin'),
            ),
            ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: const Text('Persetujuan Layanan'),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/persetujuan-petugas'),
            ),
            ListTile(
              leading: const Icon(Icons.qr_code_scanner),
              title: const Text('Scan QR Aspirasi'),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/aspirasi-qr-scan'),
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Submit Aspirasi'),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/submit-aspirasi'),
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Laporan Aspirasi (PDF)'),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/laporan-aspirasi'),
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.arrow_back),
              title: const Text('Kembali'),
              onTap: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
