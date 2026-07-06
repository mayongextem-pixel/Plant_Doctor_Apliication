import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../config/app_constants.dart';
import '../../config/app_theme.dart';

class AdminUserRiwayatScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final String token;

  const AdminUserRiwayatScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.token,
  });

  @override
  State<AdminUserRiwayatScreen> createState() => _AdminUserRiwayatScreenState();
}

class _AdminUserRiwayatScreenState extends State<AdminUserRiwayatScreen> {
  List<dynamic> _riwayatList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserRiwayat();
  }

  Future<void> _fetchUserRiwayat() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.laravelApiBaseUrl}/admin/users/${widget.userId}/riwayat'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _riwayatList = data['data']['data'] ?? [];
        });
      }
    } catch (_) {}
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteRiwayat(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Hapus riwayat scan ini secara permanen?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      await http.delete(
        Uri.parse('${AppConstants.laravelApiBaseUrl}/admin/riwayat/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Riwayat berhasil dihapus'),
            backgroundColor: AppTheme.successGreen,
          ),
        );
      }
      _fetchUserRiwayat();
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  void _showEditForm(Map<String, dynamic> riwayat) {
    final diseaseCtrl = TextEditingController(text: riwayat['disease_name'] ?? '');
    final accCtrl = TextEditingController(text: (riwayat['accuracy'] ?? '').toString());
    final descCtrl = TextEditingController(text: riwayat['description'] ?? '');
    String severity = riwayat['severity'] ?? 'sehat';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, sc) => Padding(
            padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16),
            child: ListView(controller: sc, children: [
              Center(
                child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(height: 16),
              const Text('Edit Riwayat Scan', style: AppTheme.titleMedium),
              const SizedBox(height: 16),
              TextField(
                  controller: diseaseCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Penyakit/Spesies', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(
                  controller: accCtrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                      labelText: 'Akurasi (0.0 - 1.0)', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: severity,
                decoration: const InputDecoration(
                    labelText: 'Tingkat Keparahan', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: 'sehat', child: Text('Sehat')),
                  DropdownMenuItem(value: 'sakit', child: Text('Sakit')),
                  DropdownMenuItem(value: 'kritis', child: Text('Kritis')),
                ],
                onChanged: (v) => setS(() => severity = v!),
              ),
              const SizedBox(height: 12),
              TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(
                      labelText: 'Deskripsi Tambahan',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true),
                  maxLines: 4),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    minimumSize: const Size.fromHeight(50)),
                onPressed: () async {
                  Navigator.pop(ctx);
                  setState(() => _isLoading = true);

                  final body = jsonEncode({
                    'disease_name': diseaseCtrl.text,
                    'accuracy': double.tryParse(accCtrl.text) ?? 0.0,
                    'severity': severity,
                    'description': descCtrl.text,
                  });

                  try {
                    await http.put(
                      Uri.parse('${AppConstants.laravelApiBaseUrl}/admin/riwayat/${riwayat['id']}'),
                      headers: {
                        'Accept': 'application/json',
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer ${widget.token}',
                      },
                      body: body,
                    );
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Riwayat berhasil diperbarui'),
                          backgroundColor: AppTheme.successGreen,
                        ),
                      );
                    }
                  } catch (_) {}
                  _fetchUserRiwayat();
                },
                child: const Text('Simpan Perubahan',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('Riwayat: ${widget.userName}'),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen))
          : _riwayatList.isEmpty
              ? Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Icon(Icons.history_rounded,
                          size: 72,
                          color: AppTheme.textLight.withValues(alpha: 0.4)),
                      const SizedBox(height: 16),
                      Text('Belum ada riwayat scan',
                          style: AppTheme.bodyLarge
                              .copyWith(color: AppTheme.textLight)),
                    ]))
              : RefreshIndicator(
                  onRefresh: _fetchUserRiwayat,
                  color: AppTheme.primaryGreen,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _riwayatList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final item = _riwayatList[i] as Map<String, dynamic>;
                      final isHealthy = item['severity'] == 'sehat';
                      return Container(
                        decoration: AppTheme.cardDecoration,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isHealthy
                                ? AppTheme.successGreen.withValues(alpha: 0.15)
                                : AppTheme.errorRed.withValues(alpha: 0.15),
                            child: Icon(
                                isHealthy
                                    ? Icons.eco_rounded
                                    : Icons.warning_rounded,
                                color: isHealthy
                                    ? AppTheme.successGreen
                                    : AppTheme.errorRed),
                          ),
                          title: Text(item['disease_name'] ?? '-',
                              style: AppTheme.titleSmall),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 2),
                              Text('Akurasi: ${((double.tryParse(item['accuracy']?.toString() ?? '0') ?? 0.0) * 100).toStringAsFixed(1)}%',
                                  style: AppTheme.bodySmall),
                              Text('Tanggal: ${item['scanned_at'] != null ? item['scanned_at'].toString().split('T')[0] : '-'}',
                                  style: AppTheme.bodySmall.copyWith(fontSize: 11)),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_rounded,
                                    color: AppTheme.primaryGreen, size: 20),
                                onPressed: () => _showEditForm(item),
                                tooltip: 'Edit',
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_rounded,
                                    color: AppTheme.errorRed, size: 20),
                                onPressed: () => _deleteRiwayat(item['id']),
                                tooltip: 'Hapus',
                              ),
                            ],
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
