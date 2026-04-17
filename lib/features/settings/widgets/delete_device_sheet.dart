import 'package:flutter/material.dart';

class DeleteDeviceSheet extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteDeviceSheet({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    const dangerColor = Color(0xFFD91A1A);
    const primaryColor = Color(0xFF0A910A);

    return Container(
      height: 200,
      width: 412, // Akan menyesuaikan layar jika lebar HP kurang dari 412
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const Text(
            "Menghapus Perangkat ?",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: dangerColor,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Apakah kamu serius ingin menghapus perangkat ini?",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const Text(
            "* kamu harus konfigurasi ulang jika ingin menghubungkannya kembali",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
          const Spacer(),
          Row(
            children: [
              // Tombol Batalkan
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: primaryColor),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("Batalkan", style: TextStyle(color: primaryColor)),
                ),
              ),
              const SizedBox(width: 16),
              // Tombol Hapus
              Expanded(
                child: OutlinedButton(
                  onPressed: onDelete,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: dangerColor),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("Hapus Perangkat", style: TextStyle(color: dangerColor)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
